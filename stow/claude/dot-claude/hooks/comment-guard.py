#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""PreToolUse guard: challenge every new code comment once per session."""

import hashlib
import json
import os
import re
import sys
import time
from pathlib import Path

HASH_EXTS = (".py", ".pyi", ".rb", ".rake", ".sh", ".bash", ".zsh", ".fish", ".pl",
             ".pm", ".r", ".jl", ".ex", ".exs", ".nix", ".tf", ".hcl", ".cr")
SLASH_EXTS = (".c", ".h", ".cc", ".cpp", ".cxx", ".hpp", ".hh", ".java", ".js", ".jsx",
              ".mjs", ".cjs", ".ts", ".tsx", ".go", ".rs", ".swift", ".kt", ".kts",
              ".cs", ".scala", ".php", ".dart", ".zig", ".m", ".mm", ".proto", ".sol",
              ".groovy", ".gradle", ".scss", ".less", ".v")
DASH_EXTS = (".sql", ".lua", ".hs", ".elm", ".ads", ".adb")
SEMI_EXTS = (".el", ".clj", ".cljs", ".cljc", ".lisp", ".scm", ".rkt")
BLOCK_EXTS = SLASH_EXTS + (".css",)
TRIPLE_EXTS = (".py", ".pyi")

EXT_TOKENS: dict[str, tuple[str, ...]] = {}
for exts, token in ((HASH_EXTS, "#"), (SLASH_EXTS, "//"), (DASH_EXTS, "--"), (SEMI_EXTS, ";")):
    for ext in exts:
        EXT_TOKENS[ext] = EXT_TOKENS.get(ext, ()) + (token,)
EXT_TOKENS[".php"] = ("//", "#")

DOC_PREFIXES = ("///", "//!", "/**", "#'")
BDD_WORDS = frozenset({"given", "when", "then", "and", "but", "arrange", "act", "assert",
                       "setup", "teardown", "expect"})
DIRECTIVE = re.compile(
    r"^(noqa|type:|pragma|pylint|ruff|mypy|flake8|bandit|coverage|eslint|prettier|biome"
    r"|ts-|@ts-|rubocop|shellcheck|stylua|selene|golangci|nolint|go:|cgo|deno-|istanbul"
    r"|c8 |v8 |swiftlint|clang-format|fmt:|region|endregion|coding[:=]|-\*-|vim:|emacs:"
    r"|sourcemappingurl|codegen|generated|license|copyright|spdx)", re.I)
TRIPLE = re.compile(r'"""|\'\'\'')

STATE_DIR = Path(os.environ.get("XDG_STATE_HOME") or Path.home() / ".local/state") / "claude/comment-guard"
STATE_MAX_AGE = 14 * 86400
MAX_LISTED = 8


def strip_strings(line: str) -> str:
    out, quote, esc = [], None, False
    for ch in line:
        if quote:
            out.append(" ")
            if esc:
                esc = False
            elif ch == "\\":
                esc = True
            elif ch == quote:
                quote = None
        elif ch in "\"'`":
            quote = ch
            out.append(" ")
        else:
            out.append(ch)
    return "".join(out)


def comment_index(line: str, tokens: tuple[str, ...]) -> int:
    best = -1
    for token in tokens:
        start = 0
        while True:
            i = line.find(token, start)
            if i < 0:
                break
            prev = line[i - 1] if i else ""
            if prev and ((token == "//" and prev == ":") or (token == "#" and prev in "${#")
                         or (token == "--" and prev in "-<")):
                start = i + len(token)
                continue
            best = i if best < 0 else min(best, i)
            break
    return best


def body_of(segment: str) -> str | None:
    if segment.startswith(DOC_PREFIXES) or segment.startswith("#!"):
        return None
    body = segment.strip().lstrip("#/-;*% ").strip()
    if not body or not re.search(r"[A-Za-z]", body) or DIRECTIVE.match(body):
        return None
    first = re.match(r"[a-z]+", body.lower())
    if first and first.group() in BDD_WORDS:
        return None
    return body


