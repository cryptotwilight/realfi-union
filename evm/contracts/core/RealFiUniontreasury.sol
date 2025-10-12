// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

import "../interfaces/IRealFiUnionTreasury.sol"; 

import {LoanTreasury} from "../structs/RFUStructs.sol"; 

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";


contract RealFiUnionTreasury is IRealFiUnionTreasury { 

    modifier safeOnly () { 
        require(msg.sender == safeAddress, "safe address only"); 
        _; 
    }

    modifier refiUnionOnly () {
        require(msg.sender == realFiUnionAddress, "realFiUnion only");
        _;
    }

    IERC20 immutable erc20;
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
         

        _treasuryBalance =  totalSavingsBalance + interestBalance; 
        return _treasuryBalance; 
    }

    function withdraw(uint256 _savingsId, uint256 _amount) external refiUnionOnly returns (uint256 _treasuryBalance){
        require( savingsBalanceBySavingsId[_savingsId] >= _amount, "insufficient savings treasury balance");
        require(availableBalance >= _amount, "insufficient available balance"); 

        savingsBalanceBySavingsId[_savingsId] -= _amount;
        availableBalance -= _amount;   
        erc20.approve(realFiUnionAddress, _amount);
         
        _treasuryBalance =  totalSavingsBalance + interestBalance; 
        return _treasuryBalance; 
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

    function setRealFiUnionAddress(address _realFiUnionAddress)  external safeOnly returns (bool _success) {
        realFiUnionAddress = _realFiUnionAddress;
        return true; 
    }
}