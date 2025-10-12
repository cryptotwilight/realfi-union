// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

import {Savings, ProtoLoanRequest, LoanRequest, Loan, VoteThreshold, Rate, LoanStake} from "../structs/RFUStructs.sol";

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