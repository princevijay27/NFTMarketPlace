// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../interface/INFTMarketplace.sol";
import "../library/AmountTransfer.sol";

abstract contract ANFTMarketplace is INFTMarketplace {
    using SafeMath for uint256;

    address public owner;

    mapping(address => mapping(uint256 => uint256)) indexFixedSaleNFT;
    mapping(address => mapping(uint256 => FixedSale)) nftContractFixedSale;
    mapping(address => mapping(uint256 => uint256)) public nftSaleStatus;

    SaleInfo[] fixedSaleNFT;

    modifier buyPriceMeetSalePrice(
        address _nftContractAddress,
        uint256 _tokenId,
        uint256 _buyPrice
    ) {
        require(
            _buyPrice >=
                nftContractFixedSale[_nftContractAddress][_tokenId].salePrice,
            "buy Price not enough"
        );
        _;
    }

    modifier isContractApprove(address _nftContractAddress, uint256 _tokenId) {
        require(
            IERC721(_nftContractAddress).isApprovedForAll(
                msg.sender,
                address(this)
            ),
            "Nft not approved to contract"
        );
        _;
    }

    modifier isNftAlreadyInSale(address _nftContractAddress, uint256 _tokenId) {
        require(
            nftSaleStatus[_nftContractAddress][_tokenId] == 0,
            "Nft already in sale"
        );
        _;
    }

    modifier isNftInFixedSale(address _nftContractAddress, uint256 _tokenId) {
        require(
            nftSaleStatus[_nftContractAddress][_tokenId] == 1,
            "Nft not in fixed sale"
        );
        _;
    }

    modifier isSaleStartByOwner(address _nftContractAddress, uint256 _tokenId) {
        require(
            msg.sender == IERC721(_nftContractAddress).ownerOf(_tokenId),
            "You are not nft owner"
        );
        _;
    }

    modifier isSaleResetByOwner(address _nftContractAddress, uint256 _tokenId) {
        require(
            msg.sender ==
                nftContractFixedSale[_nftContractAddress][_tokenId].nftSeller,
            "You are not nft owner"
        );
        _;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Caller is not a owner");
        _;
    }

    modifier priceGreaterThanZero(uint256 _price) {
        require(_price > 0, "Price cannot be 0");
        _;
    }

    function _isTokenOrCoin(
        address _royaltyReciever,
        address _nftSeller,
        address _erc20,
        uint256 _buyAmount,
        uint256 _royalty,
        bool auction
    ) internal {
        uint256 royalty = (_buyAmount * _royalty) / uint256(100);

        uint256 userAmount = _buyAmount - royalty;

        if (_erc20 != address(0)) {
            if (auction) {
                IERC20(_erc20).transfer(_nftSeller, userAmount);
                IERC20(_erc20).transfer(_royaltyReciever, royalty);
            } else {
                AmountTransfer.tokenAmountTransfer(
                    msg.sender,
                    _nftSeller,
                    _erc20,
                    userAmount
                );
                AmountTransfer.tokenAmountTransfer(
                    msg.sender,
                    _royaltyReciever,
                    _erc20,
                    royalty
                );
            }
        } else {
            AmountTransfer.nativeAmountTransfer(_nftSeller, userAmount);
            AmountTransfer.nativeAmountTransfer(_royaltyReciever, royalty);
        }
    }
}
