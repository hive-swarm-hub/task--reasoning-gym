#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading ReasoningGym..."
python3 << 'PY'
from datasets import load_dataset
import json, pathlib, random

random.seed(42)
ds = load_dataset('nvidia/Nemotron-RL-ReasoningGym-v1', split='train', streaming=True)

items = []
for i, row in enumerate(ds):
    if i >= 500: break
    items.append({"question": row["question"], "answer": row["answer"]})

random.shuffle(items)
out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in items[:150]:
        f.write(json.dumps(row) + '\n')
print(f'Wrote 150 problems to {out}')
PY
echo "Done. $(wc -l < data/test.jsonl) puzzles in data/test.jsonl"
