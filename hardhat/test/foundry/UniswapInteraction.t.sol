// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./utils.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@prb/math/contracts/PRBMathUD60x18.sol";
import "@prb/math/contracts/PRBMath.sol";
import "../../contracts/UniswapInteract.sol";

contract UniswapInteractionTest is Test {
    using PRBMathUD60x18 for uint256;
    //using PoolAddress for address;
    UniswapInteract private uniswapInteract;
    ISwapRouter private swapRouter;
    address owner;
    address luckyUser;
    address ZERO_ADDRESS = address(0);

    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public constant BUSD = 0x4Fabb145d64652a948d72533023f6E7A623C7C53;
    address binanceUser = 0xDFd5293D8e347dFe59E90eFd55b2956a1343963d;

    // ToDo - Retrieve pool fees dynamically
    uint24 public constant poolFeeDAIUSDC = 3000;
    uint24 public constant poolFeeDAIBUSD = 500;

    function setUp() public {
        address swapRouterAddr = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
        swapRouter = ISwapRouter(swapRouterAddr);
        uniswapInteract = new UniswapInteract(swapRouter);
        owner = address(this);
        luckyUser = vm.addr(2);
    }

    //function testDummy() public {
    //    console.log(uniswapInteract.dummy());
    //}

    function testSwapExactInputSingleDAItoUSDC() public {
        vm.startPrank(binanceUser);
        // test diff amounts, also split in multiple trades
        uint256 amountIn = PRBMathUD60x18.fromUint(200);
        console.log("amountIn", amountIn);

        uint256 amountOut = approveAndSwap(DAI, USDC,amountIn, poolFeeDAIUSDC);

        assertThatSlippageNotTooHigh(USDC, amountIn, amountOut, 20);

        console.log("executed swap, amount out", amountOut);

        vm.stopPrank();

        // test
        console.log(
            "new usdc balance lucky user",
            IERC20(USDC).balanceOf(luckyUser)
        );
        assertEq(amountOut, IERC20(USDC).balanceOf(luckyUser));
    }

    function approveAndSwap(address tokenIn, address tokenOut, uint256 amountIn, uint24 fee)
        internal
        returns (uint256)
    {
        IERC20(DAI).approve(address(uniswapInteract), amountIn); // authorize spender
        console.log("approved");

        uint256 amountOut = uniswapInteract.swapExactInputSingle(
            binanceUser,
            luckyUser,
            tokenIn,
            tokenOut,
            amountIn,
            fee
        );
        return amountOut;
    }

    function assertThatSlippageNotTooHigh(
        address tokenAddress,
        uint256 amountIn,
        uint256 amountOut,
        uint8 acceptedSlippageInPercent
    ) internal {
        // amountOut (USDC) 6 digits
        uint8 usdcDecimals = ERC20(tokenAddress).decimals();
        uint256 amountInUSD = (amountOut / (10**usdcDecimals));
        uint256 minAmountExpected = PRBMath.mulDiv(amountIn, (100 - acceptedSlippageInPercent), 100); // 8*1e18 (80%, or 20% slippage accepted)
        assertTrue(amountInUSD >= minAmountExpected.toUint());
    }

    function testSwapExactInputSingleDAItoBUSD() public {
        vm.startPrank(binanceUser);
        // test diff amounts, also split in multiple trades
        uint256 amountIn = PRBMathUD60x18.fromUint(200);
        console.log("amountIn", amountIn);

        uint256 amountOut = approveAndSwap(DAI, BUSD,amountIn, poolFeeDAIBUSD);

        assertThatSlippageNotTooHigh(BUSD, amountIn, amountOut, 50);

        console.log("executed swap, amount out", amountOut);

        vm.stopPrank();

        // test
        console.log(
            "new BUSD balance lucky user",
            IERC20(BUSD).balanceOf(luckyUser)
        );
        assertEq(amountOut, IERC20(BUSD).balanceOf(luckyUser));
    }
}
