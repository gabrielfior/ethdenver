import { expect } from "chai";
import { ethers } from "hardhat";
import { VolcanoNFTHw16 } from "../src/types";
import * as hre from "hardhat";

async function main() {
    const contractName = "VolcanoNFTHw16";
    
    const deployedContract = await hre.deployments.get(contractName);
    console.log('address', deployedContract.address);
    
    const contract = await ethers.getContractAt(contractName, deployedContract.address);
    const imageURI = 'https://bafybeiaziiiu4ar3w4idr7m7azs5a2lxmjj76g7qz3frrrywpdisgmzl3i.ipfs.nftstorage.link/';
    
    console.log(`deployed to ${deployedContract.address}`);

    const [deployer, otherAccount] = await ethers.getSigners();
    console.log('minting');
    const tx = await contract.mint(deployer.address, imageURI);
    console.log('executed tx', tx);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
