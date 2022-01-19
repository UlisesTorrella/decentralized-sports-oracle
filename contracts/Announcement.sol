// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./Oracle.sol";

// Somehow i need to check that the announcement was created by a proven staker
interface Announcement {
  enum AnnouncementState{NotEnoughVotes, Solidified, Disproven}

  mapping(address => bool) positiveVoters;
  mapping(address => bool) negativeVoters;
  uint32 positiveVotes;
  uint32 negativeVotes;
  AnnouncementState state;

  function reduce(Game[] games, Teams[] teams) virtual external returns(games, teams);

}

contract TeamAnnouncement is Announcement {

  string _name;

  constructor(string name_) {
    _name = name_;
  }

  function reduce(Game[] games, Teams[] teams) external returns(games, teams) {
    teams.push(_name);
    // return (games, teams);
  }
}

contract GameAnnouncement is Announcement {

  Game _game;

  constructor(address teamA, address teamB, uint32 date) {
    _game = Game({date: date, a: teamA, b: teamB,
                  status: Constants.UNSTARTED,
                  result: Constants.NOTRESULTYET,
                  scoreA: Constants.NOTRESULTYET,
                  scoreB: Constants.NOTRESULTYET});
  }

  function reduce(Game[] games, Teams[] teams) external returns(games, teams) {
    games.push(_game);
    // return (games, teams);
  }
}

contract GoalAnnouncement is Announcement {

  uint64 _gameIndex;
  Goal _goal;

  constructor(uint64 gameIndex, uint256 minute, address teamAwarded, uint8 jersey) {
    _gameIndex = gameIndex;
    _goal = Goal({minute: minute, teamAwarded: teamAwarded, jersey: jersey});
  }

  function reduce(Game[] games, Teams[] teams) external returns(games, teams) {
    Game game = games[_gameIndex];
    if (game.a == _goal.teamAwarded) {
      game.goalsA.push(_goal);
    }
    require(game.b == _goal.teamAwarded || "Imposible to award a goal to this team in this game");
    game.goalsB.push(_goal);
    // is game a reference? do this just change the state? who knows
  }

}