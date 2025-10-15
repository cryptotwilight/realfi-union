import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ThumbsUp, Clock, CheckCircle2 } from "lucide-react";

interface LoanRequestCardProps {
  id: string;
  amount: string;
  interest: string;
  maturity: string;
  borrower: string;
  votes: number;
  required: number;
  status: 'pending' | 'approved' | 'rejected';
}

export function LoanRequestCard({
  id,
  amount,
  interest,
  maturity,
  borrower,
  votes,
  required,
  status
}: LoanRequestCardProps) {
  const statusColors = {
    pending: 'bg-muted text-muted-foreground',
    approved: 'bg-green-500/20 text-green-500',
    rejected: 'bg-destructive/20 text-destructive'
  };

  const statusIcons = {
    pending: Clock,
    approved: CheckCircle2,
    rejected: Clock
  };

  const StatusIcon = statusIcons[status];

  return (
    <Card className="glass-card hover:glow-primary transition-all duration-300">
      <CardHeader>
        <div className="flex items-start justify-between">
          <div>
            <CardTitle className="text-lg">Request #{id}</CardTitle>
            <p className="text-sm text-muted-foreground mt-1">
              Borrower: <span className="font-mono">{borrower}</span>
            </p>
          </div>
          <Badge className={statusColors[status]}>
            <StatusIcon className="h-3 w-3 mr-1" />
            {status}
          </Badge>
        </div>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-2 gap-4 mb-4">
          <div>
            <p className="text-sm text-muted-foreground">Amount</p>
            <p className="text-xl font-bold text-foreground">{amount}</p>
          </div>
          <div>
            <p className="text-sm text-muted-foreground">Interest</p>
            <p className="text-xl font-bold text-accent">{interest}</p>
          </div>
          <div>
            <p className="text-sm text-muted-foreground">Maturity</p>
            <p className="text-sm font-medium text-foreground">{maturity}</p>
          </div>
          <div>
            <p className="text-sm text-muted-foreground">Votes</p>
            <p className="text-sm font-medium text-foreground">
              {votes} / {required}
            </p>
          </div>
        </div>
        
        <div className="w-full bg-muted rounded-full h-2 mb-4">
          <div
            className="bg-primary h-2 rounded-full transition-all duration-300"
            style={{ width: `${(votes / required) * 100}%` }}
          />
        </div>

        {status === 'pending' && (
          <div className="flex gap-2">
            <Button className="flex-1 bg-primary hover:bg-primary/90">
              <ThumbsUp className="h-4 w-4 mr-2" />
              Vote to Approve
            </Button>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
