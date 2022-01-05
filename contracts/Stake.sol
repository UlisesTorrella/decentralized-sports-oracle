// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.8.12;

contract Stake {
	mapping (address => uint) stakers;

  address payable hodler;

	event Staking(address indexed staker);

	constructor() public {
		stakers[tx.origin] = 1;
    hodler = payable(tx.origin);
	}

  function stake() external payable returns(bool){
    (bool success,) = hodler.call{value: 1 ether}("I'm staking to be a reporter"); // cost to enter is 1 MATIC
    require(success, "Failed to send money, check your funds");
    stakers[msg.sender] = 1;
    emit Staking(msg.sender);
    return true;
  }

	function isStaking(address addr) external view returns(bool){
		return stakers[addr] > 0;
	}
}
