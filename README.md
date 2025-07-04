# CFM-v1 Configuration Scripts

This project contains configuration files and instructions for using the CFM-v1 (Conditional Finance Markets) scripts to split collateral tokens into conditional outcome tokens and wrap them as ERC20 tokens.

## Configuration Files

The project includes several pre-configured JSON files for different DeFi protocols:

- `split-wrap-compound-finance.json` - Configuration for Compound Finance outcomes
- `split-wrap-euler.json` - Configuration for Euler outcomes  
- `split-wrap-morpho.json` - Configuration for Morpho outcomes
- `split-wrap-venus.json` - Configuration for Venus outcomes

### Adjusting Configuration

**Important**: Before running any scripts, you should adjust the `amount` field in the JSON configuration files to match your desired collateral amount. The default amount is `1000000` (1 USDC assuming 6 decimals), but you can modify this based on your needs.

Example configuration structure:
```json
{
  "collateralToken": "0x078d782b760474a361dda0af3839290b0ef57ad6",
  "amount": 1000000,
  "conditionId": "0x...",
  "conditionalTokens": "0xc8E244eB32200e6274E7737238AFa60eC6cf2511",
  "wrapped1155Factory": "0x87bc2f26df5d72b3e45b298127e702ba7ed459ea",
  "outcomeNames": ["Protocol Name", "NOT Protocol Name"]
}
```

## Using the Makefile

This project includes a Makefile for easier script execution:

### Install Dependencies
```bash
make install
```

### Split and Wrap Tokens
```bash
# Basic usage
make split filepath=split-wrap-morpho.json -- --private-key $PRIVATE_KEY

# With verbose output
make split filepath=split-wrap-morpho.json -- --private-key $PRIVATE_KEY -vvvv

# Using a hardware wallet
make split filepath=split-wrap-morpho.json -- --ledger
```

### Unwrap and Merge Tokens
```bash
# Basic usage
make merge filepath=split-wrap-morpho.json -- --private-key $PRIVATE_KEY

# With verbose output
make merge filepath=split-wrap-morpho.json -- --private-key $PRIVATE_KEY -vvvv
```

### Check Status
```bash
# Check split status
make split-check filepath=split-wrap-morpho.json

# Check merge status
make merge-check filepath=split-wrap-morpho.json

# Check for a specific user
make split-check filepath=split-wrap-morpho.json -- USER=0x...
```

You can pass any additional forge script arguments after `--` such as:
- `--private-key $PRIVATE_KEY` - Use a private key
- `--ledger` - Use a Ledger hardware wallet
- `--trezor` - Use a Trezor hardware wallet
- `-vvvv` - Verbose output for debugging
- `--slow` - Slow down execution
- `--gas-price <price>` - Set custom gas price
- `USER=0x...` - Check status for a specific user address

## Running Scripts Directly

### SplitAndWrap Script

The SplitAndWrap script splits your collateral tokens into conditional outcome positions and wraps them as tradeable ERC20 tokens.

**Usage Examples:**
```bash
# For Compound Finance
make split filepath=split-wrap-compound-finance.json -- --private-key $PRIVATE_KEY -vvvv

# For Euler
make split filepath=split-wrap-euler.json -- --private-key $PRIVATE_KEY -vvvv

# For Venus
make split filepath=split-wrap-venus.json -- --private-key $PRIVATE_KEY -vvvv
```

**Check Status:**
```bash
make split-check filepath=split-wrap-morpho.json
```

### UnwrapAndMerge Script

The UnwrapAndMerge script does the exact opposite of SplitAndWrap - it unwraps your ERC20 conditional tokens back to ERC1155 tokens and merges them back into the original collateral.

**Important**: This only works if you still hold all the ERC20 tokens that were created during the split and wrap process, and they haven't been transferred elsewhere.

**Basic Usage:**
```bash
make merge filepath=split-wrap-morpho.json -- --private-key $PRIVATE_KEY -vvvv
```

**Check Status:**
```bash
make merge-check filepath=split-wrap-morpho.json
```

## What These Scripts Do

### SplitAndWrap Process:
1. **Approve**: Allows ConditionalTokens contract to spend your collateral
2. **Split**: Divides your collateral into conditional outcome positions (ERC1155 tokens)
3. **Wrap**: Converts each ERC1155 position token into a tradeable ERC20 token
4. **Result**: You receive ERC20 tokens representing each outcome (e.g., "IF-Morpho" and "IF-NOT Morpho")

### UnwrapAndMerge Process:
1. **Unwrap**: Converts your ERC20 conditional tokens back to ERC1155 tokens
2. **Merge**: Combines all ERC1155 position tokens back into the original collateral
3. **Result**: You get your original collateral tokens back

## Prerequisites

- Sufficient collateral token balance (adjust `amount` in config files)
- Set environment variables: `$RPC_URL` and `$PRIVATE_KEY`
- Ensure you have the required approvals and balances

## Environment Variables

Make sure to set these environment variables before running:

```bash
export RPC_URL="https://your-rpc-endpoint"
export PRIVATE_KEY="your-private-key"
```

## Notes

- The scripts use a "full discrete partition" which includes an "invalid outcome" token
- Only the named outcomes are wrapped into ERC20 tokens (invalid outcome remains as ERC1155)
- For UnwrapAndMerge to work, you need ALL the tokens from the original split (including the invalid outcome)
- Always test with small amounts first
- Check balances and approvals using the "Check" variants of the scripts before executing
