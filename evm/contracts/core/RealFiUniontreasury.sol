// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

import "../interfaces/IRealFiUnionTreasury.sol"; 

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";


contract RealFiUnionTreasury is IRealFiUnionTreasury { 

    modifier safeOnly () { 
        require(msg.sender == safeAddress, "safe address only"); 
        _; 
    }

    address safeAddress; 
    address realFiUnionAddress; 
    IERC20 erc20; 

    mapping(uint256=>mapping(uint256=>uint256)) loanBalanceByLoanIdBySavingsId; 

    constructor(address _safeAddress, address _token) { 
        safeAddress = _safeAddress; 
        erc20 = IERC20(_token); 
    }

    function getTreasuryBalance() view external returns (FullTreasuryBalance memory _fullTreasuryBalance){

    }

    function deposit(uint256 _savingsId, uint256 _amount) payable external returns (uint256 _treasuryBalance){

    }

    function withdraw(uint256 _savingsId, uint256 _amount) external returns (uint256 _treasuryBalance){

    }

    function lend(uint256 _savingsId, uint256 _loanId, uint256 _amount) external returns (uint256 _treasuryBalance){

    } 

    function repay(uint256 _savingsId, uint256 _loanId, uint256 _amount) external payable returns (uint256 _treasuryBalance){

    }

    function getRealFiUnion() view external returns (address _realFiUnion) {
        return realFiUnionAddress; 
    }

    function setRealFiUnionAddress(address _realFiUnionAddress) view external safeOnly returns (bool _success) {
        realFiUnionAddress = _realFiUnionAddress;
        return true; 
    }
}