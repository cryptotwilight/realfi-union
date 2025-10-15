import { DashboardLayout } from "@/components/DashboardLayout";
import { MetricCard } from "@/components/MetricCard";
import { LoanRequestCard } from "@/components/LoanRequestCard";
import { Wallet, TrendingUp, FileText, Users } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const Index = () => {
  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Hero Section */}
        <div className="glass-card p-8 rounded-xl">
          <h2 className="text-3xl font-bold mb-2">Welcome to RealFi Union</h2>
          <p className="text-muted-foreground mb-6">
            Your decentralized credit union for savings, loans, and community governance
          </p>
          <div className="flex gap-4">
            <Button className="bg-primary hover:bg-primary/90">
              Join Union
            </Button>
            <Button variant="outline" className="border-border hover:bg-muted">
              Learn More
            </Button>
          </div>
        </div>

        {/* Metrics Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <MetricCard
            title="Total Savings"
            value="12,450 USDC"
            icon={Wallet}
            trend={{ value: "12.5%", isPositive: true }}
            subtitle="Your contribution"
          />
          <MetricCard
            title="Active Loans"
            value="2"
            icon={FileText}
            subtitle="Currently borrowing"
          />
          <MetricCard
            title="Voting Power"
            value="125 Votes"
            icon={TrendingUp}
            trend={{ value: "5", isPositive: true }}
            subtitle="Based on savings"
          />
          <MetricCard
            title="Union Members"
            value="847"
            icon={Users}
            trend={{ value: "23", isPositive: true }}
            subtitle="Active participants"
          />
        </div>

        {/* Pending Loan Requests */}
        <Card className="glass-card">
          <CardHeader>
            <CardTitle className="text-2xl">Pending Loan Requests</CardTitle>
            <p className="text-sm text-muted-foreground">
              Vote on loan requests from union members
            </p>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <LoanRequestCard
                id="1234"
                amount="5,000 USDC"
                interest="5.2%"
                maturity="12 months"
                borrower="0xabcd...ef12"
                votes={45}
                required={100}
                status="pending"
              />
              <LoanRequestCard
                id="1235"
                amount="10,000 USDC"
                interest="6.8%"
                maturity="24 months"
                borrower="0x5678...9abc"
                votes={89}
                required={150}
                status="pending"
              />
              <LoanRequestCard
                id="1236"
                amount="2,500 USDC"
                interest="4.5%"
                maturity="6 months"
                borrower="0x1111...2222"
                votes={120}
                required={100}
                status="approved"
              />
              <LoanRequestCard
                id="1237"
                amount="7,500 USDC"
                interest="5.9%"
                maturity="18 months"
                borrower="0x3333...4444"
                votes={25}
                required={120}
                status="pending"
              />
            </div>
          </CardContent>
        </Card>

        {/* Recent Activity */}
        <Card className="glass-card">
          <CardHeader>
            <CardTitle className="text-2xl">Recent Activity</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {[
                { action: 'Deposited', amount: '1,000 USDC', time: '2 hours ago', type: 'deposit' },
                { action: 'Voted on Loan #1234', amount: '', time: '5 hours ago', type: 'vote' },
                { action: 'Loan #1230 Approved', amount: '3,500 USDC', time: '1 day ago', type: 'approval' },
                { action: 'Withdrew', amount: '500 USDC', time: '2 days ago', type: 'withdraw' },
              ].map((activity, idx) => (
                <div key={idx} className="flex items-center justify-between py-3 border-b border-border/50 last:border-0">
                  <div>
                    <p className="font-medium">{activity.action}</p>
                    <p className="text-sm text-muted-foreground">{activity.time}</p>
                  </div>
                  {activity.amount && (
                    <p className={`font-bold ${activity.type === 'deposit' ? 'text-green-500' : activity.type === 'withdraw' ? 'text-red-500' : 'text-accent'}`}>
                      {activity.type === 'withdraw' ? '-' : '+'}{activity.amount}
                    </p>
                  )}
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  );
};

export default Index;
