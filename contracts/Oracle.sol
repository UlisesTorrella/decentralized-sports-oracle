// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

uint constant UNSTARTED = 0;
uint constant STARTED = 1;
uint constant FINISHED = 2;
uint constant AWON = 1;
uint constant BWON = 2;
uint constant TIE = 3;

abstract contract Oracle {

  // ---------------------------------------------------
  //  Oracle
  // ---------------------------------------------------

    mapping(address => string) private _teams;
    mapping(address => string) private _cTeams; // c reads candidate

    struct Game {
        uint256 date;
        address a;
        address b;
        uint8 status; 
        /* 
            0 -> not started  
            1 -> playing  
            2 -> finished
        */
        uint8 result;
        /*
            0 -> not yet 
            1 -> A won 
            2 -> B won
            3 -> tie
        */
        uint8 scoreA;
        uint8 scoreB;
    }

    mapping(address => Game) private _games;
    mapping(address => Game) private _cGames;

    uint256 totalStakers;

    function getGame (address id) external view returns (Game memory) {
        return _games[id];
    }

    function announce() virtual external {}
}