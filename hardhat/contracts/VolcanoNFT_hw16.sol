// SPDX-License-Identifier: None

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

pragma solidity ^0.8.0;

// We are just interested in metadata and generous, no payment needed at the moment
contract VolcanoNFTHw16 is ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIds;

    // Based on https://gist.github.com/farzaa/dc45da3eb91a41913767f3eb4d7830f1
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>firstsecondthird</text> <image href='";
        string endSvg = "' height='500' width='200' /></svg>";

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function mint(address _to, string memory imgHref) public payable {
        mintNFT(_to, imgHref);
    }

    function mintNFT(address _to, string memory imgHref) internal {
        uint256 newTokenId = _tokenIds.current();
        _safeMint(_to, newTokenId);
        _setTokenURI(newTokenId, deriveTokenURI(imgHref));
        _tokenIds.increment();
        console.log("NFT with ID %s minted to %s", newTokenId, msg.sender);
    }

    function deriveTokenURI(string memory imgHref)
        internal
        view
        returns (string memory)
    {
       
        string memory finalSvg = string(abi.encodePacked(baseSvg, imgHref, endSvg));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "My nice name"',
                        ', "description": "My nice description."',
                        ',"attributes": [{"trait_type": "Eyes", "value": "Big"}]',
                        ', "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return finalTokenUri;
    }
}
