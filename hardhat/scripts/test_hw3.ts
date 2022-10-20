import { expect } from "chai";
import { ethers } from "hardhat";

async function main() {
  
  const BootcampFactory = await ethers.getContractFactory("BootcampContractHw3");
  const bootcamp = await BootcampFactory.deploy();

  console.log("Deploying Bootcamp contract");
  await bootcamp.deployed();

  console.log(`deployed to ${bootcamp.address}`);

  const accounts = await ethers.getSigners();

console.log("Calling function using deployer");
const nullAddress = await bootcamp.getDeployerOrNull();
const NULL_ADDRESS = '0x000000000000000000000000000000000000dEaD';
expect(NULL_ADDRESS == nullAddress);

console.log("Calling function using other address");

const deployer = await bootcamp.connect(accounts[1]).getDeployerOrNull();
expect(deployer == accounts[0]);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
