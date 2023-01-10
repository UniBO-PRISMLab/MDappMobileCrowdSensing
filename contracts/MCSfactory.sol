// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";
import "./MCScoin.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "hardhat/console.sol";

contract CampaignFactory {
    MCSCoin public coin = MCSCoin(0xd9145CCE52D386f254917e481eB44e9943F39138);
    mapping( address => Campaign) public activeCampaigns; // address sourcer -> campagna
    mapping( address => Campaign[]) public closedCampaigns; // address sourcer -> lista di campagne
    address[] internal addressKeyLUT;
    address[] internal addressClosedKeyLUT;

    function searchSourcerAddress(address _address) public view returns (bool) {
        require(msg.sender != address(0), "invalid address provided");
        for (uint256 i = 0; i < addressKeyLUT.length; i++) {
            if (addressKeyLUT[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function createCampaign(string memory _name,int256 _lat,int256 _lng, int256 _range, string memory _type,uint256 _value) public payable returns (address ) {
        require(msg.sender != address(0), "invalid address provided");
        require(_value >= 1,"not enough value in message");
        address sender = payable(msg.sender);
        uint256 balance = coin.balanceOf(sender);
        require(balance >= _value,"not enough found in your balance");
        require(!searchSourcerAddress(msg.sender),"this sourcer already has an active campaign");
        Campaign newCampaign = new Campaign(_name, _lat, _lng,_range,_type,(msg.sender),(address(this)));
        address newCampaignAddress = payable(address(newCampaign));
        coin.approve(payable(address(this)),_value);
        uint256 allowed = allowance(payable(address(this)),sender);
        coin.transferFrom(sender,newCampaignAddress,_value);
        activeCampaigns[msg.sender] = newCampaign;
        addressKeyLUT.push(msg.sender);
        return (newCampaignAddress);
    }

    function _burnLUT(uint index) internal {
        require(index < addressKeyLUT.length);
        addressKeyLUT[index] = addressKeyLUT[addressKeyLUT.length-1];
        addressKeyLUT.pop();
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory outPut = new Campaign[](addressKeyLUT.length);
        for (uint256 i = 0; i < addressKeyLUT.length; i++) {
            outPut[i] = activeCampaigns[addressKeyLUT[i]];
        }
        return outPut;
    }

    function getClosedCampaigns() public view returns (Campaign[] memory) {
        require(msg.sender != address(0), "invalid address provided");
        return(closedCampaigns[msg.sender]);
    }

    function closeCampaign() external returns (bool){
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