// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import './Constants.sol';
import './Stake.sol';

abstract contract Oracle {

  // ---------------------------------------------------
  //  Oracle
  // ---------------------------------------------------
    mapping(address => string) internal _teams;
    mapping(address => string) internal _cTeams; // c reads candidate

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

    mapping(address => Game) internal _games;
    mapping(address => Game) internal _cGames;

    function getGame(address id) external view returns (Game memory) {
        return _games[id];
    }
    /*
        Staking
    */
    uint256 totalStakers = 5; // hardcoded remember to change
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
    enum AnnouncementState{NotEnoughVotes, Solidified, Disproven}
    mapping(uint256 => Announcement) internal _announcements;

    struct Announcement {
        uint256 announcementId;
        uint32 positiveVotes;
        uint32 negativeVotes;
        AnnouncementState state;
    }

    uint256 private _announcementsQuantity = 0; // no me gusta para nada esto
    event GeneralAnnouncement(address announcer, string announcement);
    event TeamAnnouncement(address announcer, address teamId, string name);
    event GameAnnouncement(address announcer, address gameId, uint256 date, address teamA, address teamB);
    event GoalAnnouncement(address announcer, address gameId, uint256 minute, address awarder, uint8 jersey);
    event StatusAnnouncement(address announcer, address gameId, uint8 status);

    event AnnouncementSolidified(uint256 announcementId);
    event AnnouncementDisproved(uint256 announcementId);

    function announce(string calldata data) virtual external {}
    function announceTeam(address teamId, string calldata name) virtual external returns (uint256 announcementId) {}
    function announceGame(address gameId, uint256 date, address teamA, address teamB) virtual external {}
    function announceGoal(address gameId, uint256 minute, address awarder, uint8 jersey) virtual external {}
    function announceGameStatus(address gameId, uint8 status) virtual external {}

    function approveTeamAnnouncement(uint256 announcementId,  address teamId, string calldata teamName) virtual external returns (bool wasSolidified) {}
    function approveGameAnnouncement(uint256 announcementId) virtual external {}
    function approveGoalAnnouncement(uint256 announcementId) virtual external {}
    function approveGameStatusAnnouncement(uint256 announcementId) virtual external {}

    function createAnnouncement() internal returns (uint256 announcementId) {
        Announcement memory a = Announcement({announcementId: _announcementsQuantity,
                                        positiveVotes: 0,
                                        negativeVotes: 0,
                                        state: AnnouncementState.NotEnoughVotes});
        _announcementsQuantity += 1; // this should be atomic

        return a.announcementId;
    }

    function approveAnnouncement(uint256 announcementId) internal returns (bool wasSolidified) {
        wasSolidified = false;
        Announcement storage a = _announcements[announcementId];
        a.positiveVotes += 1;

        if (a.positiveVotes > totalStakers/2) { // cuidado que es division entera
            // solidify announcement
            emit AnnouncementSolidified(announcementId); // , announcementType);
            a.state = AnnouncementState.Solidified;
            wasSolidified = true;
        }

        return wasSolidified;
    }

    function disproveAnnouncement(uint256 announcementId) internal returns (bool wasDisproved) {
        Announcement storage a = _announcements[announcementId];
        wasDisproved = false;
        a.negativeVotes += 1;

        if (a.negativeVotes > totalStakers/2) { // cuidado que es division entera
            // solidify announcement
            emit AnnouncementDisproved(announcementId); // , announcementType);
            a.state = AnnouncementState.Disproven;
            wasDisproved = true;
        }

        return wasDisproved;
    }

    function getAnnouncementState(uint256 announcementId) public view returns (AnnouncementState state) {
        return _announcements[announcementId].state;
    }

    function getAnnouncementPosVotes(uint256 announcementId) public view returns (uint32 posVotes) {
        return _announcements[announcementId].positiveVotes;
    }
}
