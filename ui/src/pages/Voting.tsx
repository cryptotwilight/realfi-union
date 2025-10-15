import { DashboardLayout } from "@/components/DashboardLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { ThumbsUp, ThumbsDown, Vote as VoteIcon, TrendingUp } from "lucide-react";
import { MetricCard } from "@/components/MetricCard";
import { useContract } from "@/hooks/useContract";
import { useWeb3 } from "@/contexts/Web3Context";
import { useState, useEffect } from "react";

const Voting = () => {
  const { isConnected } = useWeb3();
  const { getLoanRequestIds, getLoanRequest, voteForLoanApproval, recindVoteForLoanApproval, getSavingsId, getSavings } = useContract();
  const [pendingRequests, setPendingRequests] = useState<any[]>([]);
  const [votingPower, setVotingPower] = useState(0);
  const [voteAmounts, setVoteAmounts] = useState<{ [key: string]: string }>({});

  useEffect(() => {
    if (isConnected) {
      loadPendingRequests();
      loadVotingPower();
    }
  }, [isConnected]);

  const loadVotingPower = async () => {
    const savingsId = await getSavingsId();
    if (savingsId !== null) {
      const savings = await getSavings(savingsId);
      if (savings) {
        setVotingPower(savings.votes);
      }
    }
  };

  const loadPendingRequests = async () => {
    const ids = await getLoanRequestIds();
    const requests = await Promise.all(
      ids.map(async (id) => {
        const request = await getLoanRequest(id);
        return request;
      })
    );
    setPendingRequests(requests.filter(r => r && !r.approved));
  };

  const handleVote = async (requestId: number) => {
    const votes = parseInt(voteAmounts[requestId] || "1");
    if (votes <= 0) {
      return;
    }
    const success = await voteForLoanApproval(requestId, votes);
    if (success) {
      loadPendingRequests();
      loadVotingPower();
    }
  };

  const handleRecindVote = async (requestId: number) => {
    const success = await recindVoteForLoanApproval(requestId);
    if (success) {
      loadPendingRequests();
      loadVotingPower();
    }
  };


  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="glass-card p-6 rounded-xl">
          <h2 className="text-3xl font-bold mb-2 gradient-text">Voting Dashboard</h2>
          <p className="text-muted-foreground">
            Vote on loan requests and manage your voting power
          </p>
        </div>

        {/* Voting Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <MetricCard
            title="Voting Power"
            value={votingPower.toString()}
            icon={VoteIcon}
            subtitle="Based on savings"
          />
          <MetricCard
            title="Votes Cast"
            value="47"
            icon={TrendingUp}
            trend={{ value: "8", isPositive: true }}
            subtitle="Lifetime total"
          />
          <MetricCard
            title="Pending Requests"
            value={pendingRequests.length.toString()}
            icon={ThumbsUp}
            subtitle="Currently pending"
          />
        </div>

        <Tabs defaultValue="pending" className="w-full">
          <TabsList className="grid w-full grid-cols-2 glass-card">
            <TabsTrigger value="pending">
              <VoteIcon className="h-4 w-4 mr-2" />
              Pending Requests
            </TabsTrigger>
            <TabsTrigger value="my-votes">
              <ThumbsUp className="h-4 w-4 mr-2" />
              My Votes
            </TabsTrigger>
          </TabsList>

          <TabsContent value="pending" className="space-y-6">
            <div className="grid grid-cols-1 gap-4">
              {pendingRequests.map((request) => (
                <Card key={request.id} className="glass-card hover:glow-primary transition-all duration-300">
                  <CardHeader>
                    <div className="flex items-start justify-between">
                      <div>
                        <CardTitle className="text-xl">Request #{request.id}</CardTitle>
                        <p className="text-sm text-muted-foreground mt-1">
                          Borrower: <span className="font-mono">{request.borrower}</span>
                        </p>
                      </div>
                      <Badge className="bg-yellow-500/20 text-yellow-500">
                        Voting Active
                      </Badge>
                    </div>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                      <div>
                        <p className="text-sm text-muted-foreground">Amount</p>
                        <p className="text-lg font-bold">{request.amount}</p>
                      </div>
                      <div>
                        <p className="text-sm text-muted-foreground">Interest</p>
                        <p className="text-lg font-bold text-accent">{request.interest}</p>
                      </div>
                      <div>
                        <p className="text-sm text-muted-foreground">Maturity</p>
                        <p className="text-sm font-medium">{request.maturity}</p>
                      </div>
                      <div>
                        <p className="text-sm text-muted-foreground">Votes Progress</p>
                        <p className="text-sm font-medium">
                          {request.votes} / {request.required}
                        </p>
                      </div>
                    </div>

                    <div className="p-4 rounded-lg bg-muted/50">
                      <p className="text-sm font-medium mb-1">Purpose:</p>
                      <p className="text-sm text-muted-foreground">{request.purpose}</p>
                    </div>

                    <div className="space-y-2">
                      <div className="flex items-center justify-between text-sm">
                        <span className="text-muted-foreground">Approval Progress</span>
                        <span className="font-medium">
                          {Math.round((request.votes / request.required) * 100)}%
                        </span>
                      </div>
                      <div className="w-full bg-muted rounded-full h-3">
                        <div
                          className="bg-primary h-3 rounded-full transition-all duration-300"
                          style={{ width: `${(request.votes / request.required) * 100}%` }}
                        />
                      </div>
                    </div>

                    <div className="space-y-3">
                      <div className="space-y-2">
                        <Label htmlFor={`votes-${request.id}`}>Number of Votes</Label>
                        <Input
                          id={`votes-${request.id}`}
                          type="number"
                          min="1"
                          max={votingPower}
                          placeholder="1"
                          value={voteAmounts[request.id] || ""}
                          onChange={(e) => setVoteAmounts({ ...voteAmounts, [request.id]: e.target.value })}
                        />
                      </div>
                      <div className="flex gap-2">
                        <Button 
                          className="flex-1 bg-primary hover:bg-primary/90"
                          onClick={() => handleVote(request.id)}
                          disabled={!voteAmounts[request.id] || parseInt(voteAmounts[request.id]) <= 0}
                        >
                          <ThumbsUp className="h-4 w-4 mr-2" />
                          Vote to Approve
                        </Button>
                        <Button 
                          variant="outline" 
                          className="border-destructive/50 hover:bg-destructive/10"
                          onClick={() => handleRecindVote(request.id)}
                        >
                          <ThumbsDown className="h-4 w-4 mr-2" />
                          Rescind Vote
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="my-votes" className="space-y-6">
            {/* Vote Thresholds */}
            <Card className="glass-card">
              <CardHeader>
                <CardTitle className="text-2xl">Vote Thresholds</CardTitle>
                <p className="text-sm text-muted-foreground">
                  Required votes based on loan amount
                </p>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {[
                    { range: '< 5,000 USDC', votes: 50 },
                    { range: '5,000 - 10,000 USDC', votes: 100 },
                    { range: '10,000 - 20,000 USDC', votes: 150 },
                    { range: '> 20,000 USDC', votes: 200 }
                  ].map((threshold, idx) => (
                    <div
                      key={idx}
                      className="flex items-center justify-between p-3 rounded-lg bg-muted/50"
                    >
                      <span className="font-medium">{threshold.range}</span>
                      <Badge className="bg-primary/20 text-primary">
                        {threshold.votes} votes required
                      </Badge>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </DashboardLayout>
  );
};

export default Voting;
