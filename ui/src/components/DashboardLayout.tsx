import { ReactNode } from "react";
import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { AppSidebar } from "@/components/AppSidebar";
import { Button } from "@/components/ui/button";
import { useWeb3 } from "@/contexts/Web3Context";
import { Menu, Wallet } from "lucide-react";

interface DashboardLayoutProps {
  children: ReactNode;
}

export function DashboardLayout({ children }: DashboardLayoutProps) {
  const { account, connectWallet, disconnectWallet, isConnected } = useWeb3();

  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full">
        <AppSidebar />
        <main className="flex-1">
          <header className="h-16 border-b border-border/50 backdrop-blur-xl bg-background/40 sticky top-0 z-10 flex items-center px-6">
            <SidebarTrigger className="mr-4">
              <Menu className="h-5 w-5" />
            </SidebarTrigger>
            <div className="flex items-center justify-between w-full">
              <div>
                <h1 className="text-2xl font-bold gradient-text">Web3 Credit Union</h1>
              </div>
              <div className="flex items-center gap-4">
                {isConnected ? (
                  <>
                    <div className="px-4 py-2 rounded-lg glass-card">
                      <span className="text-sm text-muted-foreground">Wallet:</span>
                      <span className="ml-2 text-sm font-mono">{account?.slice(0, 6)}...{account?.slice(-4)}</span>
                    </div>
                    <Button variant="outline" onClick={disconnectWallet} size="sm">
                      Disconnect
                    </Button>
                  </>
                ) : (
                  <Button onClick={connectWallet} className="bg-primary hover:bg-primary/90">
                    <Wallet className="mr-2 h-4 w-4" />
                    Connect Wallet
                  </Button>
                )}
              </div>
            </div>
          </header>
          <div className="p-6">
            {children}
          </div>
        </main>
      </div>
    </SidebarProvider>
  );
}
