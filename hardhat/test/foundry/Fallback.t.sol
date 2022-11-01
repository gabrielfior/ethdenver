// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../contracts/FallbackExample.sol";
import "forge-std/console.sol";

contract FallbackTest is Test {
    Fallback private fallbackContract;

    function setUp() public {
        fallbackContract = new Fallback();
        console.log("deployed %s", address(fallbackContract));
    }

    function testReceiveCalled() public {
        vm.expectEmit(true, false, false, true);
        emit Log("receive");
        (bool sent, ) = address(fallbackContract).call{
            value: 0.001 ether,
            gas: 500000
        }("");
        assertEq(sent, true);
    }

    event Log(string indexed func);

    function testFallbackCalled() public {
        vm.expectEmit(true, false, false, true);
        emit Log("fallback");
        (bool sent, ) = address(fallbackContract).call("not-empty");
        assertEq(sent, true);
    }

    function testFallbackNotCalled() public {
        (bool sent, ) = address(fallbackContract).call{value: 0.1 ether}("not-empty");
        assertEq(sent, false);
    }
}
