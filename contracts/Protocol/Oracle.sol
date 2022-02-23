// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import './Constants.sol';
import "./Staking.sol";
import "./Announcement.sol";
import "./State.sol";

abstract contract Oracle {

  // ---------------------------------------------------
  //  Oracle
  // ---------------------------------------------------

    // State
    State internal _state;

    function reduce(Announcement a) virtual internal returns (State state);

    function solidify(Announcement a) internal {
        reduce(a);
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

    // Announcements


    event AnnouncementSolidified(address announcement);
    event AnnouncementDisproved(address announcement);
    event Announced(address announcement);

    Announcement[] private _announcements;

    uint256 private _announcementsQuantity = 0; // no me gusta para nada esto ... constructor?

    function announce(Announcement a) private returns (uint256){
        _announcements.push(a);
        emit Announced(address(a));
        _announcementsQuantity += 1;
        return _announcementsQuantity; //index
    }

    function yay(uint256 index) external returns (bool approved) {
        approved = _announcements[index].approve();

        if (approved) {
            solidify(_announcements[index]);
        }
    }

    function nay(uint256 index) external returns (bool disproved) {
        disproved = _announcements[index].disprove();

        if(disproved) {
            delete _announcements[index];
        }
    }

}
