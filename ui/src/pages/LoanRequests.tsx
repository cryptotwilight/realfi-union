import { DashboardLayout } from "@/components/DashboardLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { FileText, Plus, Clock, CheckCircle2, XCircle } from "lucide-react";
import { useState, useEffect } from "react";
import { useContract } from "@/hooks/useContract";
import { useWeb3 } from "@/contexts/Web3Context";

const LoanRequests = () => {
  const { isConnected } = useWeb3();
  const { requestLoan, getLoanRequestIds, getLoanRequest, withdrawLoanRequest } = useContract();
  const [loanAmount, setLoanAmount] = useState("");
  const [interestRate, setInterestRate] = useState("");
  const [maturityMonths, setMaturityMonths] = useState("");
  const [purpose, setPurpose] = useState("");
  const [myRequests, setMyRequests] = useState<any[]>([]);

  useEffect(() => {
    if (isConnected) {
      loadMyRequests();
    }
  }, [isConnected]);

  const loadMyRequests = async () => {
    const ids = await getLoanRequestIds();
    const requests = await Promise.all(
      ids.map(async (id) => {
        const request = await getLoanRequest(id);
        return request;
      })
    );
    setMyRequests(requests.filter(r => r !== null));
  };

  const handleCreateRequest = async () => {
    if (!loanAmount || !interestRate || !maturityMonths || !purpose) {
      return;
    }
    await requestLoan(loanAmount, parseFloat(interestRate) * 100, parseInt(maturityMonths), purpose);
    setLoanAmount("");
    setInterestRate("");
    setMaturityMonths("");
    setPurpose("");
    loadMyRequests();
  };

  const handleCancelRequest = async (requestId: number) => {
    await withdrawLoanRequest(requestId);
    loadMyRequests();
  };

  const getStatusConfig = (approved: boolean) => {
    if (approved) {
      return { color: 'bg-green-500/20 text-green-500', icon: CheckCircle2, label: 'approved' };
    }
    return { color: 'bg-yellow-500/20 text-yellow-500', icon: Clock, label: 'pending' };
  };

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="glass-card p-6 rounded-xl">
          <h2 className="text-3xl font-bold mb-2 gradient-text">Loan Requests</h2>
          <p className="text-muted-foreground">
            Create and manage your loan requests
          </p>
        </div>

        <Tabs defaultValue="create" className="w-full">
          <TabsList className="grid w-full grid-cols-2 glass-card">
            <TabsTrigger value="create">
              <Plus className="h-4 w-4 mr-2" />
              Create Request
            </TabsTrigger>
            <TabsTrigger value="my-requests">
              <FileText className="h-4 w-4 mr-2" />
              My Requests
            </TabsTrigger>
          </TabsList>

          <TabsContent value="create" className="space-y-6">
            <Card className="glass-card">
              <CardHeader>
                <CardTitle className="text-2xl">Create Loan Request</CardTitle>
                <p className="text-sm text-muted-foreground">
                  Submit a new loan request to the union members
                </p>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="space-y-2">
                    <Label htmlFor="loan-amount">Loan Amount (USDC)</Label>
                    <Input
                      id="loan-amount"
                      type="number"
                      placeholder="10,000"
                      value={loanAmount}
                      onChange={(e) => setLoanAmount(e.target.value)}
                    />
                    <p className="text-xs text-muted-foreground">
                      Maximum: 50,000 USDC based on union funds
                    </p>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="interest-rate">Interest Rate (%)</Label>
                    <Input
                      id="interest-rate"
                      type="number"
                      step="0.1"
                      placeholder="5.5"
                      value={interestRate}
                      onChange={(e) => setInterestRate(e.target.value)}
                    />
                    <p className="text-xs text-muted-foreground">
                      Suggested: 4% - 8% APR
                    </p>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="maturity">Maturity Period (months)</Label>
                    <Input
                      id="maturity"
                      type="number"
                      placeholder="12"
                      value={maturityMonths}
                      onChange={(e) => setMaturityMonths(e.target.value)}
                    />
                    <p className="text-xs text-muted-foreground">
                      6 - 36 months available
                    </p>
                  </div>

                  <div className="space-y-2">
                    <Label>Required Votes</Label>
                    <div className="p-3 rounded-lg bg-muted">
                      <p className="text-lg font-bold text-primary">
                        {loanAmount && parseFloat(loanAmount) >= 10000 ? '150' : '100'} votes
                      </p>
                      <p className="text-xs text-muted-foreground">
                        Based on loan amount
                      </p>
                    </div>
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="purpose">Loan Purpose</Label>
                  <Textarea
                    id="purpose"
                    placeholder="Describe the purpose of this loan..."
                    value={purpose}
                    onChange={(e) => setPurpose(e.target.value)}
                    rows={4}
                  />
                  <p className="text-xs text-muted-foreground">
                    Provide details to help members make an informed decision
                  </p>
                </div>

                <div className="p-4 rounded-lg bg-accent/10 border border-accent/20">
                  <h4 className="font-semibold mb-2 text-accent">Request Summary</h4>
                  <div className="grid grid-cols-2 gap-2 text-sm">
                    <div>
                      <span className="text-muted-foreground">Amount:</span>
                      <span className="ml-2 font-medium">{loanAmount || '0'} USDC</span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">Interest:</span>
                      <span className="ml-2 font-medium">{interestRate || '0'}% APR</span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">Total Repayment:</span>
                      <span className="ml-2 font-medium">
                        {loanAmount && interestRate 
                          ? (parseFloat(loanAmount) * (1 + parseFloat(interestRate) / 100)).toFixed(2)
                          : '0'} USDC
                      </span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">Duration:</span>
                      <span className="ml-2 font-medium">{maturityMonths || '0'} months</span>
                    </div>
                  </div>
                </div>

                <Button 
                  onClick={handleCreateRequest}
                  className="w-full bg-primary hover:bg-primary/90"
                >
                  <Plus className="mr-2 h-4 w-4" />
                  Submit Loan Request
                </Button>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="my-requests" className="space-y-6">
            <div className="grid grid-cols-1 gap-4">
              {myRequests.map((request) => {
                const config = getStatusConfig(request.approved);
                const StatusIcon = config.icon;

                return (
                  <Card key={request.id} className="glass-card hover:glow-primary transition-all duration-300">
                    <CardHeader>
                      <div className="flex items-start justify-between">
                        <div>
                          <CardTitle className="text-xl">Request #{request.id}</CardTitle>
                          <p className="text-sm text-muted-foreground mt-1">
                            Borrower: {request.borrower}
                          </p>
                        </div>
                        <Badge className={config.color}>
                          <StatusIcon className="h-3 w-3 mr-1" />
                          {config.label}
                        </Badge>
                      </div>
                    </CardHeader>
                    <CardContent>
                      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-4">
                        <div>
                          <p className="text-sm text-muted-foreground">Amount</p>
                          <p className="text-lg font-bold">{request.amount} USDC</p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">Interest</p>
                          <p className="text-lg font-bold text-accent">{(request.interest / 100).toFixed(2)}%</p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">Maturity</p>
                          <p className="text-sm font-medium">{request.maturity} months</p>
                        </div>
                        <div>
                          <p className="text-sm text-muted-foreground">Votes</p>
                          <p className="text-sm font-medium">{request.votes}</p>
                        </div>
                      </div>

                      <div className="p-4 rounded-lg bg-muted/50 mb-4">
                        <p className="text-sm font-medium mb-1">Purpose:</p>
                        <p className="text-sm text-muted-foreground">{request.purpose}</p>
                      </div>

                      {!request.approved && (
                        <Button 
                          variant="destructive" 
                          className="w-full"
                          onClick={() => handleCancelRequest(request.id)}
                        >
                          Cancel Request
                        </Button>
                      )}
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          </TabsContent>
        </Tabs>
      </div>
    </DashboardLayout>
  );
};

export default LoanRequests;
