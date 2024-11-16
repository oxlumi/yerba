// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IL2ToL2CrossDomainMessenger} from
    "optimism/packages/contracts-bedrock/src/L2/interfaces/IL2ToL2CrossDomainMessenger.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev multicalls all forwarders for funds
 * @dev the balances fetching must be done off-chain for now.
 * @dev Future upgrade -> this should be a smart account and receive the tokens back after the cross-chain calls.
 * instead, the msg.sender is sent to the forwarder to fill the _to param in sendERC20.
 */
contract Multicaller is Ownable {
    address public messenger;
    address public superWeth;
    address public superTokenBridge;

    event MessageSent(address target, uint256 amount, uint256 chainId);
    event PaymentReceived(address from, uint256 amount);

    constructor(address _messenger, address _superWeth, address _superTokenBridge) Ownable(msg.sender) {
        messenger = _messenger;
        superWeth = _superWeth;
        superTokenBridge = _superTokenBridge;
    }

    function multicallForwarders(
        uint256[] calldata chainIds,
        address[] calldata targetContracts,
        uint256[] calldata amounts
    ) external {
        require(
            targetContracts.length == amounts.length && amounts.length == chainIds.length,
            "Input arrays must have the same length"
        );

        for (uint256 i = 0; i < targetContracts.length; i++) {
            bytes memory sendMessage = abi.encodeWithSignature(
                "forwardSend(address,address,uint256,uint256)", msg.sender, superWeth, amounts[i], block.chainid
            );

            IL2ToL2CrossDomainMessenger(messenger).sendMessage(chainIds[i], targetContracts[i], sendMessage);

            emit MessageSent(targetContracts[i], amounts[i], chainIds[i]);
        }
    }
}
