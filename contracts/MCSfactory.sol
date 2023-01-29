// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";
import "./MCScoin.sol";
import "./FactoryManager.sol";
import "hardhat/console.sol";

contract CampaignFactory is MCScoin {

    FactoryManager factoryManager;

    constructor (uint256 reward,address factoryManagerAddress) ERC20("Mobile Crowd Sensing Coin", "MCSCoin") {
        _mint(msg.sender, 10000000 * (10 ** uint256(decimals())));
        blockReward = reward * (10 ** uint(decimals()));
        factoryManager = FactoryManager(factoryManagerAddress);
    }


    function createCampaign(string memory _name,int256 _lat,int256 _lng, int256 _range, string memory _type,uint256 _value) public payable returns (address) {
        address owner = _msgSender();
        require(!factoryManager._checkIfSourcerHasActiveCampaign(owner),"this sourcer already has an active campaign");
        address to = factoryManager._createCampaign(_name, _lat, _lng,_range,_type,(msg.sender),(address(this)));
        _transfer(owner,payable(to), _value);
        return to;
    }

    function closeCampaign() external returns (bool){
        return factoryManager._closeCampaign();
    }

    function getClosedCampaigns() public view returns (Campaign[] memory) {
        return factoryManager._getClosedCampaigns(msg.sender);
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        return factoryManager._getAllCampaigns();
    }

    function getActiveCampaign() public view returns (Campaign) {
        return factoryManager._getActiveCampaign(msg.sender);
    }

}