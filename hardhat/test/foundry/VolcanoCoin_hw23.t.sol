// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../contracts/VolcanoCoin_hw23.sol";
import "forge-std/console.sol";

contract VolcanoCoin_hw23Test is Test {
    VolcanoCoinHw23 private volcanoCoin;
    address owner;
    address otherAccount;
    address ZERO_ADDRESS = address(0);
    uint256 amountVolcanoCoin = 1;

    function setUp() public {
        volcanoCoin = new VolcanoCoinHw23();
        owner = address(this);
        otherAccount = vm.addr(2);
    }

    function testInitSetsPaused() public {
        assertEq(volcanoCoin.paused(), false);
    }

    /** Gas-efficient function for appending strings.
     * @param   a  First string
     * @param   b  Second string
     * @return  string  Concatenated string
     */
    function concat(
        string memory a,
        string memory b
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }

    function testConcat() public {
        string memory c = concat("Moto", "boy");
        assertEq("Motoboy", c);
    }
}
