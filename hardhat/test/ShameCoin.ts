import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ShameCoin } from "../src/types";
import {ethers} from "hardhat";

describe("ShameCoin", () => {
  async function deploy(): Promise<any> {
    const [owner, otherAccount] = await ethers.getSigners();

    const CoinFactory = await ethers.getContractFactory("ShameCoin");
    const coinContract = await CoinFactory.deploy("name","symbol") as ShameCoin;


    return { coinContract, owner, otherAccount };
  }

  describe("Owner", function () {
    it("Constructor should set owner", async function () {
      const {coinContract, owner, otherAccount} = await loadFixture(deploy);
      const typedCoinContract = coinContract as ShameCoin;
      expect(await typedCoinContract.owner()).to.be.equal(owner.address);
    });

    it("Approve should work with amount 1 and owner", async function () {
      const {coinContract, owner, otherAccount} = await loadFixture(deploy);
      const typedCoinContract = coinContract as ShameCoin;
      // call approve from otherAccount
      // _allowances of owner should be 1
      await coinContract.connect(otherAccount).approve(owner.address, 1);
      expect(await typedCoinContract.allowance(otherAccount.address, owner.address)).to.be.equal(ethers.BigNumber.from("1"));
    });

  });
});