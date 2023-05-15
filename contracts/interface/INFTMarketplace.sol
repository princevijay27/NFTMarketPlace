// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface INFTMarketplace {
    struct FixedSale {
        address nftSeller;
        address nftBuyer;
        address erc20;
        address royaltyReciever;
        uint256 salePrice;
        uint256 royalty;
    }

    struct SaleInfo {
        address _nftContractAddress;
        uint256 _tokenID;
    }

    event NftFixedSale(
        address nftContractAddress,
        address nftSeller,
        address erc20,
        uint256 tokenId,
        uint256 salePrice,
        uint256 timeOfSale
    );

    event CancelNftFixedSale(
        address nftContractAddress,
        address nftSeller,
        uint256 tokenId
    );

    event NftFixedSalePriceUpdated(
        address nftContractAddress,
        uint256 tokenId,
        uint256 updateSalePrice
    );

    event NftBuyFromFixedSale(
        address nftContractAddress,
        address nftBuyer,
        uint256 tokenId,
        uint256 nftBuyPrice
    );

    event UpdateOwner(address oldAddress, address newAddress);
}
