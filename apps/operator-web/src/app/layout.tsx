import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "YATRA — Delhi Accessible Transit Platform",
  description:
    "Universal public transit accessibility, operations, and intelligence platform. Move Delhi Together.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="h-full antialiased">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,400;0,600;0,700;0,800;0,900;1,400;1,600&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="min-h-full bg-[#F7F2E9] text-[#101B3A] flex flex-col font-sans selection:bg-[#E96835] selection:text-white">
        {children}
      </body>
    </html>
  );
}
