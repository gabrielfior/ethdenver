
import { expect } from "chai";
import { ethers } from "hardhat";
import { VolcanoNFTHw16 } from "../src/types";
import * as hre from "hardhat";
import * as dotenv from "dotenv";
dotenv.config();

async function main() {

    var url = process.env.ALCHEMY_API_MAINNET_WSS;
    console.log('url', url);
    var customWsProvider = new ethers.providers.WebSocketProvider(url!);
    customWsProvider.on("pending", (tx) => {
        customWsProvider.getTransaction(tx).then(function (transaction) {
            console.log(transaction);
        });
    });

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

