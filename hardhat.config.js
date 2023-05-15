require("@nomicfoundation/hardhat-toolbox");

require("@nomiclabs/hardhat-etherscan");

let secret = require("./secreate")

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.6.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.5.16",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.4.18",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  networks: {
    matic:{
      url:secret.url1,
      accounts:[secret.key],
      gasPrice:52000000000, 
      gasLimit: 3912795
    },
    rinkeby:{
      url:secret.url,
      accounts:[secret.key]
    },
    testnet:{
      url:secret.url2,
      accounts:[secret.key]
    }
  },
  etherscan:{
    apiKey:""
  }
};
