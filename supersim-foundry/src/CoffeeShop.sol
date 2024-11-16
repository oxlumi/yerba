// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ISuperchainWETH} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainWETH.sol";

contract CoffeeShop is ERC721 {
    uint256 public coffeeId;

    address payable public wethToken;
    uint256 immutable coffeePrice = 0.01 ether;

    event CoffeeBought(address buyer, uint256 coffeId);

    constructor(address payable _wethToken) ERC721("YERBA", "YRB") {
        coffeeId = 0;
        wethToken = _wethToken;
    }

    function buyCoffee() public {
        ISuperchainWETH(wethToken).transferFrom(msg.sender, address(this), coffeePrice);
        coffeeId++;
        _mint(msg.sender, coffeeId);
        emit CoffeeBought(msg.sender, coffeeId);
    }
}
