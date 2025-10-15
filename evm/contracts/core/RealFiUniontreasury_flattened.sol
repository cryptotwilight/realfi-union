
// File: realfi-union/evm/contracts/structs/RFUStructs.sol


pragma solidity ^0.8.30;

enum Decision {PENDING, WITHDRAWN, APPROVED, REJECTED}

enum Term {DAY, WEEK, MONTH, YEAR}

struct ProtoLoanRequest { 
    address borrower; 
    uint256 amount;
    Term term;
    Period paymentPeriod;   
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
    uint256 contributedFunds;  
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
    uint256 votes; 
    uint256 created;
    bool isActive; 
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
    uint256 collateralBalance; 
    uint256 collateralFunds; 
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
enum EVENT_TYPE {DEPOSIT, WITHDRAW, BORROW_REQUEST, BORROW_VOTE, BORROW_VOTE_CANCEL, BORROW_CANCEL, BORROW_REJECTED, BORROW_APPROVED, LEND, BORROW,  REPAY, PAYOUT}

event RFU_EVENT(EVENT_TYPE _type, address _instigator, uint256 _totalAmount, uint256 _entityId, uint256 _date); 

struct Tx {
    uint256 id; 
    uint256 savingsId; 
    string txType;
    uint256 amount; 
    address instigator;
    uint256 date;
}
// File: realfi-union/evm/contracts/interfaces/IRealFiUnionTreasury.sol


pragma solidity ^0.8.30;


interface IRealFiUnionTreasury { 

    function getTreasuryBalance() view external returns (FullTreasuryBalance memory _fullTreasuryBalance);

    function deposit(uint256 _savingsId, uint256 _amount) payable external returns (uint256 _treasuryBalance); 

    function withdraw(uint256 _savingsId, uint256 _amount) external returns (uint256 _treasuryBalance); 

    function lend(uint256 _savingsId, uint256 _loanId, uint256 _amount, uint256 _totalInterest) external returns (uint256 _treasuryBalance); 

    function repay(uint256 _savingsId, uint256 _loanId, uint256 _amount, uint256 _interest) external payable returns (uint256 _treasuryBalance); 

    function retrievePaidInterest(uint256 _savingsId, uint256 _loanId) external returns (uint256 _paidInterest); 

