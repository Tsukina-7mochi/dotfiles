#!/usr/bin/env bash
#
# Fetch unresolved review threads and pending review bodies for a PR.
#
# Usage:
#   fetch_unresolved_comments.sh [PR_NUMBER]
#
# If PR_NUMBER is omitted, the PR linked to the current branch is used.
# Output: a single JSON object on stdout
#   {
#     "pr": { "number": int, "url": str, "title": str, "owner": str, "repo": str },
#     "threads": [ { isOutdated, path, line, url, author, body, diffHunk, commentId } ... ],
#     "reviews": [ { author, state, body, url, submittedAt } ... ]   # non-empty review bodies only
#   }
#
# Notes:
# - Only review threads with isResolved == false are emitted.
# - Each thread is represented by its first comment (the thread root). Subsequent
#   replies in the same thread are dropped here to keep the listing flat; the URL
#   points to the thread so the model can fetch replies if needed.
# - Requires: gh (authenticated), jq.

set -euo pipefail

die() { echo "error: $*" >&2; exit 1; }

command -v gh >/dev/null || die "gh CLI not found"
command -v jq >/dev/null || die "jq not found"

repo_json=$(gh repo view --json owner,name 2>/dev/null) \
  || die "failed to read repo (run inside a gh-linked checkout)"
owner=$(jq -r '.owner.login' <<<"$repo_json")
repo=$(jq -r '.name'        <<<"$repo_json")

if [[ $# -ge 1 && -n "$1" ]]; then
  pr_number="$1"
else
  pr_json=$(gh pr view --json number,url,title,headRefName 2>/dev/null) \
    || die "no PR linked to the current branch (pass PR number explicitly)"
  pr_number=$(jq -r '.number' <<<"$pr_json")
fi

[[ "$pr_number" =~ ^[0-9]+$ ]] || die "PR number must be an integer, got: $pr_number"

pr_meta=$(gh api "repos/${owner}/${repo}/pulls/${pr_number}" \
  --jq '{number, url: .html_url, title}') \
  || die "failed to fetch PR #${pr_number}"

threads=$(gh api graphql \
  -f query='
    query($owner: String!, $repo: String!, $pr: Int!) {
      repository(owner: $owner, name: $repo) {
        pullRequest(number: $pr) {
          reviewThreads(first: 100) {
            nodes {
              isResolved
              isOutdated
              path
              line
              comments(first: 1) {
                nodes {
                  id
                  url
                  author { login }
                  body
                  diffHunk
                }
              }
            }
          }
        }
      }
    }' \
  -f owner="$owner" -f repo="$repo" -F pr="$pr_number" \
  --jq '
    [ .data.repository.pullRequest.reviewThreads.nodes[]
      | select(.isResolved == false)
      | (.comments.nodes[0]) as $c
      | {
          isOutdated,
          path,
          line,
          url:        ($c.url        // null),
          author:     ($c.author.login // null),
          body:       ($c.body       // ""),
          diffHunk:   ($c.diffHunk   // ""),
          commentId:  ($c.id         // null)
        }
    ]')

reviews=$(gh api "repos/${owner}/${repo}/pulls/${pr_number}/reviews" \
  --jq '
    [ .[]
      | select((.body // "") | length > 0)
      | {
          author:      (.user.login  // null),
          state:       .state,
          body:        .body,
          url:         .html_url,
          submittedAt: .submitted_at
        }
    ]')

jq -n \
  --argjson pr      "$pr_meta" \
  --arg     owner   "$owner" \
  --arg     repo    "$repo" \
  --argjson threads "$threads" \
  --argjson reviews "$reviews" \
  '{
     pr:      ($pr + {owner: $owner, repo: $repo}),
     threads: $threads,
     reviews: $reviews
   }'
