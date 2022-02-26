// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "../Protocol/Oracle.sol";
import "../Protocol/Token.sol";


contract FutbolTournament is Oracle {
    
    constructor(string memory name_, string memory symbol_, address payable stakeContract_) {
        super.setStakingContract(stakeContract_);
    }

        struct Team {
        address addr;
        string name;
    }

    Team[] internal _teams;
    Team[] internal _cTeams; // c reads candidate

    struct Game {
        address addr;
        uint256 date;
        address a;
        address b;
        uint8 status;
        uint8 result;
        Goal[] goalsA;
        Goal[] goalsB;
    }

    // sacar goles
    struct Goal {
        uint256 minute;
        address teamAwarded;
        uint8 jersey;
    }

    Game[] internal _games;
    Game[] internal _cGames;

    function getGame(uint256 id) external view returns (Game memory) {
        return _games[id];
    }

    function getGameByAddress(address id) external view returns (Game memory) {
        // do something xd
    }

    function getTeam(uint256 id) external view returns (Team memory) {
        return _teams[id];
    }

    function getTeams() external view returns (Team[] memory) {
        return _teams;
    }

    function getGames() external view returns (Game[] memory) {
        return _games;
    }


    // event GeneralAnnouncement(address announcer, string announcement);
    // event TeamWasAnnounced(address announcer, address teamId, string name);
    // event GameWasAnnounced(address announcer, address gameId, uint256 date, address teamA, address teamB);
    // event GoalWasAnnounced(address announcer, address gameId, uint256 minute, address awarder, uint8 jersey);
    // event StatusWasAnnounced(address announcer, address gameId, uint8 status);



    // function storeCandidates(Game[] memory games, Team[] memory teams) internal {
    //     for(uint i=0; i<games.length; i++) {
    //         // look for existing game and apply changes
    //         // Game memory game = Game({
    //         //     addr: games[i].addr,
    //         //     date: games[i].date,
    //         //     a: games[i].a,
    //         //     b: games[i].b,
    //         //     status: games[i].status,
    //         //     result: games[i].result,
    //         //     goalsA: games[i].goalsA,
    //         //     goalsB: games[i].goalsB
    //         // });
    //         // _cGames.push(game);
    //     }
    //     for(uint j=0; j<teams.length; j++) {
    //         Team memory team = Team({
    //             addr: teams[j].addr,
    //             name: teams[j].name
    //         });
    //         _cTeams.push(team);
    //     }
    // }

    // function announce(address announcement) virtual public returns (uint256 announcementId) {
    //     Announcement a = Announcement(announcement);
    //     require(isStaking(a.announcer()), "You must stake to announce in this oracle");
    //     require(a.getAnnouncementPosVotes() == 0 && a.getAnnouncementNegVotes() == 0, "This announcement has already been voted");
    //     // perhaps check if it was already announced? queue logic?
    //     uint256 index = _announcements.length;
    //     _announcements.push(announcement);
    //     // we accept the announcement into out candidates
    //     Game[] memory changeGames;
    //     Team[] memory changeTeams;
    //     (changeGames, changeTeams) = a.reduce();
    //     storeCandidates(changeGames, changeTeams);
    //     // emit TeamWasAnnounced(msg.sender, teamId, name);

    //     return index;
    // }

    // function addGame(Game calldata _game) public {
    //     // do something xd
    //     /* _games.push(_game); */
    // }

    // function getGameByIndex(uint64 gameIndex) public returns (Game memory hola) {
    //     // do something xd
    //     /* return _games[gameIndex]; */
    // }

    // function saveGame(Game calldata game, uint64 gameIndex) public {
    //     // do something xd
    //     /* _games[gameIndex] = game; */
    // }

    // function addGoalA(Game calldata game, Goal calldata goal) public {
    //     // do something xd
    // }

    // function addGoalB(Game calldata game, Goal calldata goal) public {
    //     // do something xd
    // }

    // function getAnnouncedTeamName(address teamId) public view returns (string memory teamName) {
    //     return _cTeams[teamId];
    // }

    // function getAnnouncedGameDate(address gameId) public view returns (uint256 gameDate) {
    //     return _cGames[gameId].date;
    // }


}
