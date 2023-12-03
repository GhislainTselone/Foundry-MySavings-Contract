// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MySavings} from "../src/MySavings.sol";
import {console} from "forge-std/console.sol";

contract FundMySavings is Script {
    // Address has been set to an arbitrary one
    address private constant MYSAVINGS_ADDRESS = address(0);
    uint256 private constant SEND_VALUE = 1e18;

    function fundMySavings(address _mySavings, uint256 _sendValue) public {
        MySavings mySavings = MySavings(payable(_mySavings));
        vm.startBroadcast();
        mySavings.saveMoney{value: _sendValue}();
        vm.stopBroadcast();
    }

    function run() external {
        fundMySavings(MYSAVINGS_ADDRESS, SEND_VALUE);
    }
}

contract WithdrawFromMySavings is Script {
    // Address has been set to an arbitrary one
    address private constant MYSAVINGS_ADDRESS = address(0);

    function withdrawMySavings(address _mySavings) public {
        MySavings mySavings = MySavings(payable(_mySavings));
        vm.startBroadcast();
        mySavings.withdrawMoney();
        vm.stopBroadcast();
    }

    function run() external {
        withdrawMySavings(MYSAVINGS_ADDRESS);
    }
}
