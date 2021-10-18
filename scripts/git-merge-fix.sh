#!/bin/bash

# automatization script for commiting marge requests

FIX_BRANCH_NAME=${1}

fail() {
    echo $1;
    exit 1;
}

COMMIT_MESSAGE=${2}
if [ -z "${COMMIT_MESSAGE}" ]; then
    COMMIT_MESSAGE="${FIX_BRANCH_NAME} Merged fix to master."
fi

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    fail "The current branch has uncommitted changes (run 'git status' to see them)."
fi

# Check the current branch
CURRENT_BRANCH=$(git name-rev HEAD --name-only 2> /dev/null)
if [ "${CURRENT_BRANCH}" != "master" ]; then
    git checkout master
    [[ $? == 0  ]] || fail "Could not switch to master branch."
fi

git merge --no-commit --no-ff ${FIX_BRANCH_NAME} && git commit -m "${COMMIT_MESSAGE}"
