import { DashboardLayout } from "@/components/DashboardLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Users, UserPlus, LogOut, Crown, Award, TrendingUp } from "lucide-react";
import { MetricCard } from "@/components/MetricCard";
import { useState, useEffect } from "react";
import { useContract } from "@/hooks/useContract";
import { useWeb3 } from "@/contexts/Web3Context";
import {
  Alert,
  AlertDescription,
  AlertTitle,
} from "@/components/ui/alert";

const Membership = () => {
  const { isConnected } = useWeb3();
  const { joinUnion, leaveUnion, getSavingsId, getSavings } = useContract();
  const [depositAmount, setDepositAmount] = useState("");
  const [isMember, setIsMember] = useState(false);
  const [savingsData, setSavingsData] = useState<any>(null);

  useEffect(() => {
    if (isConnected) {
      checkMembership();
    }
  }, [isConnected]);

  const checkMembership = async () => {
    const savingsId = await getSavingsId();
    if (savingsId !== null) {
      setIsMember(true);
      const savings = await getSavings(savingsId);
      setSavingsData(savings);
    } else {
      setIsMember(false);
    }
  };

  const handleJoinUnion = async () => {
    if (!depositAmount) {
      return;
    }
    await joinUnion(depositAmount);
    setDepositAmount("");
    checkMembership();
  };

  const handleLeaveUnion = async () => {
    await leaveUnion();
    checkMembership();
  };

  const memberStats = {
    isMember,
    savingsId: savingsData?.id || '0',
    totalContributed: savingsData ? `${parseFloat(savingsData.balance).toFixed(2)} USDC` : '0 USDC',
  };

  const topMembers = [
    { address: '0xabcd...1234', contribution: '125,000 USDC', votes: 342, tier: 'Diamond' },
    { address: '0xef12...5678', contribution: '98,500 USDC', votes: 287, tier: 'Platinum' },
    { address: '0x5432...9abc', contribution: '75,200 USDC', votes: 234, tier: 'Platinum' },
    { address: '0x1111...2222', contribution: '52,800 USDC', votes: 189, tier: 'Gold' },
    { address: '0x3333...4444', contribution: '45,600 USDC', votes: 156, tier: 'Gold' },
  ];

  const tiers = [
    { name: 'Bronze', minSavings: '0', votingPower: '1x', color: 'bg-orange-700/20 text-orange-700' },
    { name: 'Silver', minSavings: '5,000', votingPower: '1.2x', color: 'bg-gray-400/20 text-gray-400' },
    { name: 'Gold', minSavings: '10,000', votingPower: '1.5x', color: 'bg-yellow-500/20 text-yellow-500' },
    { name: 'Platinum', minSavings: '50,000', votingPower: '2x', color: 'bg-cyan-400/20 text-cyan-400' },
    { name: 'Diamond', minSavings: '100,000', votingPower: '3x', color: 'bg-purple-400/20 text-purple-400' },
  ];

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="glass-card p-6 rounded-xl">
          <h2 className="text-3xl font-bold mb-2 gradient-text">Union Membership</h2>
          <p className="text-muted-foreground">
            Manage your membership and view community statistics
          </p>
        </div>

        {/* Membership Status */}
        {memberStats.isMember ? (
          <Alert className="glass-card border-primary/50">
            <Crown className="h-5 w-5 text-primary" />
            <AlertTitle className="text-lg">Active Member</AlertTitle>
            <AlertDescription>
              Savings ID: #{memberStats.savingsId}
            </AlertDescription>
          </Alert>
        ) : (
          <Alert className="glass-card border-accent/50">
            <UserPlus className="h-5 w-5 text-accent" />
            <AlertTitle className="text-lg">Join RealFi Union</AlertTitle>
            <AlertDescription>
              Become a member to access loans, earn interest, and participate in governance
            </AlertDescription>
          </Alert>
        )}

        {/* Member Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <MetricCard
            title="Total Contributed"
            value={memberStats.totalContributed}
            icon={TrendingUp}
            subtitle="Lifetime savings"
          />
          <MetricCard
            title="Voting Power"
            value={savingsData ? savingsData.votes.toString() : "0"}
            icon={Users}
            subtitle="Based on savings"
          />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Membership Actions */}
          <Card className="glass-card">
            <CardHeader>
              <CardTitle className="text-2xl">Membership Actions</CardTitle>
              <p className="text-sm text-muted-foreground">
                Manage your union membership
              </p>
            </CardHeader>
            <CardContent className="space-y-4">
              {memberStats.isMember ? (
                <>
                  <div className="p-4 rounded-lg bg-muted/50">
                    <h4 className="font-semibold mb-2">Your Benefits</h4>
                    <ul className="space-y-2 text-sm">
                      <li className="flex items-center gap-2">
                        <div className="h-1.5 w-1.5 rounded-full bg-primary" />
                        Access to low-interest loans
                      </li>
                      <li className="flex items-center gap-2">
                        <div className="h-1.5 w-1.5 rounded-full bg-primary" />
                        Earn interest on savings
                      </li>
                      <li className="flex items-center gap-2">
                        <div className="h-1.5 w-1.5 rounded-full bg-primary" />
                        Vote on loan approvals
                      </li>
                      <li className="flex items-center gap-2">
                        <div className="h-1.5 w-1.5 rounded-full bg-primary" />
                        Community governance rights
                      </li>
                    </ul>
                  </div>

                  <Button
                    variant="destructive"
                    className="w-full"
                    onClick={handleLeaveUnion}
                  >
                    <LogOut className="mr-2 h-4 w-4" />
                    Leave Union
                  </Button>
                  <p className="text-xs text-muted-foreground text-center">
                    Leaving will withdraw all your savings and forfeit voting rights
                  </p>
                </>
              ) : (
                <>
                  <div className="p-4 rounded-lg bg-primary/10">
                    <h4 className="font-semibold mb-2 text-primary">Join Today</h4>
                    <p className="text-sm text-muted-foreground mb-4">
                      Start with an initial deposit to become a union member
                    </p>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="initial-deposit">Initial Deposit (USDC)</Label>
                    <Input
                      id="initial-deposit"
                      type="number"
                      placeholder="100"
                      value={depositAmount}
                      onChange={(e) => setDepositAmount(e.target.value)}
                    />
                  </div>

                  <Button
                    className="w-full bg-primary hover:bg-primary/90"
                    onClick={handleJoinUnion}
                    disabled={!isConnected || !depositAmount}
                  >
                    <UserPlus className="mr-2 h-4 w-4" />
                    Join Union
                  </Button>
                </>
              )}
            </CardContent>
          </Card>

        </div>

        {/* Top Members Leaderboard */}
        <Card className="glass-card">
          <CardHeader>
            <CardTitle className="text-2xl">Top Contributors</CardTitle>
            <p className="text-sm text-muted-foreground">
              Leading members of the union community
            </p>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {topMembers.map((member, idx) => (
                <div
                  key={member.address}
                  className="flex items-center justify-between p-4 rounded-lg border border-border/50 hover:bg-muted/50 transition-colors"
                >
                  <div className="flex items-center gap-4">
                    <div className={`h-10 w-10 rounded-full flex items-center justify-center ${
                      idx === 0 ? 'bg-yellow-500/20' :
                      idx === 1 ? 'bg-gray-400/20' :
                      idx === 2 ? 'bg-orange-700/20' :
                      'bg-primary/20'
                    }`}>
                      <span className="font-bold text-lg">
                        {idx + 1}
                      </span>
                    </div>
                    <div>
                      <p className="font-medium font-mono">{member.address}</p>
                      <p className="text-sm text-muted-foreground">
                        {member.votes} votes cast
                      </p>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="font-bold gradient-text">{member.contribution}</p>
                    <Badge className={
                      member.tier === 'Diamond' ? 'bg-purple-400/20 text-purple-400' :
                      member.tier === 'Platinum' ? 'bg-cyan-400/20 text-cyan-400' :
                      'bg-yellow-500/20 text-yellow-500'
                    }>
                      {member.tier}
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Union Statistics */}
        <Card className="glass-card">
          <CardHeader>
            <CardTitle className="text-2xl">Union Statistics</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              <div className="text-center">
                <p className="text-3xl font-bold gradient-text">847</p>
                <p className="text-sm text-muted-foreground mt-1">Total Members</p>
              </div>
              <div className="text-center">
                <p className="text-3xl font-bold gradient-text">2.4M</p>
                <p className="text-sm text-muted-foreground mt-1">Total Savings (USDC)</p>
              </div>
              <div className="text-center">
                <p className="text-3xl font-bold gradient-text">1,234</p>
                <p className="text-sm text-muted-foreground mt-1">Loans Issued</p>
              </div>
              <div className="text-center">
                <p className="text-3xl font-bold gradient-text">5.8%</p>
                <p className="text-sm text-muted-foreground mt-1">Avg. Interest Rate</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
};

export default Membership;
