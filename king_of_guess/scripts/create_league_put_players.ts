import { ethers } from "hardhat";
import { contracts, LeagueManager } from "../src/types";

async function main() {
  
  const Factory = await ethers.getContractFactory("LeagueManager");
  const leagueManager = (await Factory.deploy()) as LeagueManager;

  await leagueManager.deployed();

  console.log(`deployed to ${leagueManager.address}`);
  await createLeague(leagueManager);

  console.log(await leagueManager.getLeague("my_league"));
}

async function createLeague(contract: LeagueManager){
  await contract.createLeague("my_league");
}

async function putPlayers(){}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
