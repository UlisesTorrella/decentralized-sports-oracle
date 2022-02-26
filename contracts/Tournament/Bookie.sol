// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import './Tournament.sol';
import "../Protocol/Token.sol";
import '../Protocol/Constants.sol';

contract Bookie {

  struct Pot {
    mapping(address => uint256) betsForA; // a bet is a relation from address to amount
    mapping(address => uint256) betsForB;
    uint256 sumForA;
    uint256 sumForB;
  }

  mapping(address => Pot) _pots; // game -> bet relation

  event Bet(address who, address game, address win, uint256 amount);

  function bookkeep(Tournament.Game memory game, address gameId, address player, address winner, uint256 amount) internal {
    if(game.a == winner) {
      _pots[gameId].betsForA[player] = amount;
      _pots[gameId].sumForA += amount;
    }
    else {
      _pots[gameId].betsForB[player] = amount;
      _pots[gameId].sumForB += amount;
    }
  }

  function calculateReturn(Tournament.Game memory game, address gameId, address player) internal view returns (uint256 earned) {
    Pot storage pot = _pots[gameId];
    uint256 totalFunds = pot.sumForA + pot.sumForB;

    if (game.result == Constants.AWON) {
      uint256 betted = pot.betsForA[player];
      earned = totalFunds * (betted / pot.sumForA);
    }
    else if (game.result == Constants.BWON) {
      uint256 betted = pot.betsForB[player];
      earned = totalFunds * (betted / pot.sumForB);
    }
  }
  /**
    @param c: the address for the contract you are betting on
  */
  function placeBet(address c, address gameId, address winner, uint256 amount) external returns (address) {
    // check for game existence and non-started status
    Tournament oracle = Tournament(payable(c));
    Token token = Token(c);
    Tournament.Game memory game = oracle.getGameByAddress(gameId);
    require(game.a == winner || game.b == winner, "You are betting on a team thats not in this game");
    require(game.status == Constants.UNSTARTED, "This game is no longer taking bets");
    uint256 balance = token.balanceOf(msg.sender);
    require (balance > amount, "Insuficient funds");

    token.increaseAllowanceToContract(msg.sender, address(this), amount+1);
    token.transferFrom(msg.sender, address(this), amount); // the contract will hold those tokens

    bookkeep(game, gameId, msg.sender, winner, amount); // you're in

    emit Bet(msg.sender, gameId, winner, amount);
    return gameId;
  }

  /**
    @param c: the address for the contract you are betting on
  */
  function cashBet(address c, address gameId) external returns (uint256 newBalance) {
    require(_pots[gameId].betsForA[msg.sender] > 0 || _pots[gameId].betsForB[msg.sender] > 0, "You have no bets in this pot");
    Tournament.Game memory game = Tournament(payable(c)).getGameByAddress(gameId);
    require(game.status != Constants.FINISHED, "The game hasn't finished yet");

    Token(c).transfer(address(this), calculateReturn(game, gameId, msg.sender));

    return Token(c).balanceOf(msg.sender);
  }

}
