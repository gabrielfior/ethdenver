import { expect } from "chai";
import { ethers } from "hardhat";
import { VolcanoNFTHw9 } from "../src/types";

async function main() {
  const Factory = await ethers.getContractFactory("VolcanoNFTHw9");

  const contract = (await Factory.deploy("my-nft", "MY_NFT")) as VolcanoNFTHw9;

  console.log("Deploying contract");
  await contract.deployed();

  console.log(`deployed to ${contract.address}`);

  const [deployer, otherAccount] = await ethers.getSigners();

  // mint new NFTs
  const tokenMintTx = await contract.mint(deployer.address, "https://google.com");
  await tokenMintTx.wait();
  await expect(tokenMintTx)
    .to.emit(contract, "Transfer")
    .withArgs(ethers.constants.AddressZero, deployer.address, 1);

  let balance = await contract.balanceOf(deployer.address);
  expect((balance).eq(ethers.BigNumber.from("1")));

  // transfer an NFT
  const transferTx = await contract.transferFrom(deployer.address, otherAccount.address, 1);
  balance = await contract.balanceOf(deployer.address);
  expect((balance).eq(ethers.BigNumber.from("0")));
  const newBalance = await contract.balanceOf(otherAccount.address);
  expect((newBalance).eq(ethers.BigNumber.from("1")));

  await expect(transferTx)
    .to.emit(contract, "Transfer")
    .withArgs(deployer.address, otherAccount.address, 1);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
