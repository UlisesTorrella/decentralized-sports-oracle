// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// contract Queue {
//     mapping(uint256 => bytes) queue;
//     uint256 first = 1;
//     uint256 last = 0;

//     function enqueue(bytes data) public {
//         last += 1;
//         queue[last] = data;
//     }

//     function dequeue() public returns (bytes data) {
//         require(last >= first);  // non-empty queue

//         data = queue[first];

//         delete queue[first];
//         first += 1;
//     }
// }

abstract contract Oracle {

    mapping(address => string) private countries;
    mapping(address => string) private cCountries; // c reads candidate

    struct Game {
        uint256 date;
        address a;
        address b;
    }

    mapping(address => Game) private games;
    mapping(address => Game) private cGames;

    uint256 totalStakers;

    function getGame (address id) external view returns (Game memory) {
        return games[id];
    }
    // Queue public announcements;
    // uint8 maxAnnouncements = 2;


    function announceCountry (string memory name, address id) external returns (address) { }

    function announceGame (address a, address b, uint date) external returns (address) { }

    function announceGoal (address game, address awarded, uint16 jersey) external returns (address) {}

    function announceGameStart (address game) external returns (address) {}

    function announceGameEnd (address game) external returns (address) {}

    function confirmAnnouncement (address announcement) external returns (score) {}

}