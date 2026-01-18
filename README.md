# StacksLend: Decentralized Credit Protocol for Bitcoin DeFi

A merit-based lending protocol built on Stacks Layer 2 that bridges traditional credit systems with Bitcoin DeFi, enabling users to access credit based on their on-chain behavior and reputation.

## Overview

StacksLend introduces a novel approach to decentralized lending by implementing dynamic credit scoring that adjusts collateral requirements and interest rates based on user creditworthiness. Unlike traditional DeFi protocols that require full collateralization, StacksLend reduces collateral requirements for users with proven track records.

## Key Features

### Dynamic Credit Scoring

- **Merit-based system**: Credit scores range from 50-100 based on on-chain behavior
- **Minimum lending score**: Users need a score of 70+ to access loans
- **Score progression**: Successful repayments increase scores (+2), defaults decrease scores (-10)
- **Transparent history**: All loan and repayment history is recorded on-chain

### Risk-Adjusted Parameters

- **Variable collateral**: 50-100% based on credit score (higher scores = lower collateral)
- **Dynamic interest rates**: 5-10% based on creditworthiness
- **Flexible loan terms**: Up to 1 year duration (52,560 blocks)
- **Multiple loans**: Up to 5 active loans per user

### Security Features

- **Collateral protection**: All collateral locked in smart contract
- **Automatic enforcement**: System-managed defaults and score adjustments
- **Owner controls**: Administrative functions for default management
- **Transparent operations**: All transactions and scores publicly auditable

## Protocol Mechanics

### Credit Score Calculation

Users start with a minimum score of 50 and must achieve 70+ to access loans. Scores improve through:

- Successful loan repayments (+2 points each)
- Timely payment history
- Lower default rates

### Collateral Requirements

The protocol calculates required collateral using the formula:

```
Required Collateral = Loan Amount × (100 - (Credit Score × 0.5)) / 100
```

**Examples:**

- Score 70: 65% collateral required
- Score 80: 60% collateral required  
- Score 90: 55% collateral required
- Score 100: 50% collateral required

### Interest Rate Structure

Interest rates decrease with higher credit scores:

```
Interest Rate = 10% - (Credit Score × 0.05)
```

**Rate Examples:**

- Score 70: 6.5% APR
- Score 80: 6.0% APR
- Score 90: 5.5% APR
- Score 100: 5.0% APR

## Smart Contract Functions

### User Functions

#### `initialize-score()`

Initialize a new user's credit profile with minimum score of 50.

#### `request-loan(amount, collateral, duration)`

Request a new loan with specified parameters. Requires:

- Credit score ≥ 70
- Sufficient collateral based on score
- Maximum 5 active loans
- Duration ≤ 52,560 blocks (~1 year)

#### `repay-loan(loan-id, amount)`

Make partial or full loan repayments. Full repayment triggers:

- Credit score increase
- Collateral return
- Loan closure

### Read-Only Functions

#### `get-user-score(user)`

Retrieve user's credit score and loan history.

#### `get-loan(loan-id)`

Get detailed information about a specific loan.

#### `get-user-active-loans(user)`

List all active loans for a user.

### Admin Functions

#### `mark-loan-defaulted(loan-id)`

Mark overdue loans as defaulted (owner only). Triggers:

- Credit score reduction
- Loan deactivation
- Collateral forfeiture

## Usage Example

```clarity
;; 1. Initialize credit score
(contract-call? .stackslend initialize-score)

;; 2. Build credit history (start with higher collateral)
(contract-call? .stackslend request-loan u1000 u650 u5256) ;; 10 STX loan, 6.5 STX collateral

;; 3. Repay loan to improve score
(contract-call? .stackslend repay-loan u1 u1065) ;; Repay with interest

;; 4. Access better terms with improved score
(contract-call? .stackslend request-loan u2000 u1200 u10512) ;; Better collateral ratio
```

## Error Codes

| Code | Error | Description |
|------|-------|-------------|
| u1 | ERR-UNAUTHORIZED | Insufficient permissions |
| u2 | ERR-INSUFFICIENT-BALANCE | Insufficient collateral |
| u3 | ERR-INVALID-AMOUNT | Invalid loan amount |
| u4 | ERR-LOAN-NOT-FOUND | Loan does not exist |
| u5 | ERR-LOAN-DEFAULTED | Loan already defaulted |
| u6 | ERR-INSUFFICIENT-SCORE | Credit score too low |
| u7 | ERR-ACTIVE-LOAN | Too many active loans |
| u8 | ERR-NOT-DUE | Loan not yet due |
| u9 | ERR-INVALID-DURATION | Invalid loan duration |
| u10 | ERR-INVALID-LOAN-ID | Invalid loan identifier |

## Technical Specifications

- **Platform**: Stacks Layer 2 (Bitcoin)
- **Language**: Clarity Smart Contract
- **Block Time**: ~10 minutes (Bitcoin blocks)
- **Maximum Loan Duration**: 52,560 blocks (~1 year)
- **Supported Asset**: STX (Stacks tokens)
- **Credit Score Range**: 50-100
- **Interest Rate Range**: 5-10% APR
- **Collateral Range**: 50-100% of loan value

## Security Considerations

- All collateral is locked in the smart contract until loan repayment
- Credit scores are automatically updated based on repayment behavior
- Default detection is managed by contract owner with transparent criteria
- No external price oracles required - reduces attack vectors
- Immutable loan terms prevent manipulation after creation

## Getting Started

1. **Deploy Contract**: Deploy the StacksLend contract to Stacks testnet/mainnet
2. **Initialize Profile**: Call `initialize-score()` to create your credit profile
3. **Build Credit**: Start with smaller loans and higher collateral to build reputation
4. **Access Better Terms**: Improved scores unlock lower collateral and interest rates
5. **Maintain Score**: Consistent repayment behavior maintains and improves creditworthiness

## License

This project is open source and available under standard DeFi protocol terms.

## Contributing

Contributions are welcome! Please ensure all changes maintain the security and integrity of the credit scoring system.

---

*StacksLend: Building credit reputation on Bitcoin's most secure layer.*
