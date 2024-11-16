// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {ISuperchainTokenBridge} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainTokenBridge.sol";
import {ISuperchainWETH} from "optimism/packages/contracts-bedrock/src/L2/interfaces/ISuperchainWETH.sol";

/**
 * @notice this contract receives a call from the base chain and calls the SuperchainTokenBridge's sendERC20()
 * @dev needs to be authorized by the sender to send their ERC20
 * @dev Future upgrade -> easier to implement as a smart account. No need for spending approval.
 */
contract Forwarder {
    address public constant SUPERCHAIN_TOKEN_BRIDGE = 0x4200000000000000000000000000000000000028;
    address public constant CROSS_DOMAIN_MESSENGER = 0x4200000000000000000000000000000000000023;
    address payable public constant SUPERCHAIN_WETH_TOKEN = payable(0x4200000000000000000000000000000000000024);

    error InvalidCaller();

    function forwardSend(address _sender, address _token, uint256 _amount, uint256 _chainId) public {
        if (msg.sender != CROSS_DOMAIN_MESSENGER) {
            revert InvalidCaller();
        }
        ISuperchainTokenBridge(SUPERCHAIN_TOKEN_BRIDGE).sendERC20(_token, _sender, _amount, _chainId);
    }
}
