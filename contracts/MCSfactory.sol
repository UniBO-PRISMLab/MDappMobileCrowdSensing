// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";
import "./MCScoin.sol";
import "./FactoryManager.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "hardhat/console.sol";

contract CampaignFactory is FactoryManager{

    address public coinAddress;
    MCSCoin internal coin;

    constructor(address  _addressCoinContract) payable {
        coinAddress=_addressCoinContract;
        coin = MCSCoin(coinAddress);
    }

    function createCampaign(string memory _name,int256 _lat,int256 _lng, int256 _range, string memory _type,uint256 _value) public override payable returns (address ) {
        require(msg.sender != address(0), "invalid address provided");
        require(_value >= 1,"not enough value in message");
        //address sender = payable(msg.sender);
        //uint256 balance = coin.balanceOf(sender);
        //require(balance >= _value,"not enough found in your balance");
        require(!searchSourcerAddress(msg.sender),"this sourcer already has an active campaign");
        Campaign newCampaign = new Campaign(_name, _lat, _lng,_range,_type,(msg.sender),(address(this)),(address(coin)));
        address newCampaignAddress = payable(address(newCampaign));
        //coin.approve(payable(address(this)),_value);
        //coin.transferFrom(sender,newCampaignAddress,_value);
        activeCampaigns[msg.sender] = newCampaign;
        addressKeyLUT.push(msg.sender);
        return (newCampaignAddress);
    }

    function closeCampaign() external override returns (bool){
        if(address(activeCampaigns[tx.origin])!=address(0)) {
            require(tx.origin == activeCampaigns[tx.origin].addressCrowdSourcer(),'you are not the campaign owner');
            closedCampaigns[tx.origin].push(activeCampaigns[tx.origin]);
            delete activeCampaigns[tx.origin];
            for (uint i = 0; i < addressKeyLUT.length; i++){
                if(addressKeyLUT[i] == tx.origin) {
                    addressClosedKeyLUT.push(tx.origin);
                    _burnLUT(i);
                }
            }
            return true;
        } else {
            return false;
        }
    }

}