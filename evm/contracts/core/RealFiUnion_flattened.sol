
// SPDX-License-Identifier: APACHE 2.0
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
// File: realfi-union/evm/contracts/interfaces/IRealFiUnion.sol


pragma solidity ^0.8.30;


interface IRealFiUnion { 

    // union token USDC, USDT, DAI etc
    function getUnionToken() view external returns (address _token);

    // union rates 
    function getRates() view external returns (Rate [] memory _rates); 

    // union fees 
    function getFeeNames() view external returns (string[] memory _feeNames);

    function getFee(string memory _feeName) view external returns (uint256 _fee);



    // manage your savings
    function getSavingsId() view external returns (uint256 _savingsId); 

    function getSavings(uint256 _savingsId) view external returns (Savings memory _savings); 

    function deposit(uint256 _savingsId, uint256 _amount) payable external returns (uint256 _depositId); 

    function withdraw(uint256 _savingsId, uint256 _amount) external returns (uint256 _withdrawId); 

    function getTxIdsBySavingsId(uint256 _savingsId) view external returns (uint256[] memory _txIds); 


    // manage your loan request
    function getLoanRequestIds() view external returns (uint256[] memory); 

    function getLoanRequest(uint256 _loanRequestId) view external returns (LoanRequest memory _pLoanRequest); 

    function isApproved(uint256 _loanRequestId) view external returns (bool _isApproved);

    function requestLoan(ProtoLoanRequest memory _pLoanRequest) payable external returns (uint256 _loanRequestId); 

    function withdrawLoanRequest(uint256 _loanRequestId)  external returns (bool _cancelled);


    // manage your loan
    function getLoanId(uint256 _loanRequestId) view external returns (uint256 _loanId);

    function getLoanStakeIds() view external returns (uint256 [] memory _loanStakeIds);

    function getLoanStakeById(uint256 _loanStakeId) view external returns (LoanStake memory _loanStake);

    function getLoan(uint256 _loanId) view external returns (Loan memory _loan); 

    function cancellLoan(uint256 _loanid) external returns (bool _success); 

    function drawDownLoan(uint256 _loanId) external returns (uint256 _loanAmount); 

    function repayLoan(uint256 _loanId, uint256 _amount) payable external returns (uint256 _loanBalance); 


    // vote on a loan request
    function getVoteThresholdIds() view external returns (uint256[] memory _thresholdIds); 

    function getVoteThreshold(uint256 thresholdId) view external returns (VoteThreshold memory _voteThreshold);

    function voteForLoanApproval(uint256 _loanRequestId, uint256 _votes) payable external returns (bool _success);

    function recindVoteForLoanApproval(uint256 _loanRequestId) payable external returns (bool _success); 


    // join the union
    function joinUnion(uint256 _initialDeposit) payable external returns (uint256 _savingsId); 

