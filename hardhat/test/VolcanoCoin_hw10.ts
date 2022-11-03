import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { VolcanoCoinHw10, VolcanoNFTHw10 } from "../src/types/contracts/VolcanoNFT_hw10.sol";

// using interface as it allows for passing the types.
interface ContractsAndSigner {
  coinContract: VolcanoCoinHw10,
  nftContract: VolcanoNFTHw10,
  owner: ethers.Signer,
  otherAccount: ethers.Signer,
  provider: ethers.providers
}

const AMOUNT_VOLCANO_COIN = 1;

describe("VolcanoCoinHw10", () => {
  async function deploy(): Promise<ContractsAndSigner> {
    const [owner, otherAccount] = await ethers.getSigners();

    const CoinFactory = await ethers.getContractFactory("VolcanoCoinHw10");
    const coinContract = await CoinFactory.deploy() as VolcanoCoinHw10;

    const NFTFactory = await ethers.getContractFactory("VolcanoNFTHw10");
    const nftContract = await NFTFactory.deploy("NFT1", "myNFT", coinContract.address, AMOUNT_VOLCANO_COIN) as VolcanoNFTHw10;
    const provider = ethers.provider;

    return { coinContract, nftContract, owner, otherAccount, provider };
  }

  describe("Mint", function () {
    it("Mint should fail without payment", async function () {
      const c: ContractsAndSigner = await loadFixture(deploy);
      await expect(c.nftContract.mint(c.owner.address, "abc")).to.be.revertedWith("ERC20: insufficient allowance");
    });

    it("Mint should fail with little ETH", async function () {
      const c: ContractsAndSigner = await loadFixture(deploy);
      await expect(c.nftContract.mint(c.owner.address, "abc", { value: ethers.utils.parseEther("0.001") })).to.be.revertedWith("ERC20: insufficient allowance");
    });

    it("Mint should succeed if paying ETH", async function () {
      const c: ContractsAndSigner = await loadFixture(deploy);
      await c.nftContract.mint(c.owner.address, "abc", { value: ethers.utils.parseEther("1") });
      expect(await c.nftContract.balanceOf(c.owner.address)).to.be.equal(1);
    });

    it("Mint should succeed if paying Volcano coin", async function () {
      const c: ContractsAndSigner = await loadFixture(deploy);
      await c.coinContract.approve(c.nftContract.address, 1000);
      await c.nftContract.mint(c.owner.address, "abc");
      expect(await c.nftContract.balanceOf(c.owner.address)).to.be.equal(1);
      expect(await c.coinContract.balanceOf(c.nftContract.address)).to.be.equal(AMOUNT_VOLCANO_COIN);
    });
  });

  describe("Withdraw", function () {
    it("Withdraw should empty contract's ETH balance", async function () {
      const c: ContractsAndSigner = await loadFixture(deploy);

      await expect(c.nftContract.mint(c.owner.address, "abc", { value: ethers.utils.parseEther("1") })).to.changeEtherBalances(
        [c.owner, c.nftContract],
        [ethers.utils.parseEther("1").mul(-1), ethers.utils.parseEther("1")]
      );

      await expect(c.nftContract.withdraw()).to.changeEtherBalances(
        [c.owner, c.nftContract],
        [ethers.utils.parseEther("1"), ethers.utils.parseEther("1").mul(-1)]
      );
    });

    it("Withdraw should empty contract's VolcanoCoin balance", async function () {
      const c: ContractsAndSigner = await loadFixture(deploy);
      await c.coinContract.approve(c.nftContract.address, 10000);
      const originalOwnerBalance = await c.coinContract.balanceOf(c.owner.address);

      await expect(() => c.nftContract.mint(c.owner.address, "abc"))
        .to.changeTokenBalances(c.coinContract, [c.owner, c.nftContract],
          [-AMOUNT_VOLCANO_COIN, AMOUNT_VOLCANO_COIN]);

      await expect(() => c.nftContract.withdraw())
        .to.changeTokenBalances(c.coinContract, [c.owner, c.nftContract],
          [AMOUNT_VOLCANO_COIN, -AMOUNT_VOLCANO_COIN]);

    });
  });
});