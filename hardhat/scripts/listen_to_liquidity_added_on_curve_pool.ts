
import { expect } from "chai";
import { ethers } from "hardhat";
import { VolcanoNFTHw16 } from "../src/types";
import * as hre from "hardhat";
import * as abi2 from './curve_pool_abi.json';
import * as dotenv from "dotenv";
dotenv.config();

async function main() {

    var url = process.env.ALCHEMY_API_MAINNET_WSS;
    let curve3poolMainnetaddr = "0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7";
    
    // Either fetch contract using compiled Vyper local copy...
    //const contract = await ethers.getContractAt("StableSwap3Pool", curve3poolMainnetaddr);
    // or fetch using hard-coded JSON ABI from ETHexplorer
    const contract = await ethers.getContractAt(abi2.data, curve3poolMainnetaddr);
    console.log('contract', contract.address);
    
    contract.on("AddLiquidity", (provider, token_amounts, fees, invariant, token_supply) => {
        console.log(provider, token_amounts, fees, invariant, token_supply);
    });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

