import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-chai-matchers";
import 'hardhat-deploy';
import '@nomiclabs/hardhat-ethers';
import "hardhat-gas-reporter";
import "@nomiclabs/hardhat-vyper";
import 'solidity-docgen';
require('dotenv').config({ path: __dirname + '/.env' });

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY ?? "abc";
const ALCHEMY_API_KEY_MAINNET = process.env.ALCHEMY_API_KEY_MAINNET;

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.17",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  docgen: {
    outputDir: './docs/docs',
    pages: 'items'
  },
  vyper: {
    version: "0.2.4",
  },
  namedAccounts: {
    deployer: 0,
    tokenOwner: 1,
  },
  networks: {
    hardhat: {
      forking: {
        url: `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_API_KEY_MAINNET}`
      }
    },
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY]
    },
    mainnet: {
      url: `https://eth-mainnet.g.alchemy.com/v2/6uf6lmLfBbzsWQaxewqSP3F49U0s9BqR`,
      accounts: [GOERLI_PRIVATE_KEY]
    }
  },
  gasReporter: {
    enabled: (process.env.REPORT_GAS) ? true : false,
    currency: "USD"
  },
  typechain: {
    outDir: 'src/types',
    target: 'ethers-v5',
    alwaysGenerateOverloads: false, // should overloads with full signatures like deposit(uint256) be generated always, even if there are no overloads?
    externalArtifacts: ['externalArtifacts/*.json'], // optional array of glob patterns with external artifacts to process (for example external libs from node_modules)
    dontOverrideCompile: false // defaults to false
  }
};

export default config;
