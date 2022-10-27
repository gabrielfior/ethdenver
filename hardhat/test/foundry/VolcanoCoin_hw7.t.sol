// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../contracts/VolcanoCoin_hw7.sol";

contract VolcanoCoin_hw7Test is Test {
    
    VolcanoCoinHw7 private volcanoCoin;
    address otherAccount;

    function setUp() public {
        volcanoCoin = new VolcanoCoinHw7();
    }

    function testTotalSupply() public {
        assertEq(volcanoCoin.getTotalSupply(), 10_000);
    }

    function testCanIncreaseTotalSupply() public {
        volcanoCoin.mint();
        assertEq(volcanoCoin.getTotalSupply(), 11_000);
    }

    event Mint(uint256 newTotalSupply);

    function testIncreaseTotalSupplyEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Mint(11_000);
        volcanoCoin.mint();
    }

    function testNotOwnerCannotIncreaseTotalSupply() public {
        vm.prank(otherAccount);
        vm.expectRevert(abi.encodePacked("Ownable: caller is not the owner"));
        volcanoCoin.mint();
    }
}
