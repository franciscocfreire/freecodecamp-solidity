// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

contract FundMe {

    uint256 public minimumUsd = 50;

    function fund() public payable {
        // Wanted to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract?
        require(msg.value >= minimumUsd, "Didn't send enogh"); // 1e18 == 1 * 10 ** 18 == 1000000000000000000 WEI == 1 ETH
        

    }

    //function withdraw(){}
}