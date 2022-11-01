// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../contracts/VolcanoNFT_hw9.sol";

contract VolcanoNFT_hw9Test is Test {
    
    VolcanoNFTHw9 private volcanoNFT;
    address deployer;
    address otherAccount;

    function setUp() public {
        volcanoNFT = new VolcanoNFTHw9("NFT1","myNFT");
        deployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;
        otherAccount = vm.addr(2);
    }

    event Transfer(address from, address to, uint256 tokenId);

    function testMintEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Transfer(0x0000000000000000000000000000000000000000, deployer, 1);
        volcanoNFT.mint(deployer, "abc");
    }

    function testMint() public {
        volcanoNFT.mint(deployer, "abc");
        uint256 balance = volcanoNFT.balanceOf(deployer);
        assertEq(balance, 1);
    }

     function testTransfer() public {
        volcanoNFT.mint(deployer, "abc");
        volcanoNFT.transferFrom(deployer, otherAccount, 1);
        assertEq(volcanoNFT.balanceOf(deployer), 0);
        assertEq(volcanoNFT.balanceOf(otherAccount), 1);
    }
}
