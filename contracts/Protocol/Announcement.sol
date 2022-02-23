// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./Oracle.sol";

// Somehow i need to check that the announcement was created by a proven staker
abstract contract Announcement {
  enum AnnouncementState{NotEnoughVotes, Solidified, Rejected}

  mapping(address => bool) private _positiveVoters;
  mapping(address => bool) private _negativeVoters;
  uint32 private _positiveVotes;
  uint32 private _negativeVotes;
  AnnouncementState private _state;

  Oracle private _oracle;
  address public announcer;


  event Solidified();
  event Rejected();

  constructor(address payable oracle) {
    _oracle = Oracle(oracle);
    announcer = tx.origin;
  }

  modifier yetToVote() {
    require(
        !_positiveVoters[msg.sender] &&
        !_negativeVoters[msg.sender]
        ,
        "You've already voted"
    );
    _;
  }

  modifier isStaker() {
    require(_oracle.isStaking(msg.sender), "You must be a staker to announce something here");
    _;
  }

  modifier openBallot() {
    require(_state == AnnouncementState.NotEnoughVotes, "This announcement has already been decided");
    _;
  }

  function approve() external openBallot isStaker yetToVote returns (bool solidified) {
    _positiveVoters[msg.sender] = true;
    _positiveVotes += 1;

    uint256 totalStakers = _oracle.getTotalStakers();

    solidified = _positiveVotes > totalStakers/2 && _state == AnnouncementState.NotEnoughVotes;
    if (solidified) {
        // solidify announcement
        emit Solidified();
        _state = AnnouncementState.Solidified;
    }
  }

  function disprove() external openBallot isStaker yetToVote returns (bool solidified) {
    _negativeVoters[msg.sender] = true;
    _negativeVotes += 1;

    uint256 totalStakers = _oracle.getTotalStakers();

    solidified = _negativeVotes > totalStakers/2 && _state == AnnouncementState.NotEnoughVotes;
    if (solidified) {
        // reject announcement
        emit Rejected();
        _state = AnnouncementState.Rejected;
    }
  }

  // getters
  function getAnnouncementState() public view returns (AnnouncementState state) {
      return _state;
  }

  function getAnnouncementPosVotes() public view returns (uint32 posVotes) {
      return _positiveVotes;
  }

  function getAnnouncementNegVotes() public view returns (uint32 negVotes) {
      return _negativeVotes;
  }

}
