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
        adressToAmountFunded[msg.sender] += msg.value;
    }

    
    function withdraw() public {
        // for loop
        // [1, 2, 3, 4]
        // 0. 1. 2. 3.

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            adressToAmountFunded[funder] = 0;
        }

        // reset the array
        funders = new address[](0);
        // actually withdraw the funds

        // We have 3 ways to send native tokens
        // transfer - Have automatic revert
        // send - only revert if u put require command
        // call - call any function in etherum 

        // transfer
        //payable(msg.sender).transfer(address(this).balance);
        // send
        //bool sendSucess = payable(msg.sender).send(address(this).balance);
        //require(sendSucess, "Send failed");
        // call -
        //(bool callSucess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
        (bool callSucess,) = payable(msg.sender).call{value: address(this).balance}("");  
        require(callSucess, "Call failed");

    }
}
