// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.25;

import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/Console.sol";
import {ISuperchainTokenBridge} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainTokenBridge.sol";
import {ISuperchainWETH} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainWETH.sol";
import {Deploy} from "./Deploy.s.sol";
import {CoffeeShop} from "../src/CoffeeShop.sol";
import {Multicaller} from "../src/Multicaller.sol";
import {Forwarder} from "../src/Forwarder.sol";

contract ForwarderInteractions is Script {
    address public constant SUPERCHAIN_TOKEN_BRIDGE = 0x4200000000000000000000000000000000000028;
    address payable public constant SUPERCHAIN_WETH_TOKEN = payable(0x4200000000000000000000000000000000000024);
    uint256 private privateKey;
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    Deploy public deploy;
    CoffeeShop private coffeeShop;
    Forwarder private forwarder;
    Multicaller private multicaller;

    function approveForwarder() public {
        vm.startBroadcast(privateKey);
        (bool success,) = payable(SUPERCHAIN_WETH_TOKEN).call{value: 2 ether}("");
        require(success, "Transfer failed!");

        ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).approve(address(forwarder), 2 ether);
        // console.log(
        //     "CHAIN 2: allowance ",
        //     ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).allowance(vm.addr(privateKey), address(forwarder))
        // );
        // forwarder.transferFromUser(vm.addr(privateKey), 1 ether);
        // ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).transfer(address(forwarder), 1 ether);

        vm.stopBroadcast();
    }

    function run() public returns (CoffeeShop, Forwarder, Multicaller) {
        privateKey = vm.envUint("ANVIL_ACCOUNT1_PRIVATE_KEY");

        deploy = new Deploy();

        // (coffeeShop, forwarder, multicaller) = deploy.run();
        forwarder = Forwarder(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);

        approveForwarder();

        console.log("CHAIN 2: weth balance ", ISuperchainWETH(SUPERCHAIN_WETH_TOKEN).balanceOf(vm.addr(privateKey)));

        return (coffeeShop, forwarder, multicaller);
    }
}
