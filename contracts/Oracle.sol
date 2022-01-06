pragma solidity ^0.8.10;

import './Constants.sol';
import './Stake.sol';

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


    struct Announcement {
        address txhash;
        uint32 positiveVotes;
        uint32 negativeVotes;
    }

    mapping(address => Game) private _games;
    mapping(address => Game) private _cGames;

    uint256 totalStakers;
    address _stakeContract;

    function isStaking(address user) internal view returns (bool) {
        Stake stake = Stake(_stakeContract);
        return stake.isStaking(user);
    }


    /*
        Announcements can be:
            New team has joined
            A game is scheduled
            A game starts
            A team scores a goal 
                potential announcements:
                    Player change
                    Penalization
                    Any string
            A game ends
    */
    event GeneralAnnouncement(address announcer, string announcement);
    event TeamAnnouncement(address announcer, address teamId, string name);
    event GameAnnouncement(address announcer, uint256 date, address teamA, address teamB);
    event GoalAnnouncement(address announcer, address gameId, uint256 minute, address awarder, uint8 jersey);
    event StatusAnnouncement(address announcer, address gameId, uint8 status);

    event AnnouncementSolidified(address txhash);
    event AnnouncementDisproved(address txhash);

    function announce(string calldata data) virtual external {}
    function announceTeam(address teamId, string calldata name) virtual external {}
    function announceGame(address gameId, uint256 date, address teamA, address teamB) virtual external {}
    function announceGoal(address gameId, uint256 minute, address awarder, uint8 jersey) virtual external {}
    function announceGameStatus(address gameId, uint8 status) virtual external {}

    function approveAnnouncement() virtual external {}
    function disproveAnnouncement() virtual external {}


    function getGame (address id) external view returns (Game memory) {
        return _games[id];
    }

}