import { useWeb3 } from '@/contexts/Web3Context';
import { parseUnits, formatUnits } from 'ethers';
import { toast } from 'sonner';

export const useContract = () => {
  const { contract, isConnected } = useWeb3();

  const checkConnection = () => {
    if (!isConnected || !contract) {
      toast.error('Please connect your wallet first');
      return false;
    }
    return true;
  };

  // Savings functions
  const getSavingsId = async () => {
    if (!checkConnection()) return null;
    try {
      const savingsId = await contract!.getSavingsId();
      return Number(savingsId);
    } catch (error) {
      console.error('Error getting savings ID:', error);
      return null;
    }
  };

  const getSavings = async (savingsId: number) => {
    if (!checkConnection()) return null;
    try {
      const savings = await contract!.getSavings(savingsId);
      return {
        id: Number(savings.id),
        balance: formatUnits(savings.balance, 6), // USDC has 6 decimals
        owner: savings.owner,
        votes: Number(savings.votes)
      };
    } catch (error) {
      console.error('Error getting savings:', error);
      return null;
    }
  };

  const deposit = async (savingsId: number, amount: string) => {
    if (!checkConnection()) return null;
    try {
      const amountInWei = parseUnits(amount, 6);
      const tx = await contract!.deposit(savingsId, amountInWei);
      await tx.wait();
      toast.success('Deposit successful');
      return tx.hash;
    } catch (error: any) {
      console.error('Error depositing:', error);
      toast.error(error.message || 'Deposit failed');
      return null;
    }
  };

  const withdraw = async (savingsId: number, amount: string) => {
    if (!checkConnection()) return null;
    try {
      const amountInWei = parseUnits(amount, 6);
      const tx = await contract!.withdraw(savingsId, amountInWei);
      await tx.wait();
      toast.success('Withdrawal successful');
      return tx.hash;
    } catch (error: any) {
      console.error('Error withdrawing:', error);
      toast.error(error.message || 'Withdrawal failed');
      return null;
    }
  };

  // Loan Request functions
  const getLoanRequestIds = async () => {
    if (!checkConnection()) return [];
    try {
      const ids = await contract!.getLoanRequestIds();
      return ids.map((id: bigint) => Number(id));
    } catch (error) {
      console.error('Error getting loan request IDs:', error);
      return [];
    }
  };

  const getLoanRequest = async (loanRequestId: number) => {
    if (!checkConnection()) return null;
    try {
      const request = await contract!.getLoanRequest(loanRequestId);
      return {
        id: Number(request.id),
        amount: formatUnits(request.amount, 6),
        interest: Number(request.interest),
        maturity: Number(request.maturity),
        borrower: request.borrower,
        purpose: request.purpose,
        votes: Number(request.votes),
        approved: request.approved
      };
    } catch (error) {
      console.error('Error getting loan request:', error);
      return null;
    }
  };

  const requestLoan = async (amount: string, interest: number, maturity: number, purpose: string) => {
    if (!checkConnection()) return null;
    try {
      const amountInWei = parseUnits(amount, 6);
      const loanRequest = {
        amount: amountInWei,
        interest,
        maturity,
        purpose
      };
      const tx = await contract!.requestLoan(loanRequest);
      await tx.wait();
      toast.success('Loan request submitted');
      return tx.hash;
    } catch (error: any) {
      console.error('Error requesting loan:', error);
      toast.error(error.message || 'Loan request failed');
      return null;
    }
  };

  const withdrawLoanRequest = async (loanRequestId: number) => {
    if (!checkConnection()) return false;
    try {
      const tx = await contract!.withdrawLoanRequest(loanRequestId);
      await tx.wait();
      toast.success('Loan request withdrawn');
      return true;
    } catch (error: any) {
      console.error('Error withdrawing loan request:', error);
      toast.error(error.message || 'Withdrawal failed');
      return false;
    }
  };

  // Voting functions
  const voteForLoanApproval = async (loanRequestId: number, votes: number) => {
    if (!checkConnection()) return false;
    try {
      const tx = await contract!.voteForLoanApproval(loanRequestId, votes);
      await tx.wait();
      toast.success('Vote submitted');
      return true;
    } catch (error: any) {
      console.error('Error voting:', error);
      toast.error(error.message || 'Vote failed');
      return false;
    }
  };

  const recindVoteForLoanApproval = async (loanRequestId: number) => {
    if (!checkConnection()) return false;
    try {
      const tx = await contract!.recindVoteForLoanApproval(loanRequestId);
      await tx.wait();
      toast.success('Vote rescinded');
      return true;
    } catch (error: any) {
      console.error('Error rescinding vote:', error);
      toast.error(error.message || 'Rescind failed');
      return false;
    }
  };

  const getVoteThresholdIds = async () => {
    if (!checkConnection()) return [];
    try {
      const ids = await contract!.getVoteThresholdIds();
      return ids.map((id: bigint) => Number(id));
    } catch (error) {
      console.error('Error getting vote threshold IDs:', error);
      return [];
    }
  };

  const getVoteThreshold = async (thresholdId: number) => {
    if (!checkConnection()) return null;
    try {
      const threshold = await contract!.getVoteThreshold(thresholdId);
      return {
        id: Number(threshold.id),
        loanAmount: formatUnits(threshold.loanAmount, 6),
        approvalVotes: Number(threshold.approvalVotes)
      };
    } catch (error) {
      console.error('Error getting vote threshold:', error);
      return null;
    }
  };

  // Membership functions
  const joinUnion = async (initialDeposit: string) => {
    if (!checkConnection()) return null;
    try {
      const amountInWei = parseUnits(initialDeposit, 6);
      const tx = await contract!.joinUnion(amountInWei);
      await tx.wait();
      toast.success('Successfully joined the union');
      return tx.hash;
    } catch (error: any) {
      console.error('Error joining union:', error);
      toast.error(error.message || 'Failed to join union');
      return null;
    }
  };

  const leaveUnion = async () => {
    if (!checkConnection()) return null;
    try {
      const tx = await contract!.leaveUnion();
      await tx.wait();
      toast.success('Successfully left the union');
      return tx.hash;
    } catch (error: any) {
      console.error('Error leaving union:', error);
      toast.error(error.message || 'Failed to leave union');
      return null;
    }
  };

  return {
    getSavingsId,
    getSavings,
    deposit,
    withdraw,
    getLoanRequestIds,
    getLoanRequest,
    requestLoan,
    withdrawLoanRequest,
    voteForLoanApproval,
    recindVoteForLoanApproval,
    getVoteThresholdIds,
    getVoteThreshold,
    joinUnion,
    leaveUnion
  };
};
