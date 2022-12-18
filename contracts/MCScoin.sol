// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MCSCoin is ERC20, ERC20Burnable, Ownable {

    uint256 blockReward;

    constructor (uint256 reward) ERC20("Mobile Crowd Sensing Coin", "MCSCoin") {
        _mint(msg.sender, 100 * (10 ** uint256(decimals())));
        blockReward = reward * (10 ** uint(decimals()));
    }

    function setBlockReward(uint256 reward) public onlyOwner() {
        blockReward = reward * (10 ** decimals());
    }

    function _mintMinerReward() internal {
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from,address to,uint256 amount) internal virtual override{
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, amount);
    }

    function destroy() public onlyOwner() {
        selfdestruct(payable(owner()));
    }
}

