// SPDX-License-Identifier: None

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

pragma solidity ^0.8.0;

contract VolcanoNFTHw9 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor (string memory name, string memory symbol) ERC721(name, symbol) {}

    function mint(address _to, string memory _tokenURI) public {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(_to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
    }
}
