// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

enum Decision {OPEN, WITHDRAWN, APPROVED, REJECTED}

struct LoanRequest { 
    uint256 id; 
    uint256 amount;
    uint256 interest;
    uint256 term; 
    uint256 savingsId;
    address borrower;
    uint256 created; 
    uint256 expiryDate; 
    uint256 decisionDate;
    uint256 voteThresholdId; 
    Decision decision; 
}

enum LoanStatus {OPEN, FROZEN, DEFAULTED, CLOSED}

struct Loan { 
    uint256 id; 
    uint256 loanRequestId; 
    uint256 amount; 
    uint256 interest; 
    uint256 maturity; 
    uint256 savingsId; 
    address borrower; 
    address loanVault; 
    uint256 created;
    uint256 closedDate; 
    LoanStatus status; 
}

enum RateType {SAVINGS, LOAN}

struct Rate { 
    string name; 
    uint256 amount; 
    RateType rateType;
    uint256 setDate; 
    uint256 expiryDate; 
}

struct Savings { 
    uint256 id;
    uint256 balance;
    uint256 votes;
    uint256 lastUpdated;  
}

struct Range { 
    uint256 min; 
    uint256 max; 
}

struct VoteThreshold {
    uint256 id; 
    Range loanAmount; 
    uint256 minimumVotes; 
}

struct FullTreasuryBalance { 
    uint256 date; 
    uint256 totalBalance; 
    uint256 currentBalance; 
    uint256 totalLending; 
    uint256 totalSavings; 
    uint256 lifeTimeDeposits;
    uint256 lifeTimeWithdrawals;
}