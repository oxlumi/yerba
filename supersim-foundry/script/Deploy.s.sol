// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {CoffeeShop} from "../src/CoffeeShop.sol";
import {Forwarder} from "../src/Forwarder.sol";
import {Multicaller} from "../src/Multicaller.sol";

contract Deploy is Script {
    address deployer;
    CoffeeShop internal coffeeShop;

    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    address payable public constant SUPERCHAIN_WETH_TOKEN = payable(0x4200000000000000000000000000000000000024);
    address public constant SUPERCHAIN_TOKEN_BRIDGE = 0x4200000000000000000000000000000000000028;
    address public constant CROSS_DOMAIN_MESSENGER = 0x4200000000000000000000000000000000000023;

    function run() external returns (CoffeeShop) {
        vm.startBroadcast(DEFAULT_ANVIL_PRIVATE_KEY);

        deployer = vm.addr(DEFAULT_ANVIL_PRIVATE_KEY);

        // deploy coffe shop
        coffeeShop = new CoffeeShop(SUPERCHAIN_WETH_TOKEN);

        // deploy forwarder
        forwarder = new Forwarder();

        // deploy multicaller
        multicaller = new Multicaller();

        vm.stopBroadcast();

        return (coffeeShop);
    }
}
