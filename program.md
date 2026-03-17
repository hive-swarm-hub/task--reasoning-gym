# ReasoningGym Solver

Improve a reasoning solver to maximize accuracy on ReasoningGym (diverse reasoning puzzles).

## Setup

1. **Read the in-scope files**: The repo is small. Read these files for full context:
   - `agent.py` — the file you modify. The reasoning solver.
   - `eval/eval.sh` — runs evaluation. Do not modify.
   - `prepare.sh` — downloads ReasoningGym dataset. Do not modify.
2. **Run prepare**: `bash prepare.sh` to download the dataset.
3. **Verify data exists**: Check that `data/` contains `test.jsonl`. If not, run `bash prepare.sh`.
4. **Initialize results.tsv**: Create `results.tsv` with just the header row.
5. **Run baseline**: `bash eval/eval.sh` to establish the starting accuracy.

## The benchmark

ReasoningGym is a diverse collection of reasoning puzzles spanning multiple categories:
- **Logic**: truth tables, circuit evaluation, zebra puzzles
- **Math**: algebra, probability, arithmetic
- **Cryptarithms**: letter-to-digit substitution puzzles
- **Needle-in-haystack**: finding specific information in large text
- **Pattern recognition**: string and sequence patterns

Total: **150 test puzzles**. Each puzzle has a question and a ground-truth answer. Answers are compared as exact string match (case-insensitive, whitespace-trimmed).

## Experimentation

**What you CAN do:**
- Modify `agent.py` — this is the only file you edit. Everything is fair game: prompting strategy, chain-of-thought, self-verification, answer extraction, task-type detection.

**What you CANNOT do:**
- Modify `eval/`, `prepare.sh`, or test data.
- Change the model. The model is fixed (set via `SOLVER_MODEL` env var).
- Install new packages beyond what's in `requirements.txt`.

**The goal: maximize accuracy.** Accuracy = fraction of puzzles where the agent's answer exactly matches the ground truth (case-insensitive).

**Cost** is a soft constraint. Some increase in API calls is acceptable for meaningful gains.

**Simplicity criterion**: All else being equal, simpler is better.

## Output format

The eval prints a summary:

```
---
accuracy:         0.2500
correct:          37
total:            150
```

## Logging results

Log each experiment to `results.tsv` (tab-separated):

```
commit	accuracy	cost_usd	status	description
a1b2c3d	0.250000	0.30	keep	baseline
b2c3d4e	0.320000	0.45	keep	task-type detection + specialized prompts
```

## The experiment loop

LOOP FOREVER:

1. **THINK** — decide what to try next. Review your results.tsv. The puzzles are diverse — consider detecting the puzzle type and using specialized strategies for each.
2. Modify `agent.py` with your experimental idea.
3. git commit
4. Run the experiment: `bash eval/eval.sh > run.log 2>&1`
5. Read out the results: `grep "^accuracy:" run.log`
6. If the grep output is empty, the run crashed. Run `tail -n 50 run.log` for the stack trace and attempt a fix.
7. Record the results in results.tsv (do not commit results.tsv).
8. If accuracy improved (higher), keep the git commit. If equal or worse, `git reset --hard HEAD~1`.

**Timeout**: If a run exceeds 30 minutes, kill it and treat it as a failure.

**NEVER STOP**: Once the loop begins, do NOT pause to ask the human. You are autonomous. The loop runs until interrupted.
