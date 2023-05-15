// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMint is ERC721, Ownable, ReentrancyGuard {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _supply;

    mapping(uint256 => string) tokenMetadataCID;

    // Initializes the contract by setting a `name` and a `symbol`
    constructor() ERC721("TaskNFT", "TNFT") {
        _supply.increment();
    }

    /**
     * Airdrop for promotions & collaborations
     */
    function airDropMint(
        address _to,
        uint256 _quantity,
        string[] memory _uri
    ) external onlyOwner {
        mint(_to, _quantity, _uri);
    }

    //Mint nft
    function mintNFT(
        address _to,
        uint256 _quantity,
        string[] memory _uri
    ) external {
        mint(_to, _quantity, _uri);
    }

    // Get total supply
    function totalSupply() external view returns (uint256) {
        return _supply.current() - 1;
    }

    // Get metadata URI
    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token."
        );

        return tokenMetadataCID[tokenId];
    }

    // Mint an NFT
    function mint(
        address _to,
        uint256 _quantity,
        string[] memory _uri
    ) internal {
        /**
         * To save gas, since we know _quantity won't overflow
         * Checks are performed in caller functions / methods
         */
        unchecked {
            for (uint256 i = 0; i < _quantity; ++i) {
                _safeMint(_to, _supply.current());
                tokenMetadataCID[_supply.current()] = _uri[i];
                _supply.increment();
            }
        }
    }

    // Receive any funds sent to the contract
    receive() external payable {}
}
