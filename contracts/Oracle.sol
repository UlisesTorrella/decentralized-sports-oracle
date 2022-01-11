// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import './Constants.sol';
import "./Staking.sol";

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

    struct Goal {
        uint256 minute;
        address teamAwarder;
        uint8 jersey;
    }

    struct GameStatus {
        address gameId;
        uint8 status;
    }

    mapping(address => Game) internal _games;
    mapping(address => Game) internal _cGames;

    mapping(uint256 => Goal) internal _goals; // announcementId -> Goal mapping
    mapping(uint256 => Goal) internal _cGoals; // announcementId -> Goal mapping

    mapping(uint256 => GameStatus) internal _cGameStatus; // announcementId -> status mapping

    function getGame(address id) external view returns (Game memory) {
        return _games[id];
    }

    // Modifiers

    modifier yetToVote(uint256 announcement) {
        require(
            !_announcements[announcement].positiveVoters[msg.sender] &&
            !_announcements[announcement].negativeVoters[msg.sender]
            ,
            "You've already voted"
        );
        _;
    }


    // Staking
	Staking _staking;

    function setStakingContract(address payable stakingContract) internal {
        _staking = Staking(stakingContract);
    }

	receive() external payable {}

	function transfer(uint256 amount) public {
        payable(_staking).transfer(amount);
	}

	function stake(uint256 amount) public {
        _staking.stake{value: amount}();
	}

	function unstake() public {
        _staking.unstake();
	}

	function isStaking(address addr) public view returns (bool) {
		return _staking.addressToIsValidator(addr);
	}


	function getTotalStakers() public view returns (uint256) {
		return _staking.validators().length;
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
        mapping(address => bool) positiveVoters;
        mapping(address => bool) negativeVoters;
        uint32 positiveVotes;
        uint32 negativeVotes;
        AnnouncementState state;
    }

    uint256 private _announcementsQuantity = 0; // no me gusta para nada esto ... constructor?
    event GeneralAnnouncement(address announcer, string announcement);
    event TeamAnnouncement(address announcer, address teamId, string name);
    event GameAnnouncement(address announcer, address gameId, uint256 date, address teamA, address teamB);
    event GoalAnnouncement(address announcer, address gameId, uint256 minute, address awarder, uint8 jersey);
    event StatusAnnouncement(address announcer, address gameId, uint8 status);

    event AnnouncementSolidified(uint256 announcementId);
    event AnnouncementDisproved(uint256 announcementId);

    function announce(string calldata data) virtual external {}

    function announceTeam(address teamId, string calldata name) virtual public returns (uint256 announcementId) {
        _cTeams[teamId] = name;

        emit TeamAnnouncement(msg.sender, teamId, name);
        announcementId = createAnnouncement();

        return announcementId;
    }

    function announceGame(address gameId, uint256 date, address teamA, address teamB) virtual public returns (uint256 announcementId){
        // needs to check if teamA and teamB has been announced.

        Game memory game = Game({date: date, a: teamA, b: teamB,
                                status: Constants.UNSTARTED,
                                result: Constants.NOTRESULTYET,
                                scoreA: Constants.NOTRESULTYET,
                                scoreB: Constants.NOTRESULTYET});
        _cGames[gameId] = game;

        announcementId = createAnnouncement();
        emit GameAnnouncement(msg.sender, gameId, date, teamA, teamB);

        return announcementId;
    }

    function announceGoal(address gameId, uint256 minute, address teamAwarder, uint8 jersey) virtual external returns (uint256 announcementId){
        // Needs to check if game and team playing is valid

        announcementId = createAnnouncement();

        Goal memory goal = Goal({minute: minute, teamAwarder: teamAwarder, jersey: jersey});
        _cGoals[announcementId] = goal;

        emit GoalAnnouncement(msg.sender, gameId, minute, teamAwarder, jersey);

        return announcementId;
    }

    function announceGameStatus(address gameId, uint8 status) virtual external returns (uint256 announcementId) {
        announcementId = createAnnouncement();

        GameStatus memory gameStatus = GameStatus({gameId: gameId, status: status});
        _cGameStatus[announcementId] = gameStatus;

        emit StatusAnnouncement(msg.sender, gameId, status);

        return announcementId;
    }

    /*
        Each type of announcement approval needs its approval function but only
        one function (disproveAnnouncement) is necessary for disproval.
    */
    function approveTeamAnnouncement(uint256 announcementId, address teamId, string calldata teamName) virtual public yetToVote(announcementId) returns (bool wasSolidified) {
        // Needs to check if this user has not approved this announcement before.
        // Needs to check that input data matches _cTeams data.
        // Needs to check if announcementId is a TeamAnnouncement.
        // Needs to check if teamId is valid.
        wasSolidified = approveAnnouncement(announcementId);

        if (wasSolidified) {
            _teams[teamId] = teamName;
        }

        return wasSolidified;
    }

    function approveGameAnnouncement(uint256 announcementId, address gameId) virtual public yetToVote(announcementId) returns (bool wasSolidified) {
        // Needs to check if this user has not approved this announcement before.
        // Needs to check if announcementId is a GameAnnouncement.
        // Needs to check if gameId is valid.
        wasSolidified = approveAnnouncement(announcementId);

        if (wasSolidified) {
            _games[gameId] = _cGames[gameId];
        }

        return wasSolidified;
    }

    function approveGoalAnnouncement(uint256 announcementId) virtual public yetToVote(announcementId) returns (bool wasSolidified) {
        // Needs to check if this user has not approved this announcement before.
        // Needs to check if announcementId is a GoalAnnouncement.
        wasSolidified = approveAnnouncement(announcementId);

        if (wasSolidified) {
            _goals[announcementId] = _cGoals[announcementId];
        }

        return wasSolidified;
    }

    function approveGameStatusAnnouncement(uint256 announcementId, address gameId, uint8 newGameStatus) virtual public yetToVote(announcementId) returns (bool wasSolidified) {
        // Needs to check if this user has not approved this announcement before.
        // Needs to check if announcementId is a StatusAnnouncement.
        // Needs to check if gameId is a valid game.
        wasSolidified = approveAnnouncement(announcementId);

        if (wasSolidified) {
            _games[gameId].status = newGameStatus;

            if (newGameStatus == 2) { // game has finished
                uint8 scoreTeamA = _games[gameId].scoreA;
                uint8 scoreTeamB = _games[gameId].scoreB;
                if (scoreTeamA > scoreTeamB) {
                    _games[gameId].result = 1; // A won
                } else if (scoreTeamA == scoreTeamB) {
                    _games[gameId].result = 3; // tie
                } else if (scoreTeamA < scoreTeamB) {
                    _games[gameId].result = 2; // B won
                }
            }
        }

        return wasSolidified;
    }

    function createAnnouncement() internal returns (uint256 announcementId) {
        Announcement storage a = _announcements[_announcementsQuantity++];
        a.announcementId = _announcementsQuantity;
        a.positiveVotes = 0;
        a.negativeVotes = 0;
        a.state = AnnouncementState.NotEnoughVotes;
        
        return a.announcementId;
    }

    function getAnnouncedTeamName(address teamId) public view returns (string memory teamName) {
        return _cTeams[teamId];
    }

    function getAnnouncedGameDate(address gameId) public view returns (uint256 gameDate) {
        return _cGames[gameId].date;
    }

    function approveAnnouncement(uint256 announcementId) internal yetToVote(announcementId) returns (bool wasSolidified) {
        // Needs to check if this user has not approved this announcement before.
        wasSolidified = false;
        Announcement storage a = _announcements[announcementId];
        a.positiveVotes += 1;
        a.positiveVoters[msg.sender] = true;
        uint256 totalStakers = getTotalStakers();

        if (a.positiveVotes > totalStakers/2 && a.state == AnnouncementState.NotEnoughVotes) { // cuidado que es division entera
            // solidify announcement
            emit AnnouncementSolidified(announcementId); // , announcementType);
            a.state = AnnouncementState.Solidified;
            wasSolidified = true;
        }

        return wasSolidified;
    }

    function disproveAnnouncement(uint256 announcementId) public yetToVote(announcementId) returns (bool wasDisproved) {
        Announcement storage a = _announcements[announcementId];
        wasDisproved = false;
        a.negativeVotes += 1;
        a.negativeVoters[msg.sender] = true;
        uint256 totalStakers = getTotalStakers();

        if (a.negativeVotes > totalStakers/2 && a.state == AnnouncementState.NotEnoughVotes) { // cuidado que es division entera
            // disprove announcement
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

    function getAnnouncementNegVotes(uint256 announcementId) public view returns (uint32 negVotes) {
        return _announcements[announcementId].negativeVotes;
    }
}
