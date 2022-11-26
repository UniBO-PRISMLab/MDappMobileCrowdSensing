// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CampaignFactory {
    mapping(address => Campaign) public activeCampaigns;
    mapping(address => Campaign[]) public closedCampaigns;

    address[] internal addressKeyLUT;
    address[] internal addressClosedKeyLUT;

    function getLUT() public view returns (address[] memory){
        address[] memory out = new address[](addressKeyLUT.length);
        for (uint i = 0; i < addressKeyLUT.length; i++){
            out[i] = addressKeyLUT[i];
        }
        return out;
    }


    uint256 public campaignCount = 0;

    event CampaignCreated(address addressNewCampaign);

    function createCampaign(string memory _name,int256 _lat,int256 _lng, int256 _range, string memory _type) public payable returns (address payable) {
        require(msg.sender != address(0), "invalid address provided");
        // require(msg.value >= 1, "not enough found");
        require(!searchSourcerAddress(msg.sender),"this sourcer already has an active campaign");
        Campaign newCampaign = new Campaign();
        newCampaign.initialize(_name, _lat, _lng,_range,_type,msg.sender);
        activeCampaigns[msg.sender] = newCampaign;
        addressKeyLUT.push(msg.sender);
        campaignCount++;
        emit CampaignCreated(address(newCampaign));
        // bisogna trasferire il denaro pagato all'indirizzo della factory a quello della campagna
        return payable(address(newCampaign));
    }

    function closeCampaign() public{
        require(msg.sender != address(0), "invalid address provided");
        activeCampaigns[msg.sender].closeCampaign();
        closedCampaigns[msg.sender].push(activeCampaigns[msg.sender]);
        delete activeCampaigns[msg.sender];

        for (uint i = 0; i < addressKeyLUT.length; i++){
            if(addressKeyLUT[i] == msg.sender) {
                addressClosedKeyLUT.push(msg.sender);
                _burnLUT(i);
            }

        }

    }

    function _burnLUT(uint index) internal {
        require(index < addressKeyLUT.length);
        addressKeyLUT[index] = addressKeyLUT[addressKeyLUT.length-1];
        addressKeyLUT.pop();
    }

    function searchSourcerAddress(address _address) public view returns (bool) {
        require(msg.sender != address(0), "invalid address provided");
        for (uint256 i = 0; i < addressKeyLUT.length; i++) {
            if (addressKeyLUT[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory outPut = new Campaign[](addressKeyLUT.length);
        for (uint256 i = 0; i < addressKeyLUT.length; i++) {
            outPut[i] = activeCampaigns[addressKeyLUT[i]];
        }
        return outPut;
    }

    function getClosedCampaigns() public view returns (Campaign[] memory) {
        require(msg.sender != address(0), "invalid address provided");
        return(closedCampaigns[msg.sender]);
    }
}
