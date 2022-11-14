// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";
import "@openzeppelin/contracts/utils/Create2.sol";

contract CampaignFactory {
  
  address[] public addressCampaign;
  
  uint256 public fileCount = 0; // number of the hashes uploaded


  constructor (address _addressCampaign) {
    fileCount++;
    addressCampaign.push(_addressCampaign);
  }

  function createCampaign(string memory _name,uint256 _lat,uint _lng) public returns (address){
    Campaign newCampaign = new Campaign();
    address newCampaignAddress = address(newCampaign.initialize(_name,_lat,_lng));
    addressCampaign.push(address(newCampaign));
    require(msg.value >= 1);
    return address(addressCampaign[fileCount-1]);
  }
}