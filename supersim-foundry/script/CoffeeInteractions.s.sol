// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.25;

import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/Console.sol";
import {ISuperchainTokenBridge} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainTokenBridge.sol";
import {ISuperchainWETH} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainWETH.sol";
import {Deploy} from "./Deploy.s.sol";
import {ForwarderInteractions} from "./ForwarderInteractions.s.sol";
import {CoffeeShop} from "../src/CoffeeShop.sol";
import {Multicaller} from "../src/Multicaller.sol";
import {Forwarder} from "../src/Forwarder.sol";

contract CoffeeInteractions is Script {
    address public constant SUPERCHAIN_TOKEN_BRIDGE = 0x4200000000000000000000000000000000000028;
    address payable public constant SUPERCHAIN_WETH_TOKEN = payable(0x4200000000000000000000000000000000000024);
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public constant CHAINID_2 = 902;

    uint256 private privateKey;

    Deploy public deploy;
    ForwarderInteractions public forwarderInt;
    CoffeeShop private coffeeShop;
    Forwarder private forwarder;
    Multicaller private multicaller;

    uint256[] public chainIds;
    address[] public targetContracts;
    uint256[] public amounts;

    function multicallForwarders() public {
        vm.startBroadcast(privateKey);
        chainIds.push(CHAINID_2);
        targetContracts.push(address(forwarder));
        amounts.push(2 ether);
        multicaller.multicallForwarders(chainIds, targetContracts, amounts);
        vm.stopBroadcast();
    }

    function buyCoffee() public {
        vm.startBroadcast(privateKey);
        (bool success,) = payable(SUPERCHAIN_WETH_TOKEN).call{value: 3 ether}("");
        require(success, "Transfer failed!");

        ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).approve(address(coffeeShop), 5 ether);

        coffeeShop.buyCoffee();
        vm.stopBroadcast();
    }

    function run() public {
        privateKey = vm.envUint("ANVIL_ACCOUNT1_PRIVATE_KEY");

        forwarderInt = new ForwarderInteractions();

        // (coffeeShop, forwarder, multicaller) = forwarderInt.run();
        coffeeShop = CoffeeShop(0x5FbDB2315678afecb367f032d93F642f64180aa3);
        forwarder = Forwarder(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);
        multicaller = Multicaller(0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0);

        console.log(
            "weth balance before: ", ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).balanceOf(address(vm.addr(privateKey)))
        );

        multicallForwarders();
        console.log(
            "weth balance after: ", ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).balanceOf(address(vm.addr(privateKey)))
        );

        vm.warp(200);
        buyCoffee();

        console.log("coffee balance: ", coffeeShop.balanceOf(vm.addr(privateKey)));
    }
}
