// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../contracts/VolcanoNFT_hw9.sol";
import "forge-std/console.sol";

contract VolcanoNFT_hw9Test is Test {
    
    VolcanoNFTHw9 private volcanoNFT;
    address owner;
    address otherAccount;
    address ZERO_ADDRESS = address(0);

    function setUp() public {
        volcanoNFT = new VolcanoNFTHw9("NFT1","myNFT");
        owner = address(this);
        otherAccount = vm.addr(2);
    }

    //event Transfer(address from, address to, uint256 tokenId);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address owner, address approved, uint256 tokenId);

    function testMintEmitsEvent() public {        
        vm.expectEmit(true, true, true, true);
        emit Transfer(ZERO_ADDRESS, owner, 1);
        volcanoNFT.mint(owner, "abc");
    }

    function testMint() public {
        volcanoNFT.mint(owner, "abc");
        uint256 balance = volcanoNFT.balanceOf(owner);
        assertEq(balance, 1);
    }


     function testTransfer() public {
        volcanoNFT.mint(owner, "abc");
        volcanoNFT.transferFrom(owner, otherAccount, 1);
        assertEq(volcanoNFT.balanceOf(owner), 0);
        assertEq(volcanoNFT.balanceOf(otherAccount), 1);
    }
}
