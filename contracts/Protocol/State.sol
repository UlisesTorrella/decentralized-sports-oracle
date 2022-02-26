// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./Oracle.sol";

contract State {

  Oracle internal _oracle;

  constructor(address payable oracle) {
    _oracle = Oracle(oracle);
  }

}