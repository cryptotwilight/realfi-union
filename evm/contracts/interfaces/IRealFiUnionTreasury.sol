// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

import {FullTreasuryBalance} from "../structs/RFUStructs.sol";

interface IRealFiUnionTreasury { 

    function getTreasuryBalance() view external returns (FullTreasuryBalance memory _fullTreasuryBalance);

    function deposit(uint256 _savingsId, uint256 _amount) payable external returns (uint256 _treasuryBalance); 

    function withdraw(uint256 _savingsId, uint256 _amount) external returns (uint256 _treasuryBalance); 

    function lend(uint256 _savingsId, uint256 _loanId, uint256 _amount, uint256 _totalInterest) external returns (uint256 _treasuryBalance); 

    function repay(uint256 _savingsId, uint256 _loanId, uint256 _amount, uint256 _interest) external payable returns (uint256 _treasuryBalance); 

    function retrievePaidInterest(uint256 _savingsId, uint256 _loanId) external returns (uint256 _paidInterest); 

    function payInterest(uint256 _savingsId, uint256 _amount) external returns (uint256 _savingsBalance); 

}