    function payInterest(uint256 _savingsId, uint256 _amount) external returns (uint256 _savingsBalance); 

}


// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/IERC20.sol)

pragma solidity >=0.4.16;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts (last updated v5.4.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity >=0.6.2;


/**
 * @dev Interface for the optional metadata functions from the ERC-20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: realfi-union/evm/contracts/core/RealFiUniontreasury.sol


pragma solidity ^0.8.30;





contract RealFiUnionTreasury is IRealFiUnionTreasury { 

    modifier safeOnly () { 
        require(msg.sender == safeAddress, "safe address only"); 
        _; 
    }

    modifier refiUnionOnly () {
        require(msg.sender == realFiUnionAddress, "realFiUnion only");
        _;
    }

    IERC20 erc20; 
    address immutable self;  

    address safeAddress; 
    address realFiUnionAddress; 
    mapping(uint256=>uint256) savingsBalanceBySavingsId;  

    mapping(uint256=>mapping(uint256=>LoanTreasury)) loanTreasuryByLoanIdBySavingsId; 

    uint256 totalLoanBalance;       // total outstanding loans balance 
    uint256 totalSavingsBalance;    // total savings from all members less withdrawals 
    uint256 interestBalance;        // interest balance is the balance of interest currently held by the treasury it fluctuates
    uint256 treasuryBalance;        // treasury balance is the balance of the treasury i.e. saving plus interest 
    uint256 availableBalance;       // available balance is the amount of funds available for savings withdrawals and loan issues 

    uint256 lifeTimeDeposits; 
    uint256 lifeTimeWithdrawals;

    constructor(address _safeAddress, address _token) { 
        safeAddress = _safeAddress; 
        erc20 = IERC20(_token); 
        self = address(this);
    }

    function getToken() view external returns (address _token) {
        return address(erc20);
    }

    function getRealFiUnion() view external returns (address _realFiUnion) {
        return realFiUnionAddress; 
    }

    function getTreasuryBalance() view external returns (FullTreasuryBalance memory _fullTreasuryBalance){
        return FullTreasuryBalance ({
                                        date : block.timestamp, 
                                        totalBalance : treasuryBalance, 
                                        currentBalance : erc20.balanceOf(self),
                                        totalLending : totalLoanBalance, 
                                        totalSavings : totalSavingsBalance, 
                                        lifeTimeDeposits : lifeTimeDeposits,
                                        lifeTimeWithdrawals : lifeTimeWithdrawals
                                    });
    }

    function deposit(uint256 _savingsId, uint256 _amount) payable refiUnionOnly external returns (uint256 _treasuryBalance){
        erc20.transferFrom(msg.sender,self, _amount);
        savingsBalanceBySavingsId[_savingsId] += _amount;
        totalSavingsBalance += _amount;
        availableBalance += _amount; 
         
        lifeTimeDeposits += _amount; 

        _treasuryBalance =  totalSavingsBalance + interestBalance; 
        return _treasuryBalance; 
    }

    function withdraw(uint256 _savingsId, uint256 _amount) external refiUnionOnly returns (uint256 _treasuryBalance){
        require( savingsBalanceBySavingsId[_savingsId] >= _amount, "insufficient savings treasury balance");
        require(availableBalance >= _amount, "insufficient available balance"); 

        savingsBalanceBySavingsId[_savingsId] -= _amount;
        availableBalance -= _amount;   
        erc20.approve(realFiUnionAddress, _amount);
         
        lifeTimeWithdrawals += _amount; 
         
        _treasuryBalance =  totalSavingsBalance + interestBalance; 
        return _treasuryBalance; 
    }

    function payInterest(uint256 _savingsId, uint256 _amount) external refiUnionOnly returns (uint256 _savingsBalance){
        savingsBalanceBySavingsId[_savingsId] += _amount; 
        totalSavingsBalance                   += _amount; 
        _savingsBalance = savingsBalanceBySavingsId[_savingsId]; 
        return _savingsBalance; 
    }

    function withdrawInterest(uint256 _savingsId, uint256 _loanId) external refiUnionOnly returns (uint256 _interestPaid){
        _interestPaid = loanTreasuryByLoanIdBySavingsId[_savingsId][_loanId].interestAvailable;
        loanTreasuryByLoanIdBySavingsId[_savingsId][_loanId].interestAvailable = 0;
        erc20.approve(realFiUnionAddress, _interestPaid);
        interestBalance -= _interestPaid;

        return _interestPaid; 
    }

    function lend(uint256 _savingsId, uint256 _loanId, uint256 _amount, uint256 _totalInterest) external refiUnionOnly returns (uint256 _treasuryBalance){
        require(!loanTreasuryByLoanIdBySavingsId[_savingsId][_loanId].isIssued, "loan already issued");
        require(availableBalance >= _amount, "insufficient available balance");
        loanTreasuryByLoanIdBySavingsId[_savingsId][_loanId] = LoanTreasury({
                                                                                loanId : _loanId, 
                                                                                isIssued : true, 
                                                                                loanOutstanding : _amount, 
                                                                                interestOutstanding : _totalInterest,
                                                                                interestAvailable : 0 
                                                                            });
        availableBalance -= _amount;
        erc20.approve(realFiUnionAddress, _amount);
        
        totalLoanBalance += _amount;
        _treasuryBalance =  totalSavingsBalance + interestBalance; 
        return _treasuryBalance; 
    } 

    function repay(uint256 _savingsId, uint256 _loanId, uint256 _amount, uint256 _interest) external refiUnionOnly payable returns (uint256 _treasuryBalance){
        require(loanTreasuryByLoanIdBySavingsId[_savingsId][_loanId].isIssued, "loan not issued");
        erc20.transferFrom(realFiUnionAddress, address(this), _amount + _interest);
        interestBalance += _interest;
        availableBalance += _amount;

        loanTreasuryByLoanIdBySavingsId[_savingsId][_loanId].loanOutstanding -= _amount; 
        loanTreasuryByLoanIdBySavingsId[_savingsId][_loanId].interestOutstanding -= _interest; 
        loanTreasuryByLoanIdBySavingsId[_savingsId][_loanId].interestAvailable += _interest;

        _treasuryBalance =  totalSavingsBalance + interestBalance; 
        return _treasuryBalance; 
    }

    function retrievePaidInterest(uint256 _savingsId, uint256 _loanid) external refiUnionOnly returns (uint256 _paidInterest){
        _paidInterest = loanTreasuryByLoanIdBySavingsId[_savingsId][_loanid].interestAvailable;
        loanTreasuryByLoanIdBySavingsId[_savingsId][_loanid].interestAvailable -= _paidInterest; 
        return _paidInterest; 
    }   


    function migrateSafeAddress(address _safeAddress) external safeOnly returns (bool _success) {
        safeAddress = _safeAddress; 
        return true; 
    }

    function setRealFiUnionAddress(address _realFiUnionAddress)  external safeOnly returns (bool _success) {
        realFiUnionAddress = _realFiUnionAddress;
        return true; 
    }

    function setToken(address _token) external safeOnly returns (bool _success) {
        erc20 = IERC20(_token);
        return true;
    }
}