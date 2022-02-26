// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../Protocol/State.sol";

contract List is State {

  string[] countries;

  constructor(address payable oracle) State(oracle) {}


  modifier isOwnOracle() {
    require(address(_oracle) == msg.sender, "You must be the attached Oracle to add to this state");
    _;
  }

  function add(string memory country) external isOwnOracle {
    countries.push(country);
  }
}