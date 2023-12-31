// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTFactory is ERC721URIStorage, Ownable {
    uint256 private _tokenIds;

    constructor() ERC721("Hero Ticket NFT", "HTN") Ownable(msg.sender) {}

    // NFT를 민팅하는 함수
    function mintNFT(
        address recipient,
        string memory tokenURI
    ) public onlyOwner returns (uint256) {
        _tokenIds = _tokenIds + 1;
        uint256 newItemId = _tokenIds;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    // TODO: Make the NFT SoulBound
}
