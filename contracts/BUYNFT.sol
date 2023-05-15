// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/INFTMarketplace.sol";
import "./Abstract/ANFTMarketplace.sol";
import "./library/AmountTransfer.sol";

contract BUYNFT is INFTMarketplace, ANFTMarketplace {
    using SafeMath for uint256;

    constructor(address _owner) {
        owner = _owner;
    }

    // owner Function

    function setOwner(address _owner) external onlyOwner {
        owner = _owner;
        emit UpdateOwner(msg.sender, _owner);
    }

    // NFT FIXED SALE

    function buyFromFixedSale(
        address _nftContractAddress,
        uint256 _tokenId,
        uint256 _amount
    )
        external
        payable
        isNftInFixedSale(_nftContractAddress, _tokenId)
        priceGreaterThanZero(_amount)
        buyPriceMeetSalePrice(_nftContractAddress, _tokenId, _amount)
    {
        IERC721(_nftContractAddress).safeTransferFrom(
            address(this),
            msg.sender,
            _tokenId
        );

        nftSaleStatus[_nftContractAddress][_tokenId] = 0;
        delete fixedSaleNFT[(indexFixedSaleNFT[_nftContractAddress][_tokenId])];

        nftContractFixedSale[_nftContractAddress][_tokenId].nftBuyer = msg
            .sender;

        _isTokenOrCoin(
            nftContractFixedSale[_nftContractAddress][_tokenId].royaltyReciever,
            nftContractFixedSale[_nftContractAddress][_tokenId].nftSeller,
            nftContractFixedSale[_nftContractAddress][_tokenId].erc20,
            nftContractFixedSale[_nftContractAddress][_tokenId].salePrice,
            nftContractFixedSale[_nftContractAddress][_tokenId].royalty,
            false
        );

        emit NftBuyFromFixedSale(
            _nftContractAddress,
            msg.sender,
            _tokenId,
            _amount
        );
    }

    //view function

    function getFixedSale(
        address _nftContractAddress,
        uint256 _tokenId
    ) external view returns (FixedSale memory) {
        return nftContractFixedSale[_nftContractAddress][_tokenId];
    }

    function getFixedSaleNFT() external view returns (SaleInfo[] memory) {
        return fixedSaleNFT;
    }

    function onERC721Received(
        address,
        address from,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}
