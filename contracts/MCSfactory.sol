// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";

contract CampaignFactory {
    mapping(address => Campaign) public activeCampaigns;
    mapping(address => Campaign) public closedCampaigns;

    address[] addressKeyLUT;

    uint256 public campaignCount = 0;

    event CampaignCreated(address addressNewCampaign);

    function createCampaign(string memory _name,int256 _lat,int256 _lng, int256 _range, string memory _type) public payable returns (address payable) {
        require(msg.sender != address(0), "invalid address provided");
        require(msg.value >= 1, "not enough found");
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
        activeCampaigns[msg.sender].closeCampaign();
        closedCampaigns[msg.sender] = activeCampaigns[msg.sender];
        delete activeCampaigns[msg.sender];

        for (uint i = 0; i < addressKeyLUT.length; i++){
            if(addressKeyLUT[i] == msg.sender)
                delete addressKeyLUT[i];
        }

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
            if (address(activeCampaigns[addressKeyLUT[i]]) != address(0))
                outPut[i] = activeCampaigns[addressKeyLUT[i]];
        }
        return outPut;
    }

    function getClosedCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory outPut = new Campaign[](addressKeyLUT.length);
        for (uint256 i = 0; i < addressKeyLUT.length; i++) {
            if (address(closedCampaigns[addressKeyLUT[i]]) != address(0))
                outPut[i] = closedCampaigns[addressKeyLUT[i]];
        }
        return outPut;
    }
}
