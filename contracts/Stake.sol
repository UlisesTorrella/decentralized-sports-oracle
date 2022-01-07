// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.25 <0.8.12;

contract Stake {
	mapping (address => uint) stakers;
  address payable hodler;
	uint256 totalStakers;

	event Staking(address indexed staker);

	constructor() {
		stakers[tx.origin] = 1;
    hodler = payable(tx.origin);
		totalStakers = 0; // o deberia ser 1 por el dueño?
	}

  function stake() external payable {
    (bool success,) = hodler.call{value: 1 ether}("I'm staking to be a reporter"); // cost to enter is 1 MATIC
    require(success, "Failed to send money, check your funds");
    stakers[msg.sender] = 1;
		totalStakers += 1;
    emit Staking(msg.sender);
  }

	function isStaking(address addr) external view returns(bool){
		return stakers[addr] > 0;
	}

	function getStakersNumber() public view returns (uint256 stakersNumber) {
		return totalStakers;
	}
}
