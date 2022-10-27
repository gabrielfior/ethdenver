import { ethers } from "hardhat";

async function main() {
  
  const Factory = await ethers.getContractFactory("LeagueManager");
  const leagueManager = await Factory.deploy();

  await leagueManager.deployed();

  console.log(`deployed to ${leagueManager.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
