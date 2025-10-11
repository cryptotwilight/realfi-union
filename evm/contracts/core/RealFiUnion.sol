// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

import "../interfaces/IRealFiUnion.sol"; 
import "../interfaces/IRealFiUnionTreasury.sol";

import {Decision, Rate, RateType, Range} from "../structs/RUStructs.sol"; 

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
    uint256 voteMultiple; 

    address safeAddress; 
    string [] feeNames;
    uint256 [] loanRequestIds;  
    
    uint256[] savingsIds; 
    mapping(uint256=>bool) activeSavingsId; 
    mapping(uint256=>Savings) savingsById; 
    mapping(address=>uint256) savingsIdByMemberAddress; 

    mapping(uint256=>LoanRequest) loanRequestById;
    mapping(address=>uint256) loanRequestIdByMemberAddress; 
    mapping(address=>bool) hasLoanRequest;

    mapping(address=>bool) hasLoan;
    mapping(uint256=>Loan) loanById; 
    mapping(address=>uint256) loanIdByMemberAddress;


    mapping(string=>uint256) feeByName; 
    mapping(uint256=>uint56) voteTallyByLoanRequestId;

    mapping(uint256=>VoteThreshold) voteThresholdById;

    // Real Fi Union Members 
    address [] members; 
    mapping(address=>bool) isMember;

    string [] rateNames; 
    mapping(string => bool) knownRateName; 
    mapping(string => Rate) rateByName; 


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

    function geetRates() view external returns (Rate [] memory _rates) {
        _rates = new Rate[](rateNames.length); 
        for(uint256 x = 0; x < rateNames.length; x++){
            _rates[x] = rateByName[rateNames[x]];
        }
        return _rates;
    }


    // contribute to the union 
    function deposit(uint256 _savingsId, uint256 _amount) view external returns (uint256 _depositId){

    }

    function withdraw(uint256 _savingsId, uint256 _amount) view external returns (uint256 _withdrawId){

    } 

    // manage your loan request
    function getLoanRequestIds() view external returns (uint256[] memory){
        return loanRequestIds; 
    }

    function getLoanRequest(uint256 _loanRequestId) view external returns (LoanRequest memory _loanRequest){
        return loanRequestById[_loanRequestId]; 
    }

    function isApproved(uint256 _loanRequestId) view external returns (bool _isApproved){
        return loanRequestById[_loanRequestId].decision == Decision.APPROVED;  
    }

    function requestLoan(LoanRequest memory _loanRequest) payable membersOnly external returns (uint256 _loanRequestId){
    } 

    function withdrawLoanRequest(uint256 _loanRequestId)  external membersOnly returns (bool _cancelled){

    }

    // vote on a loan request
    function getVoteThresholdIds() view external returns (uint256[] memory _thresholdIds){

    }

    function getVoteThreshold(uint256 thresholdId) view external returns (VoteThreshold memory _voteThreshold){

    }

    function voteForLoanApproval(uint256 _loanRequestId) payable external returns (bool _success){

    }

    function recindVoteForLoanApproval(uint256 _loanRequestId) payable external returns (bool _success){

    }

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
    
    function setRate(string memory _name, uint256 _amount, RateType _rateType, uint256 _expiryDate) external safeOnly returns (bool _success){
        if(!knownRateName[_name]){
            rateNames.push(_name); 
        }
        rateByName[_name] = Rate({
                                    name :_name, 
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
                                                lastUpdated : block.timestamp
                                            });
        return _savingsId; 
    } 

    function leaveUnion() external membersOnly returns (uint256 _finalBalance){
        uint256 savingsId_ = savingsIdByMemberAddress[msg.sender];
        require(activeSavingsId[savingsId_] == true, "You are not an active member of this union"); 
        activeSavingsId[savingsId_] = false; 
        isMember[msg.sender] = false;

        _finalBalance = savingsById[savingsId_].balance;
        savingsById[savingsId_].balance = 0;
        savingsById[savingsId_].votes = 0; 
        savingsById[savingsId_].lastUpdated = block.timestamp; 

        treasury.withdraw(savingsId_, _finalBalance);
        erc20.transfer(msg.sender, _finalBalance);


        return _finalBalance;         
    } 

    //============================================ INTERNAL ===========================================================

    function getVotes(uint256 _depositAmount) internal view returns (uint256 _votes){
        return _depositAmount * voteMultiple; 
    }
}