// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MockV3Aggregator} from "../test/Mock/Mock.sol";
import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    address private constant PRICE_FEED_MUMBAI =
        0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada;
    address private constant PRICE_FEED_MAINNET =
        0xAB594600376Ec9fD91F8e885dADF0CE036862dE0;

    uint256 private constant MIN_SAVINGS = 5e16;
    uint8 private constant DECIMALS = 8;
    int256 private constant INITIAL_ANSWER = 2000e8;

    NeededAddresses private s_neededAddresses;

    struct NeededAddresses {
        address _priceFeed;
    }

    constructor() {
        uint256 activeNetwork = block.chainid;
        if (activeNetwork == 80001) {
            s_neededAddresses = mumbaiAddresses();
        } else if (activeNetwork == 137) {
            s_neededAddresses = mainnetAddresses();
        } else {
            s_neededAddresses = otherAddresses();
        }
    }

    function mumbaiAddresses()
        public
        pure
        returns (NeededAddresses memory _addresses)
    {
        _addresses = NeededAddresses({_priceFeed: PRICE_FEED_MUMBAI});
    }

    function mainnetAddresses()
        public
        pure
        returns (NeededAddresses memory _addresses)
    {
        _addresses = NeededAddresses({_priceFeed: PRICE_FEED_MAINNET});
    }

    function otherAddresses()
        public
        returns (NeededAddresses memory _priceFeed)
    {
        // Deploy a mock first and the its address
        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
        vm.stopBroadcast();
        address mockAddressPriceFeed = address(mock);

        // Set the priceFeed address
        _priceFeed = NeededAddresses({_priceFeed: mockAddressPriceFeed});
    }

    function getNeededAddresses()
        public
        view
        returns (NeededAddresses memory _address)
    {
        _address = s_neededAddresses;
    }

    function getMinSavings() public pure returns (uint256 _amount) {
        _amount = MIN_SAVINGS;
    }
}
