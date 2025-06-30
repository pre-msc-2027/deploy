#!/bin/bash
## Automated labeling script for CI/CD

generate_ci_labels() {
  local commit_hash=$(git rev-parse HEAD)
  local branch_name=$(git rev-parse --abbrev-ref HEAD)

  docker build \
    --label "ci-commit=$commit_hash" \
    --label "ci-branch=$branch_name" \
    --label "ci-timestamp=$(date +%Y%m%d_%H%M%S)" \
    --label "built-by=labex-ci" \
    -t myapp:latest .
}

generate_ci_labels
