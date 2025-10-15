import { DashboardLayout } from "@/components/DashboardLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { ArrowDownCircle, ArrowUpCircle, Wallet, TrendingUp } from "lucide-react";
import { MetricCard } from "@/components/MetricCard";
import { useState, useEffect } from "react";
import { useContract } from "@/hooks/useContract";
import { useWeb3 } from "@/contexts/Web3Context";

const Savings = () => {
  const { isConnected } = useWeb3();
  const { getSavingsId, getSavings, deposit, withdraw } = useContract();
  const [depositAmount, setDepositAmount] = useState("");
  const [withdrawAmount, setWithdrawAmount] = useState("");
  const [savingsData, setSavingsData] = useState<any>(null);
  const [savingsId, setSavingsId] = useState<number | null>(null);

  useEffect(() => {
    if (isConnected) {
      loadSavings();
    }
  }, [isConnected]);

  const loadSavings = async () => {
    const id = await getSavingsId();
    if (id !== null) {
      setSavingsId(id);
      const savings = await getSavings(id);
      setSavingsData(savings);
    }
  };

  const handleDeposit = async () => {
    if (!depositAmount || savingsId === null) {
      return;
    }
    await deposit(savingsId, depositAmount);
    setDepositAmount("");
    loadSavings();
  };

  const handleWithdraw = async () => {
    if (!withdrawAmount || savingsId === null) {
      return;
    }
    await withdraw(savingsId, withdrawAmount);
    setWithdrawAmount("");
    loadSavings();
  };

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="glass-card p-6 rounded-xl">
          <h2 className="text-3xl font-bold mb-2 gradient-text">Savings Management</h2>
          <p className="text-muted-foreground">
            Manage your savings deposits and withdrawals
          </p>
        </div>

        {/* Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <MetricCard
            title="Total Balance"
            value={savingsData ? `${parseFloat(savingsData.balance).toFixed(2)} USDC` : "0 USDC"}
            icon={Wallet}
            subtitle="Current savings balance"
          />
          <MetricCard
            title="Voting Power"
            value={savingsData ? savingsData.votes.toString() : "0"}
            icon={TrendingUp}
            subtitle="Based on your savings"
          />
          <MetricCard
            title="Interest Earned"
            value="450 USDC"
            icon={ArrowUpCircle}
            trend={{ value: "12.3%", isPositive: true }}
            subtitle="Lifetime earnings"
          />
        </div>

        {/* Deposit and Withdraw */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Deposit Card */}
          <Card className="glass-card">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-2xl">
                <ArrowDownCircle className="h-6 w-6 text-green-500" />
                Deposit
              </CardTitle>
              <p className="text-sm text-muted-foreground">
                Add funds to your savings account
              </p>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="deposit-amount">Amount (USDC)</Label>
                <Input
                  id="deposit-amount"
                  type="number"
                  placeholder="0.00"
                  value={depositAmount}
                  onChange={(e) => setDepositAmount(e.target.value)}
                  className="text-lg"
                />
              </div>

              <Button 
                onClick={handleDeposit}
                className="w-full bg-green-600 hover:bg-green-700"
                disabled={!isConnected || !savingsId}
              >
                <ArrowDownCircle className="mr-2 h-4 w-4" />
                Deposit USDC
              </Button>
            </CardContent>
          </Card>

          {/* Withdraw Card */}
          <Card className="glass-card">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-2xl">
                <ArrowUpCircle className="h-6 w-6 text-red-500" />
                Withdraw
              </CardTitle>
              <p className="text-sm text-muted-foreground">
                Withdraw funds from your savings
              </p>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="withdraw-amount">Amount (USDC)</Label>
                <Input
                  id="withdraw-amount"
                  type="number"
                  placeholder="0.00"
                  value={withdrawAmount}
                  onChange={(e) => setWithdrawAmount(e.target.value)}
                  className="text-lg"
                />
                <p className="text-xs text-muted-foreground">
                  Savings balance: {savingsData ? parseFloat(savingsData.balance).toFixed(2) : "0"} USDC
                </p>
              </div>

              <Button 
                onClick={handleWithdraw}
                className="w-full bg-red-600 hover:bg-red-700"
                disabled={!isConnected || !savingsId}
              >
                <ArrowUpCircle className="mr-2 h-4 w-4" />
                Withdraw USDC
              </Button>
            </CardContent>
          </Card>
        </div>

        {/* Transaction History */}
        <Card className="glass-card">
          <CardHeader>
            <CardTitle className="text-2xl">Transaction History</CardTitle>
            <p className="text-sm text-muted-foreground">
              Your recent deposits and withdrawals
            </p>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {[
                { type: 'deposit', amount: '1,000 USDC', date: '2024-10-09', time: '14:32', hash: '0xabcd...1234' },
                { type: 'withdraw', amount: '500 USDC', date: '2024-10-08', time: '09:15', hash: '0xef12...5678' },
                { type: 'deposit', amount: '2,500 USDC', date: '2024-10-05', time: '16:45', hash: '0x9876...abcd' },
                { type: 'deposit', amount: '5,000 USDC', date: '2024-10-01', time: '11:20', hash: '0x5432...ef09' },
                { type: 'withdraw', amount: '300 USDC', date: '2024-09-28', time: '13:55', hash: '0x1357...2468' },
              ].map((tx, idx) => (
                <div 
                  key={idx} 
                  className="flex items-center justify-between p-4 rounded-lg border border-border/50 hover:bg-muted/50 transition-colors"
                >
                  <div className="flex items-center gap-4">
                    <div className={`h-10 w-10 rounded-full flex items-center justify-center ${
                      tx.type === 'deposit' ? 'bg-green-500/20' : 'bg-red-500/20'
                    }`}>
                      {tx.type === 'deposit' ? (
                        <ArrowDownCircle className="h-5 w-5 text-green-500" />
                      ) : (
                        <ArrowUpCircle className="h-5 w-5 text-red-500" />
                      )}
                    </div>
                    <div>
                      <p className="font-medium capitalize">{tx.type}</p>
                      <p className="text-sm text-muted-foreground">
                        {tx.date} at {tx.time}
                      </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className={`font-bold ${
                      tx.type === 'deposit' ? 'text-green-500' : 'text-red-500'
                    }`}>
                      {tx.type === 'deposit' ? '+' : '-'}{tx.amount}
                    </p>
                    <p className="text-xs text-muted-foreground font-mono">{tx.hash}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
};

export default Savings;
