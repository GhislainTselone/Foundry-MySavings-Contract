// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {Math} from "../src/Math.sol";

error MySavings__saveMoney__NotENoughToSave();
error MySavings__withdrawMoney__OnlyOwnerAllowHere();
error MySavings__withdrawMoney__SendSavingsToOwnerFailed();

contract MySavings {
    using Math for uint256;

    struct History {
        uint256 _date;
        uint256 _amount;
    }

    mapping(address => History) private s_addressHistory;
    address[] private s_saver;

    address private immutable i_owner;
    AggregatorV3Interface private immutable i_priceFeed;
    uint256 private immutable i_minSaving;

    constructor(address _priceFeed, uint256 _minSavings) {
        i_owner = payable(msg.sender);
        i_priceFeed = AggregatorV3Interface(_priceFeed);
        i_minSaving = _minSavings;
    }

    modifier checkSaving() {
        if (msg.value.getConversionRate(i_priceFeed) < i_minSaving)
            revert MySavings__saveMoney__NotENoughToSave();
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner)
            revert MySavings__withdrawMoney__OnlyOwnerAllowHere();
        _;
    }

    function saveMoney() public payable checkSaving {
        s_addressHistory[msg.sender] = History(block.timestamp, msg.value);
        s_saver.push(msg.sender);
    }

    function withdrawMoney() public onlyOwner {
        for (uint256 _index; _index < s_saver.length; _index++) {
            s_addressHistory[s_saver[_index]] = History(0, 0);
        }

        s_saver = new address[](0);

        (bool success, ) = i_owner.call{value: address(this).balance}("");
        if (!success)
            revert MySavings__withdrawMoney__SendSavingsToOwnerFailed();
    }

    receive() external payable {}

    fallback() external payable {}
}
