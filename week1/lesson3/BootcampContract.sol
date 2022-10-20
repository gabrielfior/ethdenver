// SPDX-License-Identifier: None

pragma solidity 0.8.17;


contract BootcampContract {

    uint256 number;
    address deployer;
    address NULL_ADDRESS = 0x000000000000000000000000000000000000dEaD;

    constructor(){
        deployer = msg.sender;
    }

    /// Returns deployer if not deployer or the null adress if deployer calls function.
    function getDeployerOrNull() public view returns (address){
        if (msg.sender == deployer){
            return NULL_ADDRESS;
        }
        return deployer;
    }

    function store(uint256 num) public {
        number = num;
    }


    function retrieve() public view returns (uint256){
        return number;
    }
}