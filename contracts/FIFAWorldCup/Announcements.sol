// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import '../Protocol/Announcement.sol';
import '../Tournament/Tournament.sol';

contract TeamAnnouncement is Announcement {

  string _name;

  constructor(address payable oracle, string memory name_) Announcement(oracle) {
    _name = name_;
  }

  function reduce() override external view returns (FutbolTournament.Game[] memory, FutbolTournament.Team[] memory){
    FutbolTournament.Team[] memory teams = new FutbolTournament.Team[](1);
    FutbolTournament.Game[] memory games = new FutbolTournament.Game[](0);

    teams[0] = FutbolTournament.Team({
      addr: address(this),
      name: _name
    });
    return (games, teams);
  }
}

// contract GameAnnouncement is Announcement {

//   Oracle.Game _game;
//   Oracle.Goal[] _goalsA;
//   Oracle.Goal[] _goalsB;

//   constructor(address payable oracle, address teamA, address teamB, uint32 date) Announcement(oracle) {
//     _game = Oracle.Game({date: date, a: teamA, b: teamB,
//                   status: Constants.UNSTARTED,
//                   result: Constants.NOTRESULTYET,
//                   goalsA: _goalsA,
//                   goalsB: _goalsB});
//   }

//   /* function reduce(Oracle.Game[] calldata games, Oracle.Team[] calldata teams) override external returns(Oracle.Game[] calldata, Oracle.Team[] calldata){ */
//   function reduce() override external returns(Oracle.Game[] memory, Oracle.Team[] memory) {
//     // return (games, teams);
//   }
// }

// contract GoalAnnouncement is Announcement {

//   uint64 _gameIndex;
//   Oracle.Goal _goal;

//   constructor(address payable oracle, uint64 gameIndex, uint256 minute, address teamAwarded, uint8 jersey) Announcement(oracle) {
//     _gameIndex = gameIndex;
//     _goal = Oracle.Goal({minute: minute, teamAwarded: teamAwarded, jersey: jersey});
//   }

//   function reduce(address payable oracle) override external {
//     Oracle o = Oracle(oracle);
//     Oracle.Game memory game = o.getGameByIndex(_gameIndex); //games[_gameIndex];
//     if (game.a == _goal.teamAwarded) {
//       /* game.goalsA.push(_goal); */
//       o.addGoalA(game, _goal);
//     }
//     require(game.b == _goal.teamAwarded, "Imposible to award a goal to this team in this game");
//     /* game.goalsB.push(_goal); */
//     o.addGoalB(game, _goal);
//     // is game a reference? do this just change the state? who knows

//     o.saveGame(game, _gameIndex); /* games[_gameIndex] = game; */
//     /* return (games, teams); */
//   }

// }
