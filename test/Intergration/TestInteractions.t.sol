// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperCongfig.s.sol";
import {MySavings} from "../../src/MySavings.sol";
import {FundMySavings, WithdrawFromMySavings} from "../../script/Interactions.s.sol";
import {DeployMySavings} from "../../script/DeployMySavings.s.sol";

contract TestInteractions is Test {
    MySavings private s_mySavings;
    HelperConfig private s_helperConfig;
    FundMySavings private s_fundMySavings;
    WithdrawFromMySavings private s_withdrawFromMySavings;

    address private constant USER_1 = address(3);
    uint256 private constant USER_1_BALANCE = 100e18;
    uint256 private constant SEND_VALUE_1 = 1e18;

    function setUp() external {
        DeployMySavings deployMySavings = new DeployMySavings();
        s_fundMySavings = new FundMySavings();
        s_withdrawFromMySavings = new WithdrawFromMySavings();
        (s_mySavings, s_helperConfig) = deployMySavings.run();
    }

    function testFundMySavingsAndWithdraw() public {
        s_fundMySavings.fundMySavings(address(s_mySavings), SEND_VALUE_1);
        assertEq(address(s_mySavings).balance, SEND_VALUE_1);
        s_withdrawFromMySavings.withdrawMySavings(address(s_mySavings));
        assertEq(address(s_mySavings).balance, 0);
    }
}
