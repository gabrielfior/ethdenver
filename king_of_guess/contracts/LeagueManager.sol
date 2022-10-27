// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LeagueManager is Ownable, Pausable {
    constructor() {}

    mapping(string => League) private leagues;

    struct Player {
        string name;
    }

    struct Team {
        string name;
        Player[] players;
    }

    struct League {
        string name;
    }

    function createLeague(string memory league_name) public {
        leagues[league_name] = League(league_name);
    }

    function registerTeamOnLeague() public payable {
        require(msg.value >= 0.001 ether, "Amount too small");

    }

    function getLeague(string memory key) public view returns (League memory){
        return leagues[key];
    }

}
