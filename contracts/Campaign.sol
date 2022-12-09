// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Campaign is Ownable, Initializable {
    bool internal isClosed;
    string internal name;
    int256 internal lat;
    int256 internal lng;
    int256 internal range;
    string internal campaignType;
    address internal addressCrowdSourcer;
    mapping(string => File) public files; // ipfs hash -> file info

    string[] public allfilesPath;

    function getValidFiles() public view onlyOwner returns(string[] memory){
        string[] memory out = new string[](allfilesPath.length);
        for(uint i; i<allfilesPath.length; i++) {
            if ((files[allfilesPath[i]].status == true) && (files[allfilesPath[i]].validity == true)) {
                out[i] = allfilesPath[i];
            }
        }
        return out;
    }

    uint256 public fileCount = 0;
    uint256 public checkedFiles = 0;

    function getInfo() public view returns(string memory,int256,int256,int256,string memory,address,uint256) {
        return(name,lat,lng,range,campaignType,addressCrowdSourcer,fileCount);
    }

    struct File {
        bool status;
        bool validity;
        address payable uploader;
    }

    function closeCampaign() external onlyOwner{
        isClosed = true;
    }

    constructor(string memory _name,int256 _lat,int256 _lng,int256 _range,string memory _type,address _addressCrowdSourcer) payable onlyOwner initializer {
        name = _name;
        lat = _lat;
        lng = _lng;
        range = _range;
        campaignType = _type;
        addressCrowdSourcer = _addressCrowdSourcer;
        isClosed = false;
        transferOwnership(_addressCrowdSourcer);
    }

    event FileUploaded(address payable uploader);

    function uploadFile(string memory ipfspath,int256 _fileLat,int256 _fileLng) public {
        require(msg.sender != address(0));
        require(isClosed == false,'The campaign is closed by sourcer');
        require(isInRange(_fileLat,_fileLng),'position out of area');
        fileCount++;
        allfilesPath.push(ipfspath);
        files[ipfspath] = File(false,false,payable(msg.sender));
        emit FileUploaded(payable(msg.sender));
    }

    function sqrt(int256 x) internal pure returns (int256 y) {
        int256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    function calculateDistance(int256 latFile, int256 lonFile) public view returns (int256 dist) {
        int256 distance = sqrt((latFile - lat)**2 + (lonFile - lng)**2);
        return int256(distance);
    }

    function isInRange(int256 latFile, int256 lonFile) public view returns (bool answer){
        if ((range*1000) >= calculateDistance(latFile,lonFile)) {
            return true;
        }
        return false;
    }


    function validateFile(string memory hash) public {
        files[hash].validity = true;
        files[hash].status = true;
        checkedFiles++;
    }

}
