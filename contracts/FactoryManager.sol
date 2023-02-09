// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";
import "./MCScoin.sol";
import "./FactoryManager.sol";
import "hardhat/console.sol";

contract FactoryManager {

    mapping( address => Campaign) public activeCampaigns;
    mapping( address => Campaign[]) public closedCampaigns;

    address[] public addressCrowdSourcerActiveCampaigns;
    address[] public addressCrowdSourcerClosedCampaigns;

    function _createCampaign(string memory _name,int256 _lat,int256 _lng, int256 _range, string memory _type,address sourcer, address factoryAddress) public returns (address){
        Campaign newCampaign = new Campaign(_name, _lat, _lng,_range,_type,sourcer,factoryAddress);
        activeCampaigns[sourcer] = newCampaign;
        addressCrowdSourcerActiveCampaigns.push(sourcer);
        return (address(newCampaign));
    }

    function _getAllCampaigns() external view returns (Campaign[] memory) {
        Campaign[] memory outPut = new Campaign[](addressCrowdSourcerActiveCampaigns.length);
        for (uint256 i = 0; i < addressCrowdSourcerActiveCampaigns.length; i++) {
            outPut[i] = activeCampaigns[addressCrowdSourcerActiveCampaigns[i]];
        }
        return outPut;
    }

    function _getClosedCampaigns(address sourcer) external view returns (Campaign[] memory) {
        require(sourcer != address(0), "invalid address provided");
        return(closedCampaigns[sourcer]);
    }

    function _closeCampaign() external returns (bool){
        require(tx.origin == activeCampaigns[tx.origin].addressCrowdSourcer(),'you are not the campaign owner');
        closedCampaigns[tx.origin].push(activeCampaigns[tx.origin]);
        delete activeCampaigns[tx.origin];
        for (uint i = 0; i < addressCrowdSourcerActiveCampaigns.length; i++){
            if(addressCrowdSourcerActiveCampaigns[i] == tx.origin) {
                addressCrowdSourcerClosedCampaigns.push(tx.origin);
                addressCrowdSourcerActiveCampaigns[i] = addressCrowdSourcerActiveCampaigns[addressCrowdSourcerActiveCampaigns.length-1];
                addressCrowdSourcerActiveCampaigns.pop();
                return true;
            }
        }
        return false;
    }

    function _checkIfSourcerHasActiveCampaign(address sourcer) external view returns(bool) {
        return (address(activeCampaigns[sourcer]) == address(0))? false : true;
    }

    function _getActiveCampaign(address sourcer) external view returns(Campaign) {
        return activeCampaigns[sourcer];
    }

}