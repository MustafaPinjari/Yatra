import React from "react";
import { ShieldCheck, ExternalLink, Hash, Check } from "lucide-react";

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
    <div className="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
      <div className="flex items-center justify-between border-b border-slate-100 pb-4">
        <div className="flex items-center gap-3">
          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-emerald-100 text-emerald-700">
            <ShieldCheck className="h-5 w-5" aria-hidden="true" />
          </div>
          <div>
            <h2 className="text-lg font-bold text-slate-900">
              Trust Ledger: Blockchain Audit Receipts
            </h2>
            <p className="text-xs text-slate-500">
              Cryptographic proof of depot accessibility inspections anchored on Ethereum Sepolia (Zero PII on-chain)
            </p>
          </div>
        </div>
        <span className="rounded-full bg-emerald-50 border border-emerald-200 px-3 py-1 text-xs font-semibold text-emerald-700 flex items-center gap-1.5">
          <Check className="h-3.5 w-3.5" /> Sepolia Smart Contract Verified
        </span>
      </div>

      <div className="mt-4 space-y-3">
        {sampleTrustRecords.map((record) => (
          <div
            key={record.id}
            className="rounded-lg border border-slate-200 bg-slate-50/60 p-3.5 text-xs text-slate-600"
          >
            <div className="flex items-center justify-between font-medium">
              <span className="text-slate-900 font-semibold">{record.type} — {record.entityId}</span>
              <span className="text-slate-400">{record.timestamp}</span>
            </div>

            <div className="mt-2 font-mono flex items-center gap-1.5 text-slate-500 overflow-hidden text-ellipsis">
              <Hash className="h-3.5 w-3.5 text-indigo-600 flex-shrink-0" />
              <span className="truncate">SHA-256: {record.sha256Hash}</span>
            </div>

            <div className="mt-2 flex items-center justify-between pt-2 border-t border-slate-200 text-slate-500">
              <span>Tx: {record.txHash}</span>
              <a
                href="https://sepolia.etherscan.io"
                target="_blank"
                rel="noreferrer"
                className="inline-flex items-center gap-1 text-indigo-600 hover:text-indigo-800 font-semibold"
              >
                Inspect on Etherscan <ExternalLink className="h-3 w-3" />
              </a>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

