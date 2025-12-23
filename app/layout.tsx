import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Magna Coders",
  description: "Waiting for the start...",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="bg-black text-white">
      <body className="antialiased">{children}</body>
    </html>
  );
}
