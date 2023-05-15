// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library AmountTransfer {
    function bidAmountTransfer(uint256 _buyAmount, address _erc20, address _to) internal {
        require(
            IERC20(_erc20).transferFrom(_to, address(this), _buyAmount),
            "allowance not enough"
        );
    }

    function nativeAmountTransfer(address _nftSeller, uint256 _buyAmount)
        internal
    {
        (bool success, ) = _nftSeller.call{value: _buyAmount}("");
        require(success, "refund failed");
    }

    function tokenAmountTransfer(
        address _to,
        address _nftSeller,
        address _erc20,
        uint256 _buyAmount
    ) internal {
        require(
            IERC20(_erc20).transferFrom(_to, address(this), _buyAmount),
            "allowance not enough"
        );
        IERC20(_erc20).transfer(_nftSeller, _buyAmount);
    }
}