    function leaveUnion() external returns (uint256 _finalBalance); 
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


// File: realfi-union/evm/contracts/lib/RFULib.sol


pragma solidity ^0.8.30;


library RFULib { 

    function resolveTerm( Term _term) internal pure returns (uint256 _timeInSeconds) {
        if(_term == Term.DAY) {
            return 86400;
        }
        if(_term == Term.MONTH){
            return 2629800; // 30.44 days
        }
        if(_term == Term.WEEK) {
            return 86400 * 7; 
        }
        if(_term == Term.YEAR) {
            return 86400 * 365;
        }
        return 0; 
    }

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

// File: realfi-union/evm/contracts/core/RealFiUnion.sol


pragma solidity ^0.8.30;

contract RealFiUnion is IRealFiUnion {

    string constant MEMBER_FEE = "MEMBER_FEE"; 
    string constant LOAN_FEE = "LOAN_FEE";
    string constant LOAN_REQUEST_FEE = "LOAN_REQUEST_FEE";
    string constant VOTE_FEE = "VOTE_FEE";
    string constant RECIND_VOTE_FEE = "RECIND_VOTE_FEE";

    modifier safeOnly () { 
        require(msg.sender == safeAddress, "safe address only"); 
        _; 
    }

    modifier membersOnly () { 
        require(isMember[msg.sender], "members only");
        _; 
    }

    address immutable self; 

    IRealFiUnionTreasury treasury;
    IERC20Metadata erc20; 
    uint256 index; 
    uint256 voteMultiple = 1; 
    address safeAddress;
    uint256 loanRequestValidityPeriod = 3600 * 24 * 30;  

    string [] feeNames;
    mapping(string=>uint256) feeByName; 

    
    uint256[] savingsIds; 
    mapping(uint256=>Savings) savingsById; 
    mapping(address=>uint256) savingsIdByMemberAddress; 

    uint256 [] loanRequestIds;  
    mapping(uint256=>LoanRequest) loanRequestById;
    mapping(address=>uint256) loanRequestIdByMemberAddress; 
    mapping(address=>bool) hasLoanRequest;
    mapping(uint256=>uint256) loanIdByLoanRequestId;  

    mapping(address=>bool) hasLoan;
    mapping(uint256=>Loan) loanById; 
    mapping(address=>uint256) loanIdByMemberAddress;

    mapping(uint256=>uint256) voteTallyByLoanRequestId;

    mapping(uint256=>uint256[]) loanStakeIdsByLoanRequestId; 
    mapping(address=>uint256[]) loanStakeIdsByMemberAddress; 
    mapping(uint256=>LoanStake) loanStakeById; 
    mapping(address=>mapping(uint256=>uint256)) loanStakeIdByLoanRequestIdByMemberAddress;
    mapping(address=>mapping(uint256=>bool)) hasLoanStakeByLoanRequestByMemberAddress;

    uint256 [] voteThresholdIds;
    mapping(uint256=>VoteThreshold) voteThresholdById;

    // Real Fi Union Members 
    address [] members; 
    mapping(address=>bool) isMember;

    uint256 [] rateIds; 
    mapping(uint256 => bool) knownRateId; 
    mapping(uint256 => Rate) rateById; 

    uint256 [] txIds; 
    mapping(uint256=>uint256[]) txIdsBySavingsId; 
    mapping(uint256=>Tx) txById; 


    constructor (address _safeAddress, address _treasury, address _erc20) { 
        safeAddress = _safeAddress;
        treasury = IRealFiUnionTreasury(_treasury); 
        erc20 = IERC20Metadata(_erc20);
        self = address(this);
    }

    function getUnionToken() view external returns (address _token) { 
        return address(erc20); 
    }

    function getFeeNames() view external returns (string[] memory _feeNames){
        return feeNames; 
    }

    function getFee(string memory _feeName) view external returns (uint256 _fee){
        return feeByName[_feeName]; 
    }

    function getSavings(uint256 _savingsId) view external returns (Savings memory _savings){
        return savingsById[_savingsId]; 
    }

    function getLoan(uint256 _loanId) view external returns (Loan memory _loan){
        return loanById[_loanId]; 
    }

    function getTxIdsBySavingsId(uint256 _savingsId) view external returns (uint256[] memory _txIds) {
        return txIdsBySavingsId[_savingsId]; 
    }

    function getTx(uint256 _txId) view external returns (Tx memory _tx){
        return txById[_txId];
    }

    function getLoanStakeIds() view external returns (uint256 [] memory _loanStakeIds) {
        return loanStakeIdsByMemberAddress[msg.sender]; 
    }

    function getLoanStakeById(uint256 _loanStakeId) view external returns (LoanStake memory _loanStake) {
        return loanStakeById[_loanStakeId]; 
    }

    function getRates() view external returns (Rate [] memory _rates) {
        _rates = new Rate[](rateIds.length); 
        for(uint256 x = 0; x < rateIds.length; x++){
            _rates[x] = rateById[rateIds[x]];
        }
        return _rates;
    }

    // contribute to the union 
    function deposit(uint256 _savingsId, uint256 _amount) payable external returns (uint256 _txId) {
        require(savingsById[_savingsId].isActive, "inactive savings Id");
        erc20.transferFrom(msg.sender, self, _amount); 
        erc20.approve(address(treasury), _amount); 
        treasury.deposit(_savingsId, _amount);

        savingsById[_savingsId].balance += _amount; 
        savingsById[_savingsId].availableBalance += _amount;

        savingsById[_savingsId].votes += getVotes(_amount);
        savingsById[_savingsId].lastUpdated = block.timestamp; 

        emit RFU_EVENT(EVENT_TYPE.DEPOSIT, msg.sender,  _amount, _savingsId, block.timestamp); 
        _txId = index++;
        txById[_txId] = Tx ({
                                id : _txId,
                                savingsId : _savingsId,
                                txType  : "DEPOSIT",
                                amount : _amount,
                                instigator : msg.sender,
                                date : block.timestamp
                            }); 
        return _txId; 
    }

    // withdraw from the union
    function withdraw(uint256 _savingsId, uint256 _amount)  external returns (uint256 _txId) {
        require(savingsById[_savingsId].isActive, "inactive savings Id");
        require(savingsById[_savingsId].availableBalance >= _amount, "insufficient balance"); 
        savingsById[_savingsId].balance -= _amount;
        savingsById[_savingsId].availableBalance -= _amount;
        savingsById[_savingsId].votes -= getVotes(_amount);
        savingsById[_savingsId].lastUpdated = block.timestamp; 

        treasury.withdraw(_savingsId, _amount); 
        erc20.transfer(msg.sender, _amount);

        emit RFU_EVENT(EVENT_TYPE.WITHDRAW, msg.sender,  _amount, _savingsId, block.timestamp); 
        _txId = index++;
        txById[_txId] = Tx ({
                                id : _txId,
                                savingsId : _savingsId,
                                txType  : "WITHDRAW",
                                amount : _amount,
                                instigator : msg.sender,
                                date : block.timestamp
                            }); 
        return _txId; 
    } 

    // manage your loan request
    function getLoanRequestIds() view external returns (uint256[] memory) {
        return loanRequestIds; 
    }

    function getLoanRequest(uint256 _loanRequestId) view external returns (LoanRequest memory _loanRequest) {
        return loanRequestById[_loanRequestId]; 
    }

    function isApproved(uint256 _loanRequestId) view external returns (bool _isApproved) {
        return loanRequestById[_loanRequestId].decision == Decision.APPROVED;  
    }

    function requestLoan(ProtoLoanRequest memory _pLoanRequest) payable membersOnly external returns (uint256 _loanRequestId){
        require(msg.sender == _pLoanRequest.borrower, "requesting borrower only"); 
        require(!hasLoanRequest[msg.sender], "already has loan request "); 
        hasLoanRequest[msg.sender] = true; 
        require(savingsById[_pLoanRequest.savingsId].owner == msg.sender, "saving holder only"); 
        require(!hasLoan[msg.sender], "already has loan"); 
        require(savingsById[_pLoanRequest.savingsId].balance >= _pLoanRequest.amount, "insufficient for savings");

        Rate memory rate_ = rateById[_pLoanRequest.rateId]; 
        require(rate_.rateType == RateType.LOAN_INTEREST, "rate type mis-match"); 
        require(_pLoanRequest.amount >= rate_.amount.min && _pLoanRequest.amount <= rate_.amount.max, "requested loan rate <> amount mis-match"); 

        uint256 fullLoan_ = getRepaymentAmount(_pLoanRequest.savingsId,  rate_); 

        require(fullLoan_ <= savingsById[_pLoanRequest.savingsId].balance, "insufficient collateral for loan"); 

        // manage collateral 
        savingsById[_pLoanRequest.savingsId].balance -= fullLoan_;
        savingsById[_pLoanRequest.savingsId].collateralBalance += fullLoan_;

        if(savingsById[_pLoanRequest.savingsId].availableBalance >= fullLoan_){
            savingsById[_pLoanRequest.savingsId].availableBalance -= fullLoan_;
            savingsById[_pLoanRequest.savingsId].collateralFunds += fullLoan_;  
        }
        else {
            if(savingsById[_pLoanRequest.savingsId].availableBalance > 0){
                uint256 contributoryFunds_ = savingsById[_pLoanRequest.savingsId].availableBalance;
                savingsById[_pLoanRequest.savingsId].availableBalance -= contributoryFunds_; 
                savingsById[_pLoanRequest.savingsId].collateralFunds += contributoryFunds_;
            }
        }

        _loanRequestId = index++; 
        loanRequestById[_loanRequestId] = LoanRequest ({
                                                         id : _loanRequestId,  
                                                        amount : _pLoanRequest.amount,
                                                        interest : rate_.interest, 
                                                        term : _pLoanRequest.term,
                                                        paymentPeriod : _pLoanRequest.paymentPeriod,
                                                        savingsId : _pLoanRequest.savingsId,
                                                        borrower : _pLoanRequest.borrower,
                                                        created : block.timestamp,
                                                        voteThresholdId : getVoteThresholdId(_pLoanRequest.amount),
                                                        expiryDate : block.timestamp + loanRequestValidityPeriod,
                                                        contributedFunds : 0, 
                                                        decisionDate : block.timestamp, 
                                                        decision : Decision.PENDING
                                                      });
        emit RFU_EVENT(EVENT_TYPE.BORROW_REQUEST, msg.sender, _pLoanRequest.amount, _loanRequestId, block.timestamp); 
        return _loanRequestId; 
    } 

    function withdrawLoanRequest(uint256 _loanRequestId)  external membersOnly returns (bool _cancelled){
        require(msg.sender == loanRequestById[_loanRequestId].borrower, "borrower only"); 
        loanRequestById[_loanRequestId].decision = Decision.WITHDRAWN;
        loanRequestById[_loanRequestId].decisionDate = block.timestamp;  
        hasLoanRequest[msg.sender] = false; 
         emit RFU_EVENT(EVENT_TYPE.BORROW_CANCEL, msg.sender,  loanRequestById[_loanRequestId].amount, _loanRequestId, block.timestamp); 
         return true; 
    }


    // vote on a loan request
    function getVoteThresholdIds() view external returns (uint256[] memory _thresholdIds){
        return voteThresholdIds; 
    }   

    function getVoteThreshold(uint256 thresholdId) view external returns (VoteThreshold memory _voteThreshold){
        return voteThresholdById[thresholdId];
    }

    function voteForLoanApproval(uint256 _loanRequestId, uint256 _votes) payable membersOnly external returns (bool _success){
        LoanRequest memory loanRequest_ = loanRequestById[_loanRequestId];
        require(loanRequest_.decision == Decision.PENDING, "invalid loan request state");

        if(loanRequest_.expiryDate < block.timestamp){
            loanRequestById[_loanRequestId].decision = Decision.REJECTED;
            loanRequestById[_loanRequestId].decisionDate = block.timestamp; 
            releaseLoanStakes(_loanRequestId); 
            hasLoanRequest[loanRequest_.borrower] = false;
            emit RFU_EVENT(EVENT_TYPE.BORROW_REJECTED, msg.sender,  loanRequestById[_loanRequestId].amount, _loanRequestId, block.timestamp);
            return false; 
        }
        require(_votes <= savingsById[savingsIdByMemberAddress[msg.sender]].votes, "insufficient votes held");
        
        savingsById[savingsIdByMemberAddress[msg.sender]].votes -= _votes; 
        voteTallyByLoanRequestId[_loanRequestId]        += _votes;
        
        if(voteTallyByLoanRequestId[_loanRequestId] >=  voteThresholdById[loanRequest_.voteThresholdId].minimumVotes){
            //approve loan 
            loanRequestById[_loanRequestId].decision = Decision.APPROVED;
            loanRequestById[_loanRequestId].decisionDate = block.timestamp; 

            //create loan
            uint256 loanId_ = index++;
            loanIdByLoanRequestId[_loanRequestId] = loanId_; 
            loanById[loanId_] = Loan({
                                        id : loanId_,  
                                        savingsId : loanRequest_.savingsId,
                                        loanRequestId : _loanRequestId,
                                        borrower : loanRequest_.borrower,
                                        amount : loanRequest_.amount,
                                        interest : loanRequest_.interest, 
                                        paymentPeriod : loanRequest_.paymentPeriod,
                                        lastPaymentDate : 0,
                                        completionDueDate : block.timestamp + RFULib.resolveTerm(loanRequest_.term),
                                        created : block.timestamp, 
                                        closedDate : 0, 
                                        status : LoanStatus.ISSUED
                                    });
                
        }

        uint256 loanContribution_ = getLoanContribution(_votes);
        savingsById[savingsIdByMemberAddress[msg.sender]].availableBalance -= loanContribution_;

        uint256 remainingRequiredContribution_ = loanRequest_.amount - loanRequestById[_loanRequestId].contributedFunds; 
        if(loanContribution_ > remainingRequiredContribution_) {
            loanContribution_ = remainingRequiredContribution_;
        }

        loanRequestById[_loanRequestId].contributedFunds += loanContribution_;

        if(hasLoanStakeByLoanRequestByMemberAddress[msg.sender][_loanRequestId] ){
            loanStakeById[loanStakeIdByLoanRequestIdByMemberAddress[msg.sender][_loanRequestId]].amount += loanContribution_;
        }
        else {
            //create loan stake
            uint256 loanStakeId_ = index++; 

            loanStakeIdByLoanRequestIdByMemberAddress[msg.sender][_loanRequestId] = loanStakeId_; 
            hasLoanStakeByLoanRequestByMemberAddress[msg.sender][_loanRequestId] = true;
  
            loanStakeById[loanStakeId_] = LoanStake({
                                                        id : loanStakeId_,
                                                        loanRequestId : _loanRequestId, 
                                                        holder : msg.sender, 
                                                        amount : loanContribution_, 
                                                        votes : _votes, 
                                                        created : block.timestamp,
                                                        isActive : true
                                                });
            loanStakeIdsByLoanRequestId[_loanRequestId].push(loanStakeId_);
            loanStakeIdsByMemberAddress[msg.sender].push(loanStakeId_); 
        }
        emit RFU_EVENT(EVENT_TYPE.BORROW_VOTE, msg.sender,  _votes, _loanRequestId, block.timestamp);

        return true; 
    }

    function recindVoteForLoanApproval(uint256 _loanRequestId) payable membersOnly external returns (bool _success){
        LoanRequest memory loanRequest_ = loanRequestById[_loanRequestId]; 
        require(loanRequest_.decision == Decision.PENDING, "invalid loan request state" ); 
        LoanStake memory loanStake_ = loanStakeById[loanStakeIdByLoanRequestIdByMemberAddress[msg.sender][_loanRequestId]]; 
        
        // return staked funds 
        loanRequestById[_loanRequestId].contributedFunds -= loanStake_.amount;
        savingsById[savingsIdByMemberAddress[msg.sender]].availableBalance += loanStake_.amount;

        hasLoanStakeByLoanRequestByMemberAddress[msg.sender][_loanRequestId] = false;
        
        // return the votes
        voteTallyByLoanRequestId[_loanRequestId]          -= loanStake_.votes;
        savingsById[savingsIdByMemberAddress[msg.sender]].votes += loanStake_.votes; 
        

        emit RFU_EVENT(EVENT_TYPE.BORROW_VOTE_CANCEL, msg.sender,  loanStake_.amount, _loanRequestId, block.timestamp); 
        return true; 
    }

    // manage your loan
    function getLoanId(uint256 _loanRequestId) view external returns (uint256 _loanId){
        return loanIdByLoanRequestId[_loanRequestId];
    }

    function cancellLoan(uint256 _loanId) external returns (bool _success){
        require(loanById[_loanId].borrower == msg.sender, "borrower only");
        require(loanById[_loanId].status == LoanStatus.ISSUED, "invalid loan state"); 
        loanById[_loanId].status = LoanStatus.CANCELLED; 
        releaseLoanStakes(_loanId); 
        emit RFU_EVENT(EVENT_TYPE.BORROW_CANCEL, msg.sender, loanById[_loanId].amount, _loanId, block.timestamp); 
        return true; 
    }

    function drawDownLoan(uint256 _loanId) external returns (uint256 _loanAmount){
        Loan memory loan_ = loanById[_loanId]; 
        require(loan_.borrower == msg.sender, "borrower only");
        require(loan_.status == LoanStatus.ISSUED, "invalid loan state"); 
        loanById[_loanId].status = LoanStatus.DRAWNDOWN; 

        (uint256 principal_, uint256 interest_) = getPrincipalAndInterest(_loanId, loan_.amount);
        treasury.lend(loanRequestById[loanById[_loanId].loanRequestId].savingsId, _loanId, principal_, interest_); 
        
        erc20.transferFrom(address(self), msg.sender, principal_); 

        emit RFU_EVENT(EVENT_TYPE.BORROW, msg.sender,  principal_, _loanId, block.timestamp); 
        return principal_; 
    }

    function repayLoan(uint256 _loanId, uint256 _amount) payable external returns (uint256 _loanBalance){
         Loan memory loan_ = loanById[_loanId]; 
         require(loan_.status == LoanStatus.DRAWNDOWN || loan_.status == LoanStatus.DEFAULTED, "invalid loan state"); 

         uint256 transferAmount_ = _amount; 
         if(loanById[_loanId].amount < _amount){
             transferAmount_ = loanById[_loanId].amount;
        }

        erc20.transferFrom(msg.sender, self, transferAmount_); 
        erc20.approve(address(treasury), transferAmount_); 

        (uint256 principal_, uint256 interest_) = getPrincipalAndInterest(_loanId, transferAmount_);
        treasury.repay(loanRequestById[loanById[_loanId].loanRequestId].savingsId ,_loanId, principal_, interest_); 

        decreaseLoanStakes(_loanId, principal_); 
       
        loanById[_loanId].amount -= transferAmount_; 
        _loanBalance = loanById[_loanId].amount;

        if(_loanBalance == 0){
            loanById[_loanId].status = LoanStatus.CLOSED;
            releaseLoanStakes(loanById[_loanId].loanRequestId);
        }

        emit RFU_EVENT(EVENT_TYPE.REPAY, msg.sender,  transferAmount_, _loanId, block.timestamp);
        return _loanBalance;  
    } 

    // Distribute interest rewards 

    function distributeInterestRewards(uint256 _loanId) external returns (uint256 _interestRewards){
        Loan memory loan_ = loanById[_loanId]; 
        _interestRewards = treasury.retrievePaidInterest(loanById[_loanId].savingsId, _loanId); 
        payoutLoanStakes(loan_.amount, loanStakeIdsByLoanRequestId[loan_.loanRequestId], _interestRewards); // payout the stakes
        _interestRewards; 
    }

    // Join and leave the union 

    function joinUnion(uint256 _initialDeposit) payable external returns (uint256 _savingsId){
        require(_initialDeposit > 0, "Initial deposit must be greater than zero");
        require(!isMember[msg.sender], "already joined"); 
        isMember[msg.sender] = true; 

        erc20.transferFrom(msg.sender, self, _initialDeposit); 
        _savingsId = index++; 
        erc20.approve(address(treasury), _initialDeposit); 
        treasury.deposit(_savingsId, _initialDeposit); 

        savingsIdByMemberAddress[msg.sender] = _savingsId;
        savingsIds.push(_savingsId); 
        savingsById[_savingsId] = Savings({
                                            id : _savingsId,
                                            balance : _initialDeposit, 
                                            availableBalance : _initialDeposit,
                                            collateralBalance : 0, 
                                            collateralFunds : 0,
                                            votes : getVotes(_initialDeposit),
                                            owner : msg.sender,
                                            isActive : true,  
                                            lastUpdated : block.timestamp 
                                        });
        return _savingsId; 
    } 

    function leaveUnion() external membersOnly returns (uint256 _finalBalance){
        uint256 savingsId_ = savingsIdByMemberAddress[msg.sender];
        require(!hasLoan[msg.sender], "loan outstanding"); 
        require(savingsById[savingsId_].isActive == true, "You are not an active member of this union"); 
        require(savingsById[savingsId_].balance <= savingsById[savingsId_].availableBalance, "outstanding payments due to you"); 

        savingsById[savingsId_].isActive = false; 
        isMember[msg.sender] = false;

        _finalBalance = savingsById[savingsId_].availableBalance;
        savingsById[savingsId_].availableBalance = 0; 
        savingsById[savingsId_].balance = 0;
        savingsById[savingsId_].votes = 0; 
        savingsById[savingsId_].lastUpdated = block.timestamp; 

        treasury.withdraw(savingsId_, _finalBalance);
        erc20.transfer(msg.sender, _finalBalance);

        return _finalBalance;         
    } 

    // admin functions 

    function setFee(string memory _feeName, uint256 _fee) external safeOnly returns (bool _success){
        feeByName[_feeName] = _fee;
        return true; 
    }

    function setVoteMultiple(uint256 _voteMultiple) external safeOnly returns (bool _success){
        voteMultiple = _voteMultiple;
        return true; 
    }

    function setVoteThreshold(uint256 _loanAmountMin, uint256 _loanAmountMax, uint256 _minVotes) external safeOnly returns (uint256 _voteThresholdId){
        _voteThresholdId = index++; 
        voteThresholdById[_voteThresholdId] = VoteThreshold({
                                                                id : _voteThresholdId, 
                                                                loanAmount : Range({
                                                                                     min : _loanAmountMin,
                                                                                     max : _loanAmountMax
                                                                                    }), 
                                                                minimumVotes : _minVotes 
                                                            });
        return _voteThresholdId; 
    }
    
    function setRate(Range memory _amount, uint256 _interest, RateType _rateType, uint256 _expiryDate) external safeOnly returns (bool _success){
        uint256 rateId_ = index++; 
        rateIds.push(rateId_); 
        rateById[rateId_] = Rate({
                                    id : rateId_,  
                                    amount : _amount,  
                                    interest : _interest, 
                                    rateType : _rateType,
                                    setDate : block.timestamp, 
                                    expiryDate : _expiryDate
                                });
        return true; 
    }

    
    // join the union
    function getSavingsId() view external returns (uint256 _savingsId){
        return savingsIdByMemberAddress[msg.sender]; 
    } 

    function migrateSafeAddress(address _newAddress) external safeOnly returns (bool _success){
        safeAddress = _newAddress; 
        return true; 
    }
    //============================================ INTERNAL ===========================================================

    function payoutLoanStakes(uint256 _loanAmount, uint256[] memory _stakeIds, uint256 _interestRewards) internal returns (bool _paid) {
        for(uint256 x_ = 0; x_ < _stakeIds.length; x_++){
            LoanStake memory stake_ = loanStakeById[_stakeIds[x_]];
            uint256 share_ = getShare(_loanAmount, stake_.amount, _interestRewards);
            uint256 savingsId_ = savingsIdByMemberAddress[stake_.holder];
            treasury.payInterest(savingsId_, share_); 
            savingsById[savingsId_].balance += share_;
            savingsById[savingsId_].availableBalance += share_; 
        }
        return true; 
    }

    function getShare(uint256 _loanAmount, uint256 _stakeAmount, uint256 _interestRewards) internal pure returns (uint256 _share) {
        _share = _interestRewards * (_stakeAmount / _loanAmount); 
        return _share;    
    }

    function getRepaymentAmount(uint256 _loanAmount, Rate memory _rate) internal pure returns (uint256 _fullLoan){
        _fullLoan = _loanAmount * ((_rate.interest+100) / 100);
        return _fullLoan; 
    }       

    function getVotes(uint256 _depositAmount) internal view returns (uint256 _votes){
        return _depositAmount * voteMultiple; 
    }

    function getVoteThresholdId(uint256 _amount) internal view returns (uint256 _id) {
        for(uint256 x = 0; x < voteThresholdIds.length; x++){
            if(_amount >= voteThresholdById[voteThresholdIds[x]].loanAmount.min && _amount <= voteThresholdById[voteThresholdIds[x]].loanAmount.max){
                return voteThresholdIds[x]; 
            } 
        }
        revert("No vote threshold found.");
    }

    function getPrincipalAndInterest(uint256 _loanId, uint256 _amount) internal view returns (uint256 _principal, uint256 _interest) {
        Loan memory loan_ = loanById[_loanId];
        _interest = (_amount * (loan_.interest+10000)) / 10000;
        _principal = _amount - _interest;
        return (_principal, _interest); 
    }

    function releaseLoanStakes(uint256 _loanRequestId) internal returns (bool _released) {
        uint256 [] memory loanStakeIds_ = loanStakeIdsByLoanRequestId[_loanRequestId]; 
        for(uint256 x_ = 0; x_ < loanStakeIds_.length; x_++) {
            LoanStake memory loanStake_ = loanStakeById[loanStakeIds_[x_]];
            
            savingsById[savingsIdByMemberAddress[loanStake_.holder]].availableBalance += loanStake_.amount;
            savingsById[savingsIdByMemberAddress[loanStake_.holder]].votes += loanStake_.votes; 
            loanStakeById[loanStakeIds_[x_]].isActive = false; 
        }
        return true; 
    }

    function decreaseLoanStakes(uint256 _loanRequestId, uint256 _amount) internal returns (bool _decreased) {
        uint256 [] memory loanStakeIds_ = loanStakeIdsByLoanRequestId[_loanRequestId];
        uint256 votes_ = getVotes(_amount); 

        for(uint256 x_ = 0; x_ < loanStakeIds_.length; x_++) {
            LoanStake memory loanStake_ = loanStakeById[loanStakeIds_[x_]];
            uint256 stakeReduction_ = (loanStake_.amount) / loanRequestById[_loanRequestId].amount * _amount;

            loanStakeById[loanStakeIds_[x_]].amount -= stakeReduction_;
            savingsById[savingsIdByMemberAddress[loanStake_.holder]].availableBalance += stakeReduction_;

            uint256 votesReduction_ = ((loanStake_.votes) / voteTallyByLoanRequestId[_loanRequestId]) * votes_;

            loanStakeById[loanStakeIds_[x_]].votes -= votesReduction_; 
            savingsById[savingsIdByMemberAddress[loanStake_.holder]].votes += votesReduction_; 
        }
        return true; 
    }

    function getLoanContribution(uint256 _votes) internal view returns (uint256 _contribution) {
        _contribution = _votes / voteMultiple; 
        require(savingsById[savingsIdByMemberAddress[msg.sender]].availableBalance >= _contribution, "Insufficient savings balance"); 
        return _contribution; 
    }

        
}