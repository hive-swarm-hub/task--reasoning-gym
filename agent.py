"""ReasoningGym solver — solves diverse reasoning puzzles.

Takes a question on stdin, prints the answer on stdout.
"""

import sys
import os
import re

from openai import OpenAI


def solve(question: str) -> str:
    client = OpenAI()
    response = client.chat.completions.create(
        model=os.environ.get("SOLVER_MODEL", "gpt-4.1-nano"),
        messages=[
            {"role": "system", "content": "Solve the reasoning puzzle. Output ONLY the answer value — no labels, no units, no explanation. Just the raw answer."},
            {"role": "user", "content": question},
        ],
        temperature=0,
        max_tokens=256,
    )
    return response.choices[0].message.content.strip()


if __name__ == "__main__":
    print(solve(sys.stdin.read().strip()))
