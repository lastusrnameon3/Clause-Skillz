#!/usr/bin/env bash
# PreToolUse Bash — nudge to review before the first commit of a session.
#
# Self-contained on purpose. The `if: "Bash(git commit *)"` filter in
# settings.json is belt-and-braces, not load-bearing: an earlier version relied
# on it alone and denied the FIRST BASH COMMAND OF ANY KIND when it was not
# honored by the client. Detection lives here now.
set -uo pipefail
IN=$(cat)
CMD=$(printf '%s' "$IN" | jq -r '.tool_input.command // ""')
[ -n "$CMD" ] || exit 0

# Does any segment of the command invoke `git ... commit`?
# Tokenized, not pattern-matched:
#   git -C /repo commit   → flag WITH a value between git and the subcommand
#   git log --grep=commit → the word appears but is not the subcommand
#   echo git commit       → the word appears but git is not the command
is_commit=$(printf '%s\n' "$CMD" | awk '
  BEGIN { RS = "[;&|\n]+" }
  {
    if ($1 != "git") next          # git must START the segment, not merely appear in it
    skip = 0
    for (i = 2; i <= NF; i++) {
      t = $i
      if (skip) { skip = 0; continue }
      if (t == "-C" || t == "-c" || t == "--git-dir" || t == "--work-tree" ||
          t == "--namespace" || t == "--exec-path") { skip = 1; continue }
      if (substr(t, 1, 1) == "-") continue
      if (t == "commit") { print "MATCH"; exit }
      break
    }
  }')
[ "$is_commit" = "MATCH" ] || exit 0

SID=$(printf '%s' "$IN" | jq -r '.session_id // "nosession"')
MARK="${TMPDIR:-/tmp}/claude-reviewgate-$SID"
[ -f "$MARK" ] && exit 0
touch "$MARK"
jq -n '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: "Run a review on this diff first. Re-run the commit to proceed — this fires once per session."
  }
}'
exit 0
