// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../contracts/ShameCoin.sol";
import "forge-std/console.sol";

/// @title An ERC-20 compatible ShameCoin.
/// @author Gabriel Fior
/// @dev Functions deviate from ERC20, see specific comments on each function.
contract ShameCoinTest is Test {
    ShameCoin private shameCoin;
    address owner;
    address otherAccount;
    address ZERO_ADDRESS = address(0);

    function setUp() public {
        shameCoin = new ShameCoin("name","symbol");
        owner = address(this);
        otherAccount = vm.addr(2);
    }

    function testOwnerIsSet() public {
        assertEq(owner, shameCoin.owner());
    }

    function testTransferWithOwner() public {
        // mint 1 token to owner
        // transfer to address 2
        // check that addr 2 balanceOf == 1
        shameCoin.mint(owner, 1);
        shameCoin.transfer(otherAccount, 1);
        assertEq(shameCoin.balanceOf(otherAccount), 1);
    }
    function testTransferWithoutOwner() public {
        // call transfer from addr2
        // check that balanceOf == 1
        vm.prank(otherAccount);
        shameCoin.transfer(owner, 1);
        assertEq(shameCoin.balanceOf(otherAccount), 1);
    }

    function testTransferFrom() public {
        // mint 1 to owner
        // call transferFrom using owner to addr2
        // assert balance owner is 0
        // assert balance addr2 is 0
        shameCoin.mint(owner, 1);
        // increase allowance of owner and other account      

        shameCoin.transferFrom(owner, otherAccount, 1);
        assertEq(shameCoin.balanceOf(owner), 0);
        assertEq(shameCoin.balanceOf(otherAccount), 0);
    }
}
