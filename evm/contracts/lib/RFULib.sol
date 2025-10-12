// SPDX-License-Identifier: APACHE 2.0
pragma solidity ^0.8.30;

import {VoteThreshold} from "../structs/RFUStructs.sol"; 

library RFULib { 

    function findVoteThreshold(VoteThreshold [] memory _voteThresholds, uint256 _borrowAmount) internal pure returns (uint256 _voteThresholdId) { 
        for (uint256 x = 0; x < _voteThresholds.length; x++) {
            if (_borrowAmount >= _voteThresholds[x].minBorrowAmount && _borrowAmount <= _voteThresholds[i].maxBorrowAmount) {
                _voteThresholdId = _voteThresholds[i].id;
                break;
            }
        }

        return _voteThresholdId; 
    }

}