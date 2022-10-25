// SPDX-License-Identifier: None

import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.0;

contract VolcanoCoinHw5 is Ownable {

    struct Payment {
        uint256 amount;
        address recipient;
    }

    uint256 totalSupply = 10_000;
    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;

    event Mint(uint256 newTotalSupply);
    event Transfer(uint256 amount, address recipient);

    constructor() Ownable(){
        balances[msg.sender] = totalSupply;
    }

    function mint() public onlyOwner {
        totalSupply += 1_000;
        // or use msg.sender since onlyOwner modifier enforces owner
        address owner = owner();
        balances[owner] += 1_000;
        emit Mint(totalSupply);
    }

    function getTotalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function getBalance(address user) public view returns (uint256){
        return balances[user];
    }

    function getPayments(address user) public view returns (Payment[] memory){
        return payments[user];
    }

    function transfer(uint256 amount, address recipient) public {
        // We do not need the sender as parameter because we fetch this from the message
        // We also prevent people from sending money from a 3rd party to another account in an unauthorized way.
        require(balances[msg.sender] >= amount, 'Balance < amount');
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        payments[msg.sender].push(Payment(amount, recipient));
        emit Transfer(amount, recipient);
    }
}
