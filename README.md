# Marketplace Smart Contract for Buying and Selling NFTs

This repository contains a smart contract implementation for a decentralized marketplace that allows users to buy and sell non-fungible tokens (NFTs) using a custom ERC20 token and the native coin of the blockchain network.

## Smart Contract Details

The smart contract is written in Solidity, a programming language specifically designed for developing smart contracts on blockchain platforms. The contract utilizes the ERC721 standard for NFTs and the ERC20 standard for the custom token.

The key features of the smart contract include:

Buy NFTs: Users can purchase NFTs listed on the marketplace using either the custom ERC20 token or the native coin of the blockchain network.

Sell NFTs: Sellers can list their NFTs for sale on the marketplace, specifying the desired price in either the custom ERC20 token or the native coin.

Escrow Mechanism: The contract acts as an escrow service, holding the NFT in custody until the buyer successfully completes the purchase.

Transfers and Approvals: Ownership of NFTs can be transferred between users, and the contract enforces proper authorization through approval mechanisms.

Payment Handling: The contract manages the transfer of tokens between buyer and seller, ensuring secure and reliable transactions.

## Getting Started

To use this marketplace smart contract, follow these steps:

1. Clone the repository to your local development environment.
2. Install the necessary dependencies using a package manager like npm or yarn.
3. Configure the deployment parameters in the smart contract code, such as the address of the custom ERC20 token contract.
4. Compile the smart contract using a Solidity compiler such as solc.
5. Deploy the smart contract to your desired blockchain network using a tool like Truffle or Remix IDE.
6. Interact with the deployed contract through its public methods to buy, sell, transfer, or approve NFTs.

Please note that this repository only provides the smart contract code and does not include a user interface or frontend application. You may need to build your own frontend or integrate the contract into an existing application to provide a user-friendly interface for the marketplace.

## Deployment

To run the project
so that all the dependency install

```bash
  npm i
```

For compile the smart contract

```bash
  npx hardhat compile
```

Deploying smart contract to live network

```bash
  npx hardhat run scripts/NFTMint.js --network choose network
```

From this smart contract Deployed into public blockchain and you will get Factory Contract address

## License

This project is licensed under the MIT License. Feel free to use, modify, and distribute the code for your own purposes. However, please note that this code is provided as-is, without any warranties or guarantees. Use it at your own risk.

## Acknowledgements

- [Smart Contract tutorial](https://ethereum.org/en/developers/tutorials/)
- [Hardhat tutorial](https://hardhat.org/tutorial)

We would like to acknowledge the open-source community and the various contributors who have shared their knowledge and expertise in smart contract development. Their valuable insights and contributions have greatly helped in shaping this marketplace smart
