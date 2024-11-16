// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.25;

import {Script} from "lib/forge-std/src/Script.sol";
import {ISuperchainTokenBridge} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainTokenBridge.sol";
import {ISuperchainWETH} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainWETH.sol";

contract SupersimInteractions is Script {
    address public constant SUPERCHAIN_TOKEN_BRIDGE = 0x4200000000000000000000000000000000000028;
    address public constant SUPERCHAIN_WETH_TOKEN = 0x4200000000000000000000000000000000000024;
    uint256 private privateKey;

    function mintWETH() public {
        vm.startBroadcast(privateKey);
        (bool success,) = payable(SUPERCHAIN_WETH_TOKEN).call{value: 1 ether}("");
        require(success, "Transfer failed!");
        vm.stopBroadcast();
        uint256 userBalanceOfWETH = ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).balanceOf(vm.addr(privateKey));
        console.log("WETH balance: ", userBalanceOfWETH);
    }

    function sendWETHToOtherChain(uint256 amount) public {
        uint256 chain_b_chainid = 902; // Chain ID for Chain B
        address to = vm.addr(privateKey); // send tokens to the same address on chain B

        vm.startBroadcast(privateKey);
        ISuperchainTokenBridge(SUPERCHAIN_TOKEN_BRIDGE).sendERC20(SUPERCHAIN_WETH_TOKEN, to, amount, chain_b_chainid);
        vm.stopBroadcast();
        console.log("WETH balance after transfer: ", ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).balanceOf(to));
    }

    function run() public {
        privateKey = vm.envUint("ANVIL_ACCOUNT1_PRIVATE_KEY");
        mintWETH(); // Commented out since we've already minted
        sendWETHToOtherChain(1 ether); // Transfer 1 WETH to Chain B
    }
}
