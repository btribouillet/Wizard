#!/usr/bin/env bash -e

if ! git diff-index --quiet HEAD --; then
    echo "> Seems like you have uncommitted changes"
    exit 1
fi

ORIGINAL_BRANCH_NAME=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')

git checkout master

# Generate and commit apigen
apigen --php "no" --title "Peytz Wizard" --source src --destination doc
git commit -m 'Update ApiGen' doc

# Save last commit so we can cherry-pick it later
LAST_COMMIT_HASH=$(git rev-parse HEAD)

# Switch branch and cherry pick
git checkout gh-pages
git cherry-pick $LAST_COMMIT_HASH

# Go back to previous branch and pop stash
git checkout $ORIGINAL_BRANCH_NAME

echo "Update ApiGen in doc/ based on master branch. Also cherry-picked it to gh-pages."
echo "You should properly push gh-pages"
