// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Campaign.sol";
import "./MCScoin.sol";
import "./HubContract.sol";

contract CampaignFactory {
    HubContract public hubContract;

    constructor (address HubAddress) {
        hubContract = HubContract(HubAddress);
    }

    function createCampaign(
        string calldata name,
        int256 lat,
        int256 lng,
        int256 range,
        string calldata campaignType,
        address sourcer
    ) external returns (address) {
        require(
            !hubContract.checkIfSourcerHasActiveCampaign(sourcer),
            "this sourcer already has an active campaign"
        );
        Campaign newCampaign = new Campaign(
            name,
            lat,
            lng,
            range,
            campaignType,
            sourcer,
            address(hubContract)
        );
        address newCampaignAddress = address(newCampaign);

        return newCampaignAddress;
    }
}
