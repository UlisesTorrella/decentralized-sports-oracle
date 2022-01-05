// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './Token.sol';
import './Oracle.sol';

contract Bookie {

  struct Bet {
    address player;
    uint256 amount;
  }

  struct Pot {
    Bet[] betsForA;
    Bet[] betsForB;
  }

  mapping(address => Bet) _bets; // game -> bet relation

  function placeBet(address gameId, address winner, uint256 amount) external returns (address) {
    // check for game existence and non-started status
    Oracle.Game memory game = Oracle.getGame(gameId);
    require(game.a == winner || game.b == winner, "You are betting on a team thats not in this game");
    require(game.status != "finished" && game.status != "started", "This game is no longer taking bets");
    address sender = msg.sender;
    uint256 balance = Token.balanceOf(msg.sender); 
    require (balance > amount, "Insuficient funds");
    
    unchecked {
      Token._balances[sender] = balance - amount;
    }
    Token._balances[] += amount; // the contract will hold those tokens

    if(game.a == winner) {
      _bets[gameId].betsForA.push(Bet(msg.sender, amount));
    }
    else {
      _bets[gameId].betsForA.push(Bet(msg.sender, amount));
    }
    return gameId;
  }

  function cashBet(address bet) external returns (bool success) {
    return true;
  }

}