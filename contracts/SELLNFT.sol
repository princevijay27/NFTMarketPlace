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

contract SELL is INFTMarketplace, ANFTMarketplace {
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

    function cancelFixedsale(
        address _nftContractAddress,
        uint256 _tokenId
    )
        external
        isNftInFixedSale(_nftContractAddress, _tokenId)
        isSaleResetByOwner(_nftContractAddress, _tokenId)
    {
        IERC721(_nftContractAddress).safeTransferFrom(
            address(this),
            msg.sender,
            _tokenId
        );

        nftSaleStatus[_nftContractAddress][_tokenId] = 0;

        delete fixedSaleNFT[(indexFixedSaleNFT[_nftContractAddress][_tokenId])];

        emit CancelNftFixedSale(_nftContractAddress, msg.sender, _tokenId);
    }

    function nftFixedSale(
        address _nftContractAddress,
        address _erc20,
        address _royaltyReciever,
        uint256 _royalty,
        uint256 _tokenId,
        uint256 _salePrice
    )
        external
        isSaleStartByOwner(_nftContractAddress, _tokenId)
        isNftAlreadyInSale(_nftContractAddress, _tokenId)
        isContractApprove(_nftContractAddress, _tokenId)
        priceGreaterThanZero(_salePrice)
    {
        nftContractFixedSale[_nftContractAddress][_tokenId] = FixedSale(
            msg.sender,
            address(0),
            _erc20,
            _royaltyReciever,
            _salePrice,
            _royalty
        );

        nftSaleStatus[_nftContractAddress][_tokenId] = 1;

        indexFixedSaleNFT[_nftContractAddress][_tokenId] = fixedSaleNFT.length;
        fixedSaleNFT.push(SaleInfo(_nftContractAddress, _tokenId));

        IERC721(_nftContractAddress).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId
        );

        emit NftFixedSale(
            _nftContractAddress,
            msg.sender,
            _erc20,
            _tokenId,
            _salePrice,
            block.timestamp
        );
    }

    function updateFixedSalePrice(
        address _nftContractAddress,
        uint256 _tokenId,
        uint256 _updateSalePrice
    )
        external
        isNftInFixedSale(_nftContractAddress, _tokenId)
        isSaleResetByOwner(_nftContractAddress, _tokenId)
        priceGreaterThanZero(_updateSalePrice)
    {
        nftContractFixedSale[_nftContractAddress][_tokenId]
            .salePrice = _updateSalePrice;

        emit NftFixedSalePriceUpdated(
            _nftContractAddress,
            _tokenId,
            _updateSalePrice
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
