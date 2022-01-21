// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import './Constants.sol';
import "./Staking.sol";
import "./Announcement.sol";

abstract contract Oracle {

  // ---------------------------------------------------
  //  Oracle
  // ---------------------------------------------------
    struct Team {
        address addr;
        string name;
    }

    Team[] internal _teams;
    Team[] internal _cTeams; // c reads candidate

    struct Game {
        uint256 date;
        address a;
        address b;
        uint8 status;
        uint8 result;
        Goal[] goalsA;
        Goal[] goalsB;
    }

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

    // Staking
	Staking _staking;

    function setStakingContract(address payable stakingContract) internal {
        _staking = Staking(stakingContract);
    }

	receive() external payable {}

	function transferStaking(uint256 amount) public {
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

    address[] internal _announcements;

    uint256 private _announcementsQuantity = 0; // no me gusta para nada esto ... constructor?
    event GeneralAnnouncement(address announcer, string announcement);
    event TeamWasAnnounced(address announcer, address teamId, string name);
    event GameWasAnnounced(address announcer, address gameId, uint256 date, address teamA, address teamB);
    event GoalWasAnnounced(address announcer, address gameId, uint256 minute, address awarder, uint8 jersey);
    event StatusWasAnnounced(address announcer, address gameId, uint8 status);

    event AnnouncementSolidified(address announcement);
    event AnnouncementDisproved(address announcement);


    function announce(address announcement, address payable oracle) virtual public returns (uint256 announcementId) {
        Announcement a = Announcement(announcement);
        require(isStaking(a.announcer()), "You must stake to announce in this oracle");
        require(a.getAnnouncementPosVotes() == 0 && a.getAnnouncementNegVotes() == 0, "This announcement has already been voted");
        // perhaps check if it was already announced? queue logic?
        uint256 index = _announcements.length;
        _announcements.push(announcement);
        // we accept the announcement into out candidates
        a.reduce(oracle);
        // emit TeamWasAnnounced(msg.sender, teamId, name);

        return index;
    }

    function addGame(Game calldata _game) public {
        // do something xd
        /* _games.push(_game); */
    }

    function getGameByIndex(uint64 gameIndex) public returns (Game memory hola) {
        // do something xd
        /* return _games[gameIndex]; */
    }

    function saveGame(Game calldata game, uint64 gameIndex) public {
        // do something xd
        /* _games[gameIndex] = game; */
    }

    function addGoalA(Game calldata game, Goal calldata goal) public {
        // do something xd
    }

    function addGoalB(Game calldata game, Goal calldata goal) public {
        // do something xd
    }

    // function getAnnouncedTeamName(address teamId) public view returns (string memory teamName) {
    //     return _cTeams[teamId];
    // }

    // function getAnnouncedGameDate(address gameId) public view returns (uint256 gameDate) {
    //     return _cGames[gameId].date;
    // }

}
