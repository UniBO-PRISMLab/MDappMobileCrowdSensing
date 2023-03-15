// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./HubContract.sol";

contract Campaign is Ownable, Initializable {

    string internal name;
    int256 internal lat;
    int256 internal lng;
    int256 internal range;
    string internal campaignType;

    address public addressCrowdSourcer;
    uint256 public fileCount = 0;
    uint256 public checkedFiles = 0;
    uint256 public validFiles = 0;
    uint256 public numberOfActiveWorkers = 0;
    uint256 public numberOfActiveVerifiers = 0;
    bool public isClosed;
    HubContract internal hub;

    mapping(string => File) public files; // ipfs hash -> file info

    string[] public allfilesPath;

    struct File {
        bool status;
        bool validity;
        address  uploader;
        address verifier;
        string hash;
        int256 lat;
        int256 lng;
    }

    constructor(
        string memory _name,
        int256 _lat,
        int256 _lng,
        int256 _range,
        string memory _type,
        address  _addressCrowdSourcer,
        address  _hubAddress) onlyOwner initializer {
        name = _name;
        lat = _lat;
        lng = _lng;
        range = _range;
        campaignType = _type;
        addressCrowdSourcer =_addressCrowdSourcer;
        hub = HubContract(_hubAddress);
        isClosed = false;
        transferOwnership(_addressCrowdSourcer);
    }

    function getAllFilesInfo() public view returns(File[] memory){
        File[] memory out = new File[](allfilesPath.length);
        for(uint i = 0; i<allfilesPath.length; i++) {
            out[i] = files[allfilesPath[i]];
        }
        return out;
    }

    function getValidFiles() public view onlyOwner returns(string[] memory){
        string[] memory out = new string[](allfilesPath.length);
        for(uint i; i<allfilesPath.length; i++) {
            if ((files[allfilesPath[i]].status == true) && (files[allfilesPath[i]].validity == true)) {
                out[i] = allfilesPath[i];
            }
        }
        return out;
    }

    function getInfo() public view returns(string memory,int256,int256,int256,string memory,address,uint256) {
        return(name,lat,lng,range,campaignType,addressCrowdSourcer,fileCount);
    }

    
    event FileUploaded(address  uploader);

    function uploadFile(string memory ipfspath,int256 _fileLat,int256 _fileLng) public {
        require(msg.sender != address(0));
        require(isClosed == false,'The campaign is closed by sourcer');
        fileCount++;
        numberOfActiveWorkers++;
        allfilesPath.push(ipfspath);
        files[ipfspath] = File(false,false,(msg.sender),address(0),ipfspath, _fileLat, _fileLng);
        emit FileUploaded((msg.sender));
    }

    function validateFile(string memory hash) public {
        //require(msg.sender != files[hash].uploader,"you can't self verify the data.");
        files[hash].validity = true;
        files[hash].status = true;
        files[hash].verifier = msg.sender;
        checkedFiles++;
        validFiles++;
        numberOfActiveVerifiers++;
    }

    function notValidateFile(string memory hash) public {
        //require(msg.sender != files[hash].uploader,"you can't self verify the data.");
        files[hash].status = true;
        files[hash].verifier = msg.sender;
        checkedFiles++;
        numberOfActiveVerifiers++;
    }

    function getCampaignBalance() public view returns(uint256 balance) {
        return hub.coin().balanceOf(address(this));
    }


    struct CampaignToClaim {
        address campaignAddress;
        string role;
        uint256 toClaim;
    }

        
    function allowForPull(address receiver, uint amount) internal{
        hub.allowForPull(receiver,amount);
    }

    function closeCampaignAndPay() public onlyOwner{
        require(numberOfActiveVerifiers > 0, 'you cant close a campaign without verifier');
        hub.closeCampaign(addressCrowdSourcer,address(this));
        uint256 balance = getCampaignBalance();
        uint256 verifiesTotalReward = (balance * 50 / 100);
        if(validFiles == 0) { // caso in cui non ci siano dati validi
            uint256 refound = balance - verifiesTotalReward;
            uint256 verifierReward = verifiesTotalReward / numberOfActiveVerifiers;
            hub.putCampaignToClaim(addressCrowdSourcer,address(this), "refound", refound);
            allowForPull(addressCrowdSourcer, refound);
            for(uint i; i<allfilesPath.length; i++) {
                File memory currentFile = files[allfilesPath[i]];
                if (currentFile.status == true) {
                    hub.putCampaignToClaim(currentFile.verifier,address(this), "verifier", verifierReward);
                    allowForPull(currentFile.verifier, verifierReward);
                }
            }
        } else {
            uint256 workerReward =  (balance - verifiesTotalReward) / validFiles;
            uint256 verifierReward = verifiesTotalReward / numberOfActiveVerifiers;
            for(uint i; i<allfilesPath.length; i++) {
                File memory currentFile = files[allfilesPath[i]];
                if (currentFile.status == true) {
                    if (currentFile.validity == true) { // se il file caricato è valido allora paga l'uploader
                        hub.putCampaignToClaim(currentFile.verifier,address(this), "verifier", verifierReward);
                        hub.putCampaignToClaim(currentFile.uploader,address(this), "worker", workerReward);
                        allowForPull(currentFile.verifier, verifierReward);
                        allowForPull(currentFile.uploader, workerReward);
                    } else { // se il file caricato NON è valido allora paga solo il verifier
                        hub.putCampaignToClaim(currentFile.verifier,address(this), "verifier", verifierReward);
                        allowForPull(currentFile.verifier, verifierReward);
                    }
                }
            }
        }
    }

}
