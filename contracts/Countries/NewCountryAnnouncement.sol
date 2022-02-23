// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../Protocol/Announcement.sol";

contract NewCountryAnnouncement is Announcement {

  string public name;

  constructor(address payable oracle, string memory name_) Announcement(oracle) {
    name = name_;
  }
}