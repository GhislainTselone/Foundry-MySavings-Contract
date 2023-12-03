// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library Math {
    function getPrice(
        AggregatorV3Interface _priceFeed
    ) internal view returns (uint256 _price) {
        (, int answer, , , ) = _priceFeed.latestRoundData();
        _price = uint256(answer * 1e10);
    }

    function getConversionRate(
        uint256 _sendValue,
        AggregatorV3Interface _priceFeed
    ) internal view returns (uint256 _rate) {
        uint256 price = getPrice(_priceFeed);
        _rate = (price * _sendValue) / 1e18;
    }
}
