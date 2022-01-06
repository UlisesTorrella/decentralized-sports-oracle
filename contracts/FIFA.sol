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

    function announceTeam(address teamId, string calldata name) override public {
        _cTeams[teamId] = name;

        emit TeamAnnouncement(msg.sender, teamId, name);
    }

    function getAnnouncedTeamName(address teamId) public view returns (string memory teamName) {
        return _cTeams[teamId];
    }

    function announceGame(address gameId, uint256 date, address teamA, address teamB) override public {
        // needs to check if teamA and teamB has been announced.

        Game memory game = Game({date: date, a: teamA, b: teamB,
                                  status: Constants.UNSTARTED,
                                  result: Constants.NOTRESULTYET,
                                  scoreA: Constants.NOTRESULTYET,
                                  scoreB: Constants.NOTRESULTYET});
        _cGames[gameId] = game;

        emit GameAnnouncement(msg.sender, gameId, date, teamA, teamB);
    }

    function getAnnouncedGameDate(address gameId) public view returns (uint256 gameDate) {
        return _cGames[gameId].date;
    }
}
