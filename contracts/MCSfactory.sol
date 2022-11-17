// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";

contract CampaignFactory {

    mapping(address => Campaign) public campaigns;
    uint256 public campaignCount = 0;

    event CampaignCreated(address addressNewCampaign);

    function createCampaign(string memory _name, int256 _lat, int256 _lng) public payable returns (address payable) {
        require(msg.sender != address(0));
        require(msg.value >= 1);
        require(campaigns[] < 0);
        Campaign newCampaign = new Campaign();
        newCampaign.initialize(_name, _lat, _lng,msg.sender);
        campaigns[msg.sender] = newCampaign;
        campaignCount++;
        emit CampaignCreated(address(newCampaign));
        // bisogna trasferire il denaro pagato all'indirizzo della factory a quello della campagna
        return payable(address(newCampaign));
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        return campaigns;
    }

}
