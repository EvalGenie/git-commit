#!/bin/bash

# Check if the 'dev' branch exists
if ! git rev-parse --verify dev >/dev/null 2>&1; then
    echo "'dev' branch does not exist. Exiting."
    exit 1
fi

# Check if currently on the 'dev' branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "dev" ]; then
    echo "Not on 'dev' branch. Switch to 'dev' branch before committing. Exiting."
    exit 1
fi

# Check if there are uncommitted changes
if git diff-index --quiet HEAD --; then
    echo "No changes to commit. Exiting."
    exit 1
fi

# Prompt the user for a commit message
echo "Enter your commit message:"
read usermessage

# Advanced Commit Message Validation
MIN_LENGTH=10
if [ -z "$usermessage" ]; then
    echo "Commit message cannot be empty. Exiting."
    exit 1
elif [ ${#usermessage} -lt $MIN_LENGTH ]; then
    echo "Commit message is too short. It must be at least $MIN_LENGTH characters. Exiting."
    exit 1
fi

# Execute the git commands with error handling
set -e
git add .

# Use printf to safely handle special characters in the commit message
printf "%s" "$usermessage" | git commit -F -
git push origin dev
set +e

echo "Changes have been committed and pushed to the dev branch."
