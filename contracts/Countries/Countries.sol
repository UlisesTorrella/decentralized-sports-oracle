// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../Protocol/Oracle.sol";
import "../Protocol/Token.sol";

import "./List.sol";
import "./NewCountryAnnouncement.sol";

contract Countries is Oracle {
    
  constructor() {
    _state = List(address(this));
  }


  function reduce(NewCountryAnnouncement a) internal returns (State countries) {
    _state = _state.countries.push(a.name);
    return _state;
  }




}
