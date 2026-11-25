"use client";

import React from "react";
import { ShieldCheck, Hash, Check } from "lucide-react";

interface TrustRecordItem {
  id: string;
  type: string;
  entityId: string;
  sha256Hash: string;
  txHash: string;
  timestamp: string;
}

const sampleTrustRecords: TrustRecordItem[] = [
  {
    id: "TR-SEP-901",
    type: "Depot Accessibility Inspection",
    entityId: "DL 1PD 4421 (BBM Depot)",
    sha256Hash: "0x7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069",
    txHash: "0x3b89ef12a78129...89ac",
    timestamp: "18 Nov 2026, 08:30 IST",
  },
  {
    id: "TR-SEP-902",
    type: "Hydraulic Ramp Recertification",
    entityId: "DL 1PC 8902 (Wazirpur Depot)",
    sha256Hash: "0x12a88f7b32d0c242203a2c53a7b92f447a8291038472910a2839485720194827",
    txHash: "0x9812af7712ca89...01ba",
    timestamp: "17 Nov 2026, 17:15 IST",
  },
];

export function TrustVerificationBadge() {
  return (
    <div className="rounded-2xl border border-[#E6DDD0] bg-[#FFFCF7] p-6 shadow-editorial">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-[#E6DDD0] pb-4">
        <div className="flex items-center gap-3">
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-[#16764C]/10 text-[#16764C] border border-[#16764C]/25">
            <ShieldCheck className="h-5 w-5" aria-hidden="true" />
          </div>
          <div>
            <h2 className="font-editorial-serif text-lg font-bold text-[#101B3A]">
              Trust Ledger: Blockchain Audit Receipts
            </h2>
            <p className="text-xs text-[#64748B]">
              Cryptographic proof of depot accessibility inspections anchored on Ethereum Sepolia (Zero PII on-chain)
            </p>
          </div>
        </div>
        <span className="rounded-full bg-[#E4F1E5] border border-[#16764C]/30 px-3 py-1 text-xs font-semibold text-[#16764C] flex items-center gap-1.5 self-start sm:self-auto">
          <Check className="h-3.5 w-3.5" /> Sepolia verified
        </span>
      </div>

      <div className="mt-4 space-y-3">
        {sampleTrustRecords.map((record) => (
          <div
            key={record.id}
            className="rounded-xl border border-[#E6DDD0] bg-[#FFFFFF] p-4 text-xs text-[#334155] shadow-xs"
          >
            <div className="flex items-center justify-between font-medium">
              <span className="text-[#101B3A] font-semibold">{record.type} — {record.entityId}</span>
              <span className="text-[#64748B] tabular-nums">{record.timestamp}</span>
            </div>

            <div className="mt-2 font-mono flex items-center gap-1.5 text-[#64748B] overflow-hidden text-ellipsis">
              <Hash className="h-3.5 w-3.5 text-[#E96835] flex-shrink-0" />
              <span className="truncate">SHA-256: {record.sha256Hash}</span>
            </div>

            <div className="mt-2.5 flex items-center justify-between pt-2 border-t border-[#E6DDD0] text-[#64748B]">
              <span className="font-mono text-[11px]">Tx: {record.txHash}</span>
              <span className="text-[#16764C] font-semibold">Immutable receipt confirmed</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
