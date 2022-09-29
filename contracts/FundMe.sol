// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";
// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public adressToAmountFunded;

    function fund() public payable {
        // Wanted to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract?
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enogh"); // 1e18 == 1 * 10 ** 18 == 1000000000000000000 WEI == 1 ETH
        funders.push(msg.sender);    
        adressToAmountFunded[msg.sender] = msg.value;
    }

    
    //function withdraw(){}
}
