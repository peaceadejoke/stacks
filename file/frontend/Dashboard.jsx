import React, { useState, useEffect } from "react";
import { showConnect } from "@stacks/connect-react";
import { callReadOnlyFunction, callPublicFunction } from "@stacks/transactions";
import { StacksTestnet } from "@stacks/network";

const network = new StacksTestnet();

export default function Dashboard() {
  const [latestValue, setLatestValue] = useState(0);
  const [history, setHistory] = useState([]);
  const [metadata, setMetadata] = useState({});

  // Fetch latest oracle value
  async function fetchLatestValue() {
    const res = await callReadOnlyFunction({
      contractAddress: "ST123...",
      contractName: "dynamic-nft-oracle",
      functionName: "get-latest-value",
      functionArgs: [],
      network,
    });
    setLatestValue(Number(res.value));
  }

  // Fetch history count and history
  async function fetchHistory() {
    const countRes = await callReadOnlyFunction({
      contractAddress: "ST123...",
      contractName: "dynamic-nft-oracle",
      functionName: "get-history-count",
      functionArgs: [],
      network,
    });
    const count = Number(countRes.value);
    const hist = [];
    for (let i = 0; i < count; i++) {
      const entry = await callReadOnlyFunction({
        contractAddress: "ST123...",
        contractName: "dynamic-nft-oracle",
        functionName: "get-history-by-index",
        functionArgs: [{ type: "uint", value: i }],
        network,
      });
      hist.push(entry.value);
    }
    setHistory(hist);
  }

  useEffect(() => {
    fetchLatestValue();
    fetchHistory();
  }, []);

  return (
    <div className="p-4">
      <h1 className="text-xl font-bold mb-4">Dynamic NFT Dashboard</h1>
      <div className="mb-4">
        <strong>Latest Oracle Value:</strong> {latestValue}
      </div>
      <div className="mb-4">
        <strong>Update History:</strong>
        <ul>
          {history.map((h, idx) => (
            <li key={idx}>
              NFT Value: {h.value}, Block: {h.block-height}, Caller: {h.caller}
            </li>
          ))}
        </ul>
      </div>
      <button
        className="bg-blue-500 text-white px-4 py-2 rounded"
        onClick={() => showConnect()}
      >
        Connect Wallet
      </button>
    </div>
  );
}
