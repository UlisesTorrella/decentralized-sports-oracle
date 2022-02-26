// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../Protocol/Oracle.sol";
import "../Protocol/Token.sol";



// this oracle must implement the futbol oracle and 
// use the countries Oracle as their teams list.
contract FIFA is Token, Oracle {
    constructor(string memory name_, string memory symbol_, address payable stakeContract_) {
        _name = name_;
        _symbol = symbol_;
        _balances[tx.origin] = 10000;
        super.setStakingContract(stakeContract_);
    }
}
