// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";
import "./MCScoin.sol";
import "./HubContract.sol";
import "./FactoryContract.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "hardhat/console.sol";

contract HubContract {
    MCScoin public coin;
    CampaignFactory public factory;
    
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private activeCampaigns;
    
    mapping (address => Campaign[]) public closedCampaigns;

    mapping(address => address) public addressCrowdSourcerActiveCampaigns;
    uint256 totalActiveCampaigns;

    mapping(address => bool) public addressCrowdSourcerClosedCampaigns;
    uint256 totalClosedCampaigns;

    mapping(address => CampaignToClaim[]) public campaignsToClaim;
    mapping(address => uint) public credits;

    struct CampaignToClaim {
        address campaignAddress;
        string role;
        uint256 toClaim;
    }

    constructor() {
        coin = new MCScoin(1);
        coin.transfer(msg.sender,1000000000000000000);
        console.log("COIN trasferiti dal contratto: %s", coin.balanceOf(msg.sender));
        factory = new CampaignFactory(address(this));
    }

    function getCampaignsToClaim()
        external
        view
        returns (CampaignToClaim[] memory)
    {
        return campaignsToClaim[msg.sender];
    }

    function putCampaignToClaim(
        address account,
        address campaignAddress,
        string calldata role,
        uint256 toClaim
    ) external {
        campaignsToClaim[account].push(
            CampaignToClaim(campaignAddress, role, toClaim)
        );
    }

    function removeCampaignToClaim(address campaignAddress) internal {
        CampaignToClaim[] storage campaignArray = campaignsToClaim[msg.sender];
        for (uint256 i = 0; i < campaignArray.length; i++) {
            if (campaignArray[i].campaignAddress == campaignAddress) {
                campaignArray[i] = campaignArray[campaignArray.length - 1];
                campaignArray.pop();
                break;
            }
        }
    }

    function withdrawCredits() public {
        require(coin.balanceOf(address(this)) >= credits[msg.sender], "can't withdraw more than campaign balance");
        coin.transfer(msg.sender,credits[msg.sender]);
        removeCampaignToClaim(address(this));
        delete credits[msg.sender];
    }

    function allowForPull(address receiver, uint amount) external{
        credits[receiver] += amount;
    }

    function createCampaign(
        string calldata name,
        int256 lat,
        int256 lng,
        int256 range,
        string calldata campaignType,
        uint256 value,
        address sourcer
    ) external returns (address){
       address newCampaignAddress = factory.createCampaign(name,lat,lng,range,campaignType,sourcer);
       require(newCampaignAddress != address(0),"Campaign creation Error");
       if(value > 0)
        coin.transfer(newCampaignAddress,value);
        _addCampaignToSet(sourcer,newCampaignAddress);
        return newCampaignAddress;
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory outPut = new Campaign[](totalActiveCampaigns);
        for (uint256 i = 0; i < totalActiveCampaigns; i++) {
            outPut[i] = Campaign(EnumerableSet.at(activeCampaigns,i));
        }
        return outPut;
    }

    function getClosedCampaigns() public view returns (Campaign[] memory) {
        require(msg.sender != address(0), "invalid address provided");
        return(closedCampaigns[msg.sender]);
    }

    function closeCampaign(address sourcer,address campaign) external returns (bool){
        console.log(
            "DEBUG:\n addressCrowdSourcerActiveCampaigns: %s \n msg.sender: %s \n sourcer: %s",
            addressCrowdSourcerActiveCampaigns[sourcer],
            msg.sender,
            sourcer);
        //address campaignAddress = addressCrowdSourcerActiveCampaigns[sourcer];
        //require (campaignAddress != address(0),"invalid crowdsourcer address");
        //require(EnumerableSet.contains(activeCampaigns,campaignAddress),"the campaign is not Active");
        //require(tx.origin == campaign.addressCrowdSourcer(),"you are not the campaign owner");
        closedCampaigns[sourcer].push(Campaign(campaign));
        bool setIsRemoved = EnumerableSet.remove(activeCampaigns,campaign);
        delete addressCrowdSourcerActiveCampaigns[sourcer];
        totalActiveCampaigns--;
        totalClosedCampaigns++;
        return setIsRemoved;    
    }

    function getActiveCampaign(address sourcer) public view returns(Campaign) {
        return Campaign(addressCrowdSourcerActiveCampaigns[sourcer]);
    }

    function checkIfSourcerHasActiveCampaign(address sourcer) public view returns(bool) {
        return EnumerableSet.contains(activeCampaigns,addressCrowdSourcerActiveCampaigns[sourcer]);
    }

    function _addCampaignToSet(address owner,address newCampaign) internal {
        addressCrowdSourcerActiveCampaigns[owner] = newCampaign;
        EnumerableSet.add(activeCampaigns,newCampaign);
        totalActiveCampaigns++;
    }
}