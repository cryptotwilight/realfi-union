export const CONTRACT_ADDRESS = "0x2aB95f6aeaB62F2D4691c770e89E1ca7067878B5";

export const BASE_CHAIN_ID = 8453; // Base mainnet

export const CONTRACT_ABI = [
  "function getUnionToken() view returns (address)",
  "function getRates() view returns (tuple(uint256 id, uint256 rate, string name)[])",
  "function getFeeNames() view returns (string[])",
  "function getFee(string memory) view returns (uint256)",
  "function getSavingsId() view returns (uint256)",
  "function getSavings(uint256) view returns (tuple(uint256 id, uint256 balance, address owner, uint256 votes))",
  "function deposit(uint256, uint256) payable returns (uint256)",
  "function withdraw(uint256, uint256) returns (uint256)",
  "function getTxIdsBySavingsId(uint256) view returns (uint256[])",
  "function getLoanRequestIds() view returns (uint256[])",
  "function getLoanRequest(uint256) view returns (tuple(uint256 id, uint256 amount, uint256 interest, uint256 maturity, address borrower, string purpose, uint256 votes, bool approved))",
  "function isApproved(uint256) view returns (bool)",
  "function requestLoan(tuple(uint256 amount, uint256 interest, uint256 maturity, string purpose)) payable returns (uint256)",
  "function withdrawLoanRequest(uint256) returns (bool)",
  "function getLoanId(uint256) view returns (uint256)",
  "function getLoanStakeIds() view returns (uint256[])",
  "function getLoanStakeById(uint256) view returns (tuple(uint256 id, uint256 loanId, uint256 amount, address staker))",
  "function getLoan(uint256) view returns (tuple(uint256 id, uint256 amount, uint256 interest, uint256 maturity, uint256 balance, address borrower, bool active))",
  "function cancellLoan(uint256) returns (bool)",
  "function drawDownLoan(uint256) returns (uint256)",
  "function repayLoan(uint256, uint256) payable returns (uint256)",
  "function getVoteThresholdIds() view returns (uint256[])",
  "function getVoteThreshold(uint256) view returns (tuple(uint256 id, uint256 loanAmount, uint256 approvalVotes))",
  "function voteForLoanApproval(uint256, uint256) payable returns (bool)",
  "function recindVoteForLoanApproval(uint256) payable returns (bool)",
  "function joinUnion(uint256) payable returns (uint256)",
  "function leaveUnion() returns (uint256)"
];
