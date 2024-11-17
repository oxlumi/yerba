# How to run supersim-foundry:

### Step 1: Install Supersim

- Option1: Homebrew (OS X, Linux):
  `brew install ethereum-optimism/tap/supersim`
- Option2: Precompiled Binaries:
  Download the executable for your platform from the Supersim GitHub releases page.

### Step 2: Configure your `.env` file:

```
OP1_RPC=http://127.0.0.1:9545
OP2_RPC=http://127.0.0.1:9546
ANVIL_ACCOUNT1_PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

### Step 3: Run supersim with autorelay:

supersim --interop.autorelay

### Step 4: deploy contracts on chain OP1:

`forge script script/Deploy.s.sol --broadcast --rpc-url ${OP1_RPC}`

### Step 5: approve forwarder on chain OP2:

`forge script script/ForwarderInteractions.s.sol --broadcast --rpc-url ${OP2_RPC}`

### Step 6: buy a coffee:

`forge script script/CoffeeInteractions.s.sol --broadcast --rpc-url ${OP1_RPC}`
