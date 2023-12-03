//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperCongfig.s.sol";
import {MySavings} from "../../src/MySavings.sol";
import {DeployMySavings} from "../../script/DeployMySavings.s.sol";

contract TestMySvaings is Test {
    MySavings private s_mySavings;
    HelperConfig private s_helperConfig;
    address private constant USER = address(1);
    uint256 private constant USER_BALANCE = 10e18;
    uint256 private constant SEND_VALUE = 1e18;

    modifier saver() {
        vm.prank(USER);
        vm.deal(USER, USER_BALANCE);
        _;
    }

    function setUp() external {
        DeployMySavings deployMySavings = new DeployMySavings();
        (s_mySavings, s_helperConfig) = deployMySavings.run();
    }

    function testSaveMoneyFail() public saver {
        vm.expectRevert();
        s_mySavings.saveMoney{value: 1e3}();
    }

    function testSaveMoneySuccess() public saver {
        s_mySavings.saveMoney{value: SEND_VALUE}();
        uint256 mySavingsBalance = address(s_mySavings).balance;
        assertEq(SEND_VALUE, mySavingsBalance);
    }

    function testSaveMoneyAndWithdrawFail() public saver {
        s_mySavings.saveMoney{value: SEND_VALUE}();
        vm.expectRevert();
        vm.prank(USER);
        s_mySavings.withdrawMoney();
    }

    function testSaveMoneyAndWithdrawSuccess() public {
        s_mySavings.saveMoney{value: SEND_VALUE}();

        uint256 contractBalanceBefore = address(s_mySavings).balance;
        console.log(contractBalanceBefore);
        uint256 senderBalanceBefore = address(msg.sender).balance;
        console.log(senderBalanceBefore);
        vm.prank(msg.sender);
        s_mySavings.withdrawMoney();
        console.log(address(s_mySavings).balance);

        uint256 senderBalanceAfter = address(msg.sender).balance;
        console.log(senderBalanceAfter);

        bool result = senderBalanceAfter ==
            (senderBalanceBefore + contractBalanceBefore);
        assertTrue(result);
    }
}
