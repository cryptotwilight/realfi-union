// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

import "../interfaces/IRealFiUnion.sol"; 
import "../interfaces/IRealFiUnionTreasury.sol";

import {Decision, Rate, RateType, Range, Tx, 
        RFU_EVENT, EVENT_TYPE, ProtoLoanRequest, LoanRequest, Loan, Term, LoanStatus, LoanStake} from "../structs/RFUStructs.sol"; 

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";


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

    mapping(uint256=>uint256[]) loanStakeByLoanRequestId; 
    mapping(address=>uint256[]) loanStakeIdsByMemberAddress; 
    mapping(uint256=>LoanStake) loanStakeById; 

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
        return txIds; 
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
        savingsById[_savingsId] += _amount; 
        savingsById[_savingsId].lastUpdated = block.timestamp; 

        emit RFU_EVENT(EVENT_TYPE.DEPOSIT, msg.sender,  _amount, _savingsId, block.timestamp); 
        _txId = index++;
        txById[_txId] = Tx ({
                                id : _txId,
                                savingsId : _savingsId,
                                txType  : "DEPOSIT",
                                amount : _amount,
                                instigator : msg.sender,
                                date : block.stamp
                            }); 
        return _txId; 
    }

    // withdraw from the union
    function withdraw(uint256 _savingsId, uint256 _amount)  external returns (uint256 _txId) {
        require(savingsById[_savingsId].isActive, "inactive savings Id");
        require(savingsById[_savingsId].balance >= _amount, "insufficient balance"); 
        savingsById[_savingsId] -= _amount;
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
                                date : block.stamp
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
        require(!hasLoanRequest[msg.sender], "already has loan request "[msg.sender]); 
        hasLoanRequest[msg.sender] = true; 
        require(savingsById[_pLoanRequest.savingsId].owner == msg.sender, "saving holder only"); 
        require(!hasLoan(msg.sender), "already has loan"); 
        require(savingsById[_pLoanRequest.savingsId].amount >= _pLoanRequest.amount, "insufficient for savings");

        Rate memory rate_ = rateById[_pLoanRequest.rateId]; 
        require(rate_.rateType == RateType.LOAN_INTEREST, "rate type mis-match"); 
        require(_pLoanRequest.amount >= rate_.amount.min && _pLoanRequest.amount <= rate_.amount.max, "requested loan rate <> amount mis-match"); 

        _loanRequestId = index++; 
        loanRequestById[_loanRequestId] = LoanRequest ({
                                                         id : _loanRequestId,  
                                                        amount : _pLoanRequest.amount,
                                                        interest : rate_.interest, 
                                                        term : _pLoanRequest.term,
                                                        savingsId : _pLoanRequest.savingsId,
                                                        borrower : _pLoanRequest.borrower,
                                                        created : block.timestamp,
                                                        voteThresholdId : getVoteThresholdId(_pLoanRequest.amount),
                                                        expiryDate : block.timestamp + loanRequestValidityPeriod,
                                                        decisionDate : block.timestamp, 
                                                        decision : Decision.PENDING
                                                            
                                                      });
        emit RFU_EVENT(EVENT_TYPE.BORROW_REQUEST, msg.sender, _pLoanRequest.amount, _loanRequestId, block.timestamp); 
        return _loanRequestId; 
    } 

    function withdrawLoanRequest(uint256 _loanRequestId)  external membersOnly returns (bool _cancelled){
        require(msg.sender == loanRequestById[_loanRequestId].borrower, "borrower only"); 
        loanRequestById[_loanRequestId].decision = Decision.WITHDRAWN;
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
        require(loanRequest_.expiryDate >= block.timestamp, "loan request expired");
        require(voteTallyByLoanRequestId <=  voteThresholdById[loanRequest_.thresholdId].amount.min, "vote threshold exceeded"); 
        voteTallyByLoanRequestId[_loanRequestId] += _votes;
        if(voteTallyByLoanRequestId <=  voteThresholdById[loanRequest_.thresholdId].amount.min){
            //approve loan 
            loanRequestById[_loanRequestId].decision = Decision.APPROVED;
            //create loan
            uint256 loanId_ = index++;
            loanIdByLoanRequestId[_loanRequestId] = loanId_; 
            loanById[loanId_] = Loan({
                                        id : loanId_,
                                        borrower : loanRequest_.borrower,
                                        amount : loanRequest_.amount,
                                        interestRate : loanRequestById[_loanRequestId].interestRate,
                                        expiryDate : loanRequestById[_loanRequestId].expiryDate
                                    });
        }

        uint256 loanContribution_ = getLoanContribution(_votes);
        savingsById[savingsIdByMemberAddress[msg.sender]].availableBalance -= loanContribution_;
        uint256 loanStakeId_ = index++; 
        loanStakeById[loanStakeId_] = LoanStake({
                                                    id : loanStakeId_, 
                                                    loanRequestId : _loanRequestId, 
                                                    holder : msg.sender, 
                                                    amount : loanContribution_, 
                                                    created : block.timestamp
                                                });
        loanStakeByLoanRequestId[_loanRequestId].push(loanStakeId_); 

        emit RFU_EVENT(EVENT_TYPE.BORROW_VOTE, msg.sender,  _votes, _loanRequestId, block.timestamp);
        return true; 
    }

    function recindVoteForLoanApproval(uint256 _loanRequestId) payable membersOnly external returns (bool _success){

        emit RFU_EVENT(EVENT_TYPE.BORROW_VOTE_CANCEL, msg.sender,  _amount, _loanRequestId, block.timestamp); 
    }

    // manage your loan
    function getLoanId(uint256 _loanRequestId) view external returns (uint256 _loanId){
        return loanIdByLoanRequestId[_loanRequestId];
    }

    function cancellLoan(uint256 _loanId) external returns (bool _success){
        require(loanById[_loanId].borrower == msg.sender, "borrower only");
        require(loanById[_loanId].status == LoanStatus.ISSUED, "invalid loan state"); 
        loanById[_loanId].status = LoanStatus.CANCELLED; 
        releaseStakes(_loanId); 
        emit RFU_EVENT(EVENT_TYPE.BORROW_CANCEL, msg.sender, loanById[_loanId].amount, _loanId, block.timestamp); 
        return true; 
    }

    function drawDownLoan(uint256 _loanId) external returns (uint256 _loanAmount){
        require(loanById[_loanId].borrower == msg.sender, "borrower only");
        Loan memory loan_ = loanById[_loanId]; 
        (uint256 principal_, uint256 interest_) = getPrincipalAndInterest(_loanId, loan_.amount);
        treasury.lend(loanRequestById[loanById[_loanId].loanRequestId].savingsId, _loanId, principal_, interest_); 

        erc20.transferFrom(address(self), msg.sender, principal_); 

        emit RFU_EVENT(EVENT_TYPE.BORROW, msg.sender,  principal_, _loanId, block.timestamp); 
    }

    function repayLoan(uint256 _loanId, uint256 _amount) payable external returns (uint256 _loanBalance){
        erc20.transferFrom(msg.sender, self, _amount); 
        erc20.approve(address(treasury), _amount); 
        (uint256 principal_, uint256 interest_) = getPrincipalAndInterest(_loanId, _amount);
        treasury.repay(loanRequestById[loanById[_loanId].loanRequestId].savingsId ,_loanId, principal_, interest_); 

        loanById[_loanId].balance -= _amount; 
        _loanBalance = loanById[_loanId].balance;
        emit RFU_EVENT(EVENT_TYPE.REPAY, msg.sender,  _amount, _loanId, block.timestamp);
        return _loanBalance;  
    } 

    // Distribute interest rewards 

    function distributeInterestRewards(uint256 _loanId) external returns (uint256 _interestRewards){


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
        savingsById[savingsId_].isActive = false; 
        isMember[msg.sender] = false;

        _finalBalance = savingsById[savingsId_].balance;
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
    
    function setRate(uint256 _amount, RateType _rateType, uint256 _expiryDate) external safeOnly returns (bool _success){
        uint256 rateId_ = index++; 
        rateIds.push(rateId_); 
        rateById[rateId_] = Rate({
                                    id :rateId_, 
                                    amount : _amount, 
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

    function getVotes(uint256 _depositAmount) internal view returns (uint256 _votes){
        return _depositAmount * voteMultiple; 
    }

    function getVoteThresholdId(uint256 _amount) internal view returns (uint256 _id) {
        for(uint256 x = 0; x < voteThresholdIds.length; x++){
            if(_amount >= voteThresholdIds[x].loanAmount.min && _amount <= voteThresholdIds[x].loanAmount.max){
                return voteThresholdIds[x].id; 
            } 
        }
        revert("Votethreshold not found");
    }

    function getPrincipalAndInterest(uint256 _loanId, uint256 _amount) internal view returns (uint256 _principal, uint256 _interest) {
        Loan memory loan_ = loanById[_loanId];
        _interest = (_amount * (loan_.interest+10000)) / 10000;
        _principal = _amount - _interest;
        return (_principal, _interest); 
    }

    function releaseStakes(uint256 _loanId) internal returns (bool _released) {

    }

    function getLoanContribution(uint256 _votes) internal view returns (uint256 _contribution) {
        _contribution = _votes / voteMultiple; 
        require(savingsById[savingsIdByMemberAddress[msg.sender]].availableBalance >= _contribution, "Insufficient savings balance"); 
        return _contribution; 
    }

        
}