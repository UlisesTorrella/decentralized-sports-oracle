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

  function aprove() external openBallot isStaker yetToVote returns (uint32, uint32) {
    _positiveVoters[msg.sender] = true;
    _positiveVotes += 1;

    uint256 totalStakers = _oracle.getTotalStakers();

    if (_positiveVotes > totalStakers/2 && _state == AnnouncementState.NotEnoughVotes) { 
        // solidify announcement
        emit Solidified();
        _state = AnnouncementState.Solidified;
    }

    return (_positiveVotes, _negativeVotes);
  }

  function disprove() external openBallot isStaker yetToVote returns(uint32, uint32) {
    _negativeVoters[msg.sender] = true;
    _negativeVotes += 1;

    uint256 totalStakers = _oracle.getTotalStakers();

    if (_negativeVotes > totalStakers/2 && _state == AnnouncementState.NotEnoughVotes) { 
        // reject announcement
        emit Rejected();
        _state = AnnouncementState.Rejected;
    }

    return (_positiveVotes, _negativeVotes);
  }

  
  function reduce(Oracle.Game[] calldata games, Oracle.Team[] calldata teams) virtual external returns(Oracle.Game[] calldata, Oracle.Team[] calldata);


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

contract TeamAnnouncement is Announcement {

  string _name;

  constructor(address payable oracle, string memory name_) Announcement(oracle) {
    _name = name_;
  }

  function reduce(Oracle.Game[] calldata games, Oracle.Team[] calldata teams) override virtual external returns(Oracle.Game[] calldata, Oracle.Team[] calldata){
    return (games, teams);
  }
}

contract GameAnnouncement is Announcement {

  Oracle.Game _game;

  constructor(address payable oracle, address teamA, address teamB, uint32 date) Announcement(oracle) {
    _game = Oracle.Game({date: date, a: teamA, b: teamB,
                  status: Constants.UNSTARTED,
                  result: Constants.NOTRESULTYET,
                  scoreA: Constants.NOTRESULTYET,
                  scoreB: Constants.NOTRESULTYET});
  }

  function reduce(Oracle.Game[] calldata games, Oracle.Team[] calldata teams) override external returns(Oracle.Game[] calldata, Oracle.Team[] calldata){
    games.push(_game);
    // return (games, teams);
  }
}

contract GoalAnnouncement is Announcement {

  uint64 _gameIndex;
  Oracle.Goal _goal;

  constructor(address payable oracle, uint64 gameIndex, uint256 minute, address teamAwarded, uint8 jersey) Announcement(oracle) {
    _gameIndex = gameIndex;
    _goal = Oracle.Goal({minute: minute, teamAwarded: teamAwarded, jersey: jersey});
  }

  function reduce(Oracle.Game[] calldata games, Oracle.Team[] calldata teams) override external returns(Oracle.Game[] calldata, Oracle.Team[] calldata){
    Oracle.Game calldata game = games[_gameIndex];
    if (game.a == _goal.teamAwarded) {
      game.goalsA.push(_goal);
    }
    require(game.b == _goal.teamAwarded || "Imposible to award a goal to this team in this game");
    game.goalsB.push(_goal);
    // is game a reference? do this just change the state? who knows
    games[_gameIndex] = game;
    return (games, teams);
  }

}