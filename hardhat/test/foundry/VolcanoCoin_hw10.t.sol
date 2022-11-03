// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../contracts/VolcanoNFT_hw10.sol";
import "forge-std/console.sol";

contract VolcanoNFT_hw10Test is Test {
    VolcanoNFTHw10 private volcanoNFT;
    VolcanoCoinHw10 private volcanoCoin;
    address owner;
    address otherAccount;
    address ZERO_ADDRESS = address(0);
    uint256 amountVolcanoCoin = 1;

    function setUp() public {
        volcanoCoin = new VolcanoCoinHw10();
        volcanoNFT = new VolcanoNFTHw10(
            "NFT1",
            "myNFT",
            volcanoCoin,
            amountVolcanoCoin
        );
        owner = address(this);
        otherAccount = vm.addr(2);
    }

    function testMintFailsWithoutPayment() public {
        vm.prank(otherAccount);
        vm.expectRevert(bytes("ERC20: insufficient allowance"));
        volcanoNFT.mint(owner, "abc");
    }

    function testMintFailsWithTooLittleETH() public {
        vm.expectRevert(bytes("ERC20: insufficient allowance"));
        volcanoNFT.mint{value: 0.001 ether}(owner, "abc");
    }

    function testMintByPayingETH() public {
        volcanoNFT.mint{value: 0.01 ether}(owner, "abc");
        assertEq(volcanoNFT.balanceOf(owner), 1);
    }

    function testMintByPayingVolcanoCoin() public {
        volcanoCoin.approve(address(volcanoNFT), 1000);
        volcanoNFT.mint(owner, "abc");
        assertEq(volcanoNFT.balanceOf(owner), 1);
        assertEq(volcanoCoin.balanceOf(address(volcanoNFT)), amountVolcanoCoin);
    }

    function testWithdrawETH() public {
        uint256 originalBalance = owner.balance;
        volcanoNFT.mint{value: 1 ether}(owner, "abc");
        volcanoNFT.withdraw();

        assertEq(address(volcanoNFT).balance, 0);
        assertEq(address(owner).balance, originalBalance);
    }

    function testWithdrawVolcanoCoin() public {
        volcanoCoin.approve(address(volcanoNFT), 1000);
        uint256 originalBalance = volcanoCoin.balanceOf(owner);
        volcanoNFT.mint(owner, "abc");
        assertEq(volcanoCoin.balanceOf(owner), originalBalance - amountVolcanoCoin);
        assertEq(volcanoCoin.balanceOf(address(volcanoNFT)), amountVolcanoCoin);
        
        volcanoNFT.withdraw();
        assertEq(volcanoCoin.balanceOf(owner), originalBalance);
        assertEq(volcanoCoin.balanceOf(address(volcanoNFT)), 0);
    }

    // For receiving ether from withdraw
    receive() external payable {}
}
