// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";
import "./MCScoin.sol";
import "./FactoryManager.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "hardhat/console.sol";

abstract contract FactoryManager {
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

    function closeCampaign() external virtual returns (bool);
    function createCampaign(string memory _name,int256 _lat,int256 _lng, int256 _range, string memory _type,uint256 _value) public payable virtual returns (address);
}