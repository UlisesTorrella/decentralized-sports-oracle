// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./Oracle.sol";
import "./Token.sol";


contract FIFA is Token, Oracle {
    constructor(string memory name_, string memory symbol_, address stakeContract_) {
        _name = name_;
        _symbol = symbol_;
        _balances[tx.origin] = 10000;
        _stakeContract = stakeContract_;
    }


}
