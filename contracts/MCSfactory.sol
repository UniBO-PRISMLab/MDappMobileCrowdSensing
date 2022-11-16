// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";

contract CampaignFactory {
  
  Campaign[] campaigns;
  
  uint256 public campaignCount = 0;

  event CampaignCreated(address addressNewCampaign);

  function getCamapaigns() public view returns(address[] memory) {
    address[] memory paths;
        for (uint256 i= 0; i<campaignCount; i++) {
            paths[i] = address(campaigns[i]);
        }
        return paths;
  }

  function createCampaign(string memory _name,int256 _lat,int256 _lng) public payable returns (address) {
    require(msg.sender != address(0));
    require(msg.value >= 1);

    Campaign newCampaign = new Campaign();
    newCampaign.initialize(_name, _lat, _lng);
    campaigns.push(newCampaign);
    campaignCount++;
    emit CampaignCreated(address(newCampaign));
    return address(newCampaign);
  }
}