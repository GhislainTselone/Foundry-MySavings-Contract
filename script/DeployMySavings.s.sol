// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MySavings} from "../src/MySavings.sol";
import {HelperConfig} from "../script/HelperCongfig.s.sol";

contract DeployMySavings is Script {
    function run()
        external
        returns (MySavings savings, HelperConfig helperConfig)
    {
        helperConfig = new HelperConfig();
        address priceFeed = helperConfig.getNeededAddresses()._priceFeed;
        uint256 minSavings = helperConfig.getMinSavings();

        vm.startBroadcast();
        savings = new MySavings(priceFeed, minSavings);
        vm.stopBroadcast();
    }
}
