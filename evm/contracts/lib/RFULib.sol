// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

import {Term} from "../structs/RFUStructs.sol"; 

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