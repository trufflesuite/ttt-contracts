// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/security/PullPayment.sol";

contract TicTacToe is PullPayment {
  event GameStarted(uint game_id);
  event GameWon(uint game_id, address winner, uint amount);

  struct Game {
    uint jackpot;
    address[2] payout_addresses;
    bool ended;
  }

  Game[] games;

  function startGame(address payout_x, address payout_o) public payable {
    // must have some value attached for jackpot
    require(msg.value > 0, "jackpot must be greater than 0");

    // all params must be supplied
    require(payout_x != address(0), "player X address cannot be empty");
    require(payout_o != address(0), "player O address cannot be empty");

    // msg.sender and payout_o cannot be the same address
    require(payout_x != payout_o, "player X and player O cannot have the same payout address");

    uint new_game_id = games.length;
    address[2] memory payout_addresses = [payout_x, payout_o];
    games.push(Game(msg.value, payout_addresses, false));

    emit GameStarted(new_game_id);
  }

  function endGame(uint game_id, uint winner) public {
    // make sure the game hasn't already ended
    require(!games[game_id].ended, "cannot end a game which is already ended");

    address winner_address = games[game_id].payout_addresses[winner];
    uint jackpot = games[game_id].jackpot;

    games[game_id].ended = true;

    _asyncTransfer(winner_address, jackpot);

    emit GameWon(game_id, winner_address, jackpot);
  }
}
