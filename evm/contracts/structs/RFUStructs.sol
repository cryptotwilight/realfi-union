// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

enum Decision {PENDING, WITHDRAWN, APPROVED, REJECTED}

enum Term {DAY, WEEK, MONTH, YEAR}

struct ProtoLoanRequest { 
    address borrower; 
    uint256 amount;
    Term term;  
    uint256 rateId;  
    uint256 savingsId; 
}

struct LoanRequest { 
    uint256 id; 
    uint256 savingsId;
    address borrower;
    uint256 amount;
    uint256 interest;
    Term    term; 
    Period  paymentPeriod; 
    uint256 created; 
    uint256 expiryDate; 
    uint256 voteThresholdId; 
    uint256 decisionDate;
    Decision decision; 
}

enum LoanStatus {ISSUED, DRAWNDOWN, FROZEN, DEFAULTED, CANCELLED, CLOSED}

enum Period {DAILY, WEEKLY, MONTHLY, YEARLY}

struct Loan { 
    uint256 id; 
    uint256 savingsId; 
    uint256 loanRequestId; 
    address borrower; 
    uint256 amount; 
    uint256 interest; 
    Period paymentPeriod;  
    uint256 lastPaymentDate; 
    uint256 completionDueDate; 
    uint256 created;
    uint256 closedDate; 
    LoanStatus status; 
}

struct LoanStake {
    uint256 id; 
    uint256 loanRequestId; 
    address holder; 
    uint256 amount; 
    uint256 created;
}

enum RateType {SAVINGS_INTEREST, LOAN_INTEREST}

struct Rate { 
    uint256 id; 
    Range amount; 
    uint256 interest; 
    RateType rateType;
    uint256 setDate; 
    uint256 expiryDate; 
}

struct Savings { 
    uint256 id;
    uint256 balance;
    uint256 availableBalance; 
    uint256 votes;
    address owner; 
    bool isActive; 
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

struct LoanTreasury { 
    uint256 loanId; 
    bool isIssued; 
    uint256 loanOutstanding; 
    uint256 interestOutstanding; 
    uint256 interestAvailable; 
}
enum EVENT_TYPE {DEPOSIT, WITHDRAW, BORROW_REQUEST, BORROW_CANCEL, LEND, BORROW,  REPAY, PAYOUT}

event RFU_EVENT(EVENT_TYPE _type, address _instigator, uint256 _totalAmount, uint256 _entityId, uint256 _date); 

struct Tx {
    uint256 id; 
    uint256 savingsId; 
    string txType;
    uint256 amount; 
    address instigator;
    uint256 date;
}