import { expect } from "chai";
import { ethers } from "hardhat";
import { VolcanoCoinHw4 } from "../typechain-types/VolcanoCoin_hw4.sol";

async function main() {
  let contractTyped: VolcanoCoinHw4;
  const Factory = await ethers.getContractFactory("VolcanoCoinHw4");

  const contract = (await Factory.deploy()) as VolcanoCoinHw4;

  console.log("Deploying contract");
  await contract.deployed();

  console.log(`deployed to ${contract.address}`);

  const [deployer, otherAccount] = await ethers.getSigners();


  expect((await contract.getTotalSupply()).eq(ethers.BigNumber.from("11000")));
  // lets mint another 1,000 tokens to deployer
  console.log("Calling function using deployer");
  const tx = await contract.mint();
  // This is how events are fetched
  //const receipt = await tx.wait();
  //console.log('receipt.events', receipt.events);

  await expect(tx)
    .to.emit(contract, "Mint")
    .withArgs(11000);

  const balanceDeployer = await contract.getBalance(deployer.address);
  expect(balanceDeployer.eq(ethers.BigNumber.from("11000")));

  // Test other account cannot call mint
  await expect(contract.connect(otherAccount)
    .mint())
    .to.be.revertedWith('not owner');

  // Call transfer from deployer, check if event was emitted
  const txTransfer = await contract.transfer(1000, otherAccount.address);
  await expect(txTransfer)
    .to.emit(contract, "Transfer")
    .withArgs(1000, otherAccount.address);


  // Call balance of other account
  expect((await contract.getBalance(deployer.address)).eq(ethers.BigNumber.from("1000")));

  // Check if payments was updated
  const payments = await contract.getPayments(deployer.address);
  expect(payments[0].amount.eq(ethers.BigNumber.from("1000")));
  expect(payments[0].recipient == otherAccount.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
