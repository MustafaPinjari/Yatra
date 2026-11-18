import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "YATRA Operator Command | Accessible Transit & Fleet Intelligence",
  description:
    "Universal municipal bus accessibility, passenger assistance, and real-time fleet operations management platform.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="h-full antialiased">
      <body className="min-h-full bg-slate-50 text-slate-900 flex flex-col font-sans selection:bg-indigo-500 selection:text-white">
        {children}
      </body>
    </html>
  );
}
