// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";

contract CampaignFactory {
  
  Campaign[] campaigns;
  
  uint256 fileCount = 0; // number of the hashes uploaded

  event CampaignCreated(address addressNewCampaign);

  function getNumberOfCampaigns() public view returns(uint256) {
    return fileCount;
  }

  function createCampaign(string memory _name,int256 _lat,int256 _lng) public payable returns (address) {
    require(msg.value >= 1);

    Campaign newCampaign = new Campaign();
    newCampaign.initialize(_name, _lat, _lng);
    campaigns.push(newCampaign);
    fileCount++;
    emit CampaignCreated(address(newCampaign));
    return address(newCampaign);
  }
}