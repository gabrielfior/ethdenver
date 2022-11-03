// SPDX-License-Identifier: None

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

pragma solidity ^0.8.0;

// Volcano coin to be accepted as payment for NFT minting.
contract VolcanoCoinHw10 is ERC20 {
    constructor() ERC20("VolcanoCoinHw10", "VCHW10") {
        _mint(msg.sender, 1_000);
    }
}

contract VolcanoNFTHw10 is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 amountVolcanoCoinForMinting;
    VolcanoCoinHw10 private immutable volcanoCoin;

    constructor(
        string memory name,
        string memory symbol,
        VolcanoCoinHw10 _volcanoCoin,
        uint256 _amountVolcanoCoinForMinting
    ) ERC721(name, symbol) {
        volcanoCoin = _volcanoCoin;
        amountVolcanoCoinForMinting = _amountVolcanoCoinForMinting;
    }

    function mint(address _to, string memory _tokenURI) public payable {
        // ether was provided
        // else Volcano coin was provided
        // else fail
        if (msg.value < 0.01 ether) {
            transferVolcanoCoinFromSenderIntoContract(
                msg.sender,
                amountVolcanoCoinForMinting
            );
        }
        mintNFT(_to, _tokenURI);
    }

    function transferVolcanoCoinFromSenderIntoContract(
        address sender,
        uint256 amount
    ) internal {
        bool success = volcanoCoin.transferFrom(sender, address(this), amount);
        require(
            success,
            "Could not transfer Volcano coin from sender to contract"
        );
    }

    function mintNFT(address _to, string memory _tokenURI) internal {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(_to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
    }

    function withdraw() public onlyOwner {
        uint256 currentBalance = address(this).balance;
        (bool sent, ) = address(msg.sender).call{value: currentBalance}("");
        require(sent, "Failed to send Ether");
        // also send volcano coins
        bool sentVolcanoCoin = volcanoCoin.transfer(
            owner(),
            volcanoCoin.balanceOf(address(this))
        );
        require(sentVolcanoCoin, "Failed to send Volcano coin");
    }
}
