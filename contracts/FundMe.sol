// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";
// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// 859,721
// 840,185 - constant
// 816,726 - immutabel
// 791,836 - revert call
// 796,979 - add receive and fallback special function

error NotOwner();
contract FundMe {

    using PriceConverter for uint256;

    // 21,415
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public adressToAmountFunded;

    // 21,508
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Wanted to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract?
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enogh"); // 1e18 == 1 * 10 ** 18 == 1000000000000000000 WEI == 1 ETH
        funders.push(msg.sender);    
        adressToAmountFunded[msg.sender] += msg.value;
    }

    
    function withdraw() public onlyOwner{

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

    modifier onlyOwner {
        if(msg.sender == i_owner){
            revert NotOwner();
        }
        _; // do the rest of the code
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
