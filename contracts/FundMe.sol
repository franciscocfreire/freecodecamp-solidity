// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

contract FundMe {

    uint256 public minimumUsd = 50 * 1e18;

    function fund() public payable {
        // Wanted to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract?
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enogh"); // 1e18 == 1 * 10 ** 18 == 1000000000000000000 WEI == 1 ETH
    }

    function getPrice() public view returns(uint256){
        // to interact to contract outside ours project
        // ABI
        // Address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        // Dont need fill all fields, just leave comma for field are unsed
        (, int256 price,,,) = priceFeed.latestRoundData();
        // ETH in terms in USD
        // 3000.00000000
        return uint256(price * 1e10); // 1**10 == 10000000000
    }

    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ehtAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ehtAmountInUsd;
    }
    //function withdraw(){}
}