def comments_in(path: str, text: str) -> list[str]:
    ext = Path(path).suffix.lower()
    tokens = EXT_TOKENS.get(ext, ())
    block = ext in BLOCK_EXTS
    if not tokens and not block:
        return []
    found: list[str] = []
    block_lines: list[str] | None = None
    state: tuple[str, str] | None = None
    for raw in text.splitlines():
        line = raw.strip()
        if state is not None:
            kind, end = state
            head = line.split(end)[0] if end in line else line
            if block_lines is not None:
                block_lines.append(head.lstrip("* "))
            if end in line:
                state = None
                if block_lines is not None:
                    body = body_of(" ".join(block_lines))
                    if body:
                        found.append(body)
                    block_lines = None
            continue
        if ext in TRIPLE_EXTS and (m := TRIPLE.search(line)):
            marker = m.group()
            if line.count(marker) % 2:
                state = ("doc", marker)
            continue
        stripped = strip_strings(line)
        li = comment_index(stripped, tokens) if tokens else -1
        bi = stripped.find("/*") if block else -1
        if bi >= 0 and (li < 0 or bi < li):
            segment = line[bi:]
            kind = "doc" if segment.startswith("/**") else "code"
            close = segment.find("*/", 2)
            if close >= 0:
                if kind == "code":
                    body = body_of(segment[2:close])
                    if body:
                        found.append(body)
                continue
            state = (kind, "*/")
            block_lines = [segment[2:]] if kind == "code" else None
        elif li >= 0:
            body = body_of(line[li:])
            if body:
                found.append(body)
    return found


def key(body: str) -> str:
    normal = " ".join(re.findall(r"[a-z0-9]+", body.lower()))
    return hashlib.sha256(normal.encode()).hexdigest()[:16]


def session_state(session_id: str) -> Path:
    STATE_DIR.mkdir(parents=True, exist_ok=True)
    cutoff = time.time() - STATE_MAX_AGE
    for stale in STATE_DIR.glob("*.txt"):
        if stale.stat().st_mtime < cutoff:
            stale.unlink(missing_ok=True)
    return STATE_DIR / f"{session_id or 'default'}.txt"


def deny(reason: str) -> None:
    json.dump({"hookSpecificOutput": {"hookEventName": "PreToolUse",
                                      "permissionDecision": "deny",
                                      "permissionDecisionReason": reason}}, sys.stdout)
    sys.exit(0)


def main() -> None:
    payload = json.load(sys.stdin)
    tool_input = payload.get("tool_input") or {}
    path = tool_input.get("file_path", "")
    edits = tool_input.get("edits") or [tool_input]
    added = [e.get("new_string") or e.get("content") or "" for e in edits]
    removed = [e.get("old_string") or "" for e in edits]

    existing = {key(c) for text in removed for c in comments_in(path, text)}
    candidates: dict[str, str] = {}
    for text in added:
        for body in comments_in(path, text):
            k = key(body)
            if k not in existing:
                candidates.setdefault(k, body)
    if not candidates:
        return

    state = session_state(payload.get("session_id", ""))
    seen = set(state.read_text().split()) if state.exists() else set()
    fresh = {k: v for k, v in candidates.items() if k not in seen}
    if not fresh:
        return
    with state.open("a") as fh:
        fh.write("".join(f"{k}\n" for k in fresh))

    listed = "\n".join(f"  - {b[:120]}" for b in list(fresh.values())[:MAX_LISTED])
    extra = f"\n  ... and {len(fresh) - MAX_LISTED} more" if len(fresh) > MAX_LISTED else ""
    deny(
        f"Comment guard: this edit adds {len(fresh)} new comment(s) to {Path(path).name}:\n"
        f"{listed}{extra}\n\n"
        "Delete each one unless it explains *why*: a non-obvious constraint, a rejected "
        "alternative, or a trap the code cannot state itself. Restating what the code does, "
        "narrating steps, or labelling sections is not a justification - make the code say it "
        "instead (better name, smaller function, earlier return).\n"
        "Redo the edit without them, or keep only the ones you can defend. Each comment is "
        "challenged once per session, so a deliberate re-send will go through."
    )


if __name__ == "__main__":
    try:
        main()
    except Exception:
        sys.exit(0)
