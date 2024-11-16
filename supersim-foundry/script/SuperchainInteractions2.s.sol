// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.25;

import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/Console.sol";
import {ISuperchainTokenBridge} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainTokenBridge.sol";
import {ISuperchainWETH} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainWETH.sol";

contract SupersimInteractions2 is Script {
    address payable public constant SUPERCHAIN_WETH_TOKEN = payable(0x4200000000000000000000000000000000000024);
    uint256 private privateKey;

    function getWETHTokenBalance() public view {
        address account = vm.addr(privateKey);
        uint256 balance = ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).balanceOf(account);
        console.log("WETH balance of user: ", balance);
    }

    function run() public {
        privateKey = vm.envUint("ANVIL_ACCOUNT1_PRIVATE_KEY");
        getWETHTokenBalance();
    }
}
