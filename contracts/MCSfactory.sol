// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";

contract CampaignFactory {
    mapping(address => Campaign) public campaigns;
    address[] addressKeyLUT;

    uint256 public campaignCount = 0;

    event CampaignCreated(address addressNewCampaign);

    function createCampaign(string memory _name,int256 _lat,int256 _lng, int256 _range) public payable returns (address payable) {
        require(msg.sender != address(0), "invalid address provided");
        require(msg.value >= 1, "not enough found");
        require(!searchSourcerAddress(msg.sender),"this sourcer already has an active campaign");
        Campaign newCampaign = new Campaign();
        newCampaign.initialize(_name, _lat, _lng,_range,msg.sender);
        campaigns[msg.sender] = newCampaign;
        addressKeyLUT.push(msg.sender);
        campaignCount++;
        emit CampaignCreated(address(newCampaign));
        // bisogna trasferire il denaro pagato all'indirizzo della factory a quello della campagna
        return payable(address(newCampaign));
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
            outPut[i] = campaigns[addressKeyLUT[i]];
        }
        return outPut;
    }
}
