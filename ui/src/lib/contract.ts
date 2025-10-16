export const CONTRACT_ADDRESS = "0xD0Cc1d0E1F4005e09a88e0C4AD1719Fd71969C67";

export const BASE_CHAIN_ID = 8453; // Base mainnet

export const CONTRACT_ABI = [
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_safeAddress",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_treasury",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "_erc20",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "enum EVENT_TYPE",
				"name": "_type",
				"type": "uint8"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "_instigator",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_totalAmount",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_entityId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_date",
				"type": "uint256"
			}
		],
		"name": "RFU_EVENT",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanId",
				"type": "uint256"
			}
		],
		"name": "cancellLoan",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_success",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_savingsId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "deposit",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_txId",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanId",
				"type": "uint256"
			}
		],
		"name": "distributeInterestRewards",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_interestRewards",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanId",
				"type": "uint256"
			}
		],
		"name": "drawDownLoan",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_loanAmount",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_feeName",
				"type": "string"
			}
		],
		"name": "getFee",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_fee",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getFeeNames",
		"outputs": [
			{
				"internalType": "string[]",
				"name": "_feeNames",
				"type": "string[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanId",
				"type": "uint256"
			}
		],
		"name": "getLoan",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "savingsId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "loanRequestId",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "borrower",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "interest",
						"type": "uint256"
					},
					{
						"internalType": "enum Period",
						"name": "paymentPeriod",
						"type": "uint8"
					},
					{
						"internalType": "uint256",
						"name": "lastPaymentDate",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "completionDueDate",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "created",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "closedDate",
						"type": "uint256"
					},
					{
						"internalType": "enum LoanStatus",
						"name": "status",
						"type": "uint8"
					}
				],
				"internalType": "struct Loan",
				"name": "_loan",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanRequestId",
				"type": "uint256"
			}
		],
		"name": "getLoanId",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_loanId",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanRequestId",
				"type": "uint256"
			}
		],
		"name": "getLoanRequest",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "savingsId",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "borrower",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "interest",
						"type": "uint256"
					},
					{
						"internalType": "enum Term",
						"name": "term",
						"type": "uint8"
					},
					{
						"internalType": "enum Period",
						"name": "paymentPeriod",
						"type": "uint8"
					},
					{
						"internalType": "uint256",
						"name": "created",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "expiryDate",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "voteThresholdId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "contributedFunds",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "decisionDate",
						"type": "uint256"
					},
					{
						"internalType": "enum Decision",
						"name": "decision",
						"type": "uint8"
					}
				],
				"internalType": "struct LoanRequest",
				"name": "_loanRequest",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getLoanRequestIds",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanStakeId",
				"type": "uint256"
			}
		],
		"name": "getLoanStakeById",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "loanRequestId",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "holder",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "votes",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "created",
						"type": "uint256"
					},
					{
						"internalType": "bool",
						"name": "isActive",
						"type": "bool"
					}
				],
				"internalType": "struct LoanStake",
				"name": "_loanStake",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getLoanStakeIds",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "_loanStakeIds",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getRates",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"components": [
							{
								"internalType": "uint256",
								"name": "min",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "max",
								"type": "uint256"
							}
						],
						"internalType": "struct Range",
						"name": "amount",
						"type": "tuple"
					},
					{
						"internalType": "uint256",
						"name": "interest",
						"type": "uint256"
					},
					{
						"internalType": "enum RateType",
						"name": "rateType",
						"type": "uint8"
					},
					{
						"internalType": "uint256",
						"name": "setDate",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "expiryDate",
						"type": "uint256"
					}
				],
				"internalType": "struct Rate[]",
				"name": "_rates",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_savingsId",
				"type": "uint256"
			}
		],
		"name": "getSavings",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "balance",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "availableBalance",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "collateralBalance",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "collateralFunds",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "votes",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "owner",
						"type": "address"
					},
					{
						"internalType": "bool",
						"name": "isActive",
						"type": "bool"
					},
					{
						"internalType": "uint256",
						"name": "lastUpdated",
						"type": "uint256"
					}
				],
				"internalType": "struct Savings",
				"name": "_savings",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getSavingsId",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_savingsId",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_txId",
				"type": "uint256"
			}
		],
		"name": "getTx",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "savingsId",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "txType",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "instigator",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "date",
						"type": "uint256"
					}
				],
				"internalType": "struct Tx",
				"name": "_tx",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_savingsId",
				"type": "uint256"
			}
		],
		"name": "getTxIdsBySavingsId",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "_txIds",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getUnionToken",
		"outputs": [
			{
				"internalType": "address",
				"name": "_token",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "thresholdId",
				"type": "uint256"
			}
		],
		"name": "getVoteThreshold",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"components": [
							{
								"internalType": "uint256",
								"name": "min",
								"type": "uint256"
							},
							{
								"internalType": "uint256",
								"name": "max",
								"type": "uint256"
							}
						],
						"internalType": "struct Range",
						"name": "loanAmount",
						"type": "tuple"
					},
					{
						"internalType": "uint256",
						"name": "minimumVotes",
						"type": "uint256"
					}
				],
				"internalType": "struct VoteThreshold",
				"name": "_voteThreshold",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getVoteThresholdIds",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "_thresholdIds",
				"type": "uint256[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanRequestId",
				"type": "uint256"
			}
		],
		"name": "isApproved",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_isApproved",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_initialDeposit",
				"type": "uint256"
			}
		],
		"name": "joinUnion",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_savingsId",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "leaveUnion",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_finalBalance",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_newAddress",
				"type": "address"
			}
		],
		"name": "migrateSafeAddress",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_success",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanRequestId",
				"type": "uint256"
			}
		],
		"name": "recindVoteForLoanApproval",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_success",
				"type": "bool"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "repayLoan",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_loanBalance",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"components": [
					{
						"internalType": "address",
						"name": "borrower",
						"type": "address"
					},
					{
						"internalType": "uint256",
						"name": "amount",
						"type": "uint256"
					},
					{
						"internalType": "enum Term",
						"name": "term",
						"type": "uint8"
					},
					{
						"internalType": "enum Period",
						"name": "paymentPeriod",
						"type": "uint8"
					},
					{
						"internalType": "uint256",
						"name": "rateId",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "savingsId",
						"type": "uint256"
					}
				],
				"internalType": "struct ProtoLoanRequest",
				"name": "_pLoanRequest",
				"type": "tuple"
			}
		],
		"name": "requestLoan",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_loanRequestId",
				"type": "uint256"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_feeName",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_fee",
				"type": "uint256"
			}
		],
		"name": "setFee",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_success",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "min",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "max",
						"type": "uint256"
					}
				],
				"internalType": "struct Range",
				"name": "_amount",
				"type": "tuple"
			},
			{
				"internalType": "uint256",
				"name": "_interest",
				"type": "uint256"
			},
			{
				"internalType": "enum RateType",
				"name": "_rateType",
				"type": "uint8"
			},
			{
				"internalType": "uint256",
				"name": "_expiryDate",
				"type": "uint256"
			}
		],
		"name": "setRate",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_success",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_voteMultiple",
				"type": "uint256"
			}
		],
		"name": "setVoteMultiple",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_success",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanAmountMin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_loanAmountMax",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_minVotes",
				"type": "uint256"
			}
		],
		"name": "setVoteThreshold",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_voteThresholdId",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanRequestId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_votes",
				"type": "uint256"
			}
		],
		"name": "voteForLoanApproval",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_success",
				"type": "bool"
			}
		],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_savingsId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "withdraw",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "_txId",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_loanRequestId",
				"type": "uint256"
			}
		],
		"name": "withdrawLoanRequest",
		"outputs": [
			{
				"internalType": "bool",
				"name": "_cancelled",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];