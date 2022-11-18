import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { MyERC20, ShameCoin } from "../src/types";
import * as daiAbi from './daiAbi.json';
import * as hre from "hardhat";
import {
  abi as SWAP_ROUTER_ABI,
  bytecode as SWAP_ROUTER_BYTECODE,
} from '@uniswap/swap-router-contracts/artifacts/contracts/SwapRouter02.sol/SwapRouter02.json';

const binanceAccountAddress = "0xDFd5293D8e347dFe59E90eFd55b2956a1343963d";

async function startImpersonating() {
  // start impersonating
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [binanceAccountAddress],
  });
  const signer = await ethers.getSigner(binanceAccountAddress);
  return signer;
}

async function stopImpersonating() {
  // stop impersonating
  await hre.network.provider.request({
    method: "hardhat_stopImpersonatingAccount",
    params: [binanceAccountAddress],
  });
}

describe("Uniswapv3", () => {
  async function deploy(): Promise<any> {
    const [owner, otherAccount] = await ethers.getSigners();
    const UniswapV3Address = "0xe592427a0aece92de3edee1f18e0157c05861564";

    const uniswapv3Router = await ethers.getContractAt(SWAP_ROUTER_ABI, UniswapV3Address);
    //const impersonatedBinanceAccount = await ethers.getImpersonatedSigner();

    //const daiContract = await ethers.getContractAt(daiAbi.data, "0xE592427A0AEce92De3Edee1F18E0157C05861564");
    const daiAddress = "0x6b175474e89094c44da98b954eedeac495271d0f";
    const daiContract = await ethers.getContractAt("MyERC20", daiAddress);


    return { owner, otherAccount, uniswapv3Router, daiContract };
  }

  describe("Owner", function () {
    const binanceAccountAddress = "0xDFd5293D8e347dFe59E90eFd55b2956a1343963d";
    xit("Should start", async function () {
      const { owner, otherAccount, uniswapv3Router, daiContract } = await loadFixture(deploy);
      //console.log('router', uniswapv3Router); 

      const signer = await startImpersonating();
      console.log('signer', signer);
      const daiContractTyped = daiContract as MyERC20;
      const balance = await daiContractTyped.balanceOf(signer.address);
      console.log('balance', balance);

      await stopImpersonating();

    });

    xit("Should swap", async function () {
      // Not working, see Uniswapv3.t.sol for a working test

      const USDCAddress = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
      const BUSDAddress = "0x4Fabb145d64652a948d72533023f6E7A623C7C53";

      // careful - usdc has only 6 decimals
      const usdcContract = await ethers.getContractAt(daiAbi.data, USDCAddress) as MyERC20;
      const busdContract = await ethers.getContractAt(daiAbi.data, BUSDAddress) as MyERC20;

      const { owner, otherAccount, uniswapv3Router, daiContract } = await loadFixture(deploy);
      console.log('owner', owner.address);
      const signer = await startImpersonating();
      console.log('signer', signer.address);


      // approve
      await daiContract.connect(signer).approve(uniswapv3Router.address, hre.ethers.utils.parseEther("1000000"));
      console.log('approved');

      const blockNumBefore = await ethers.provider.getBlockNumber();
      const blockBefore = await ethers.provider.getBlock(blockNumBefore);
      const timestampBefore = blockBefore.timestamp;
      console.log('time before', timestampBefore);
      
      const tx = await uniswapv3Router.connect(signer).exactInputSingle({
        tokenIn: daiContract.address,
        tokenOut: USDCAddress,
        fee: 3000,
        recipient: otherAccount.address,
        deadline: timestampBefore + 600, // 10min
        amountIn: ethers.utils.parseEther("1"),
        amountOutMinimum: 0, // beware of risks!
        sqrtPriceLimitX96: 0
      }, { gasLimit: 20_000_000 });
      console.log('swap', tx);
      await tx.wait();
      expect(await usdcContract.balanceOf(otherAccount.address)).to.be.equal(hre.ethers.BigNumber.from("1000"));

      await stopImpersonating();

    });
  });
});