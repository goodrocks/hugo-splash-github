#!/bin/sh
#hugo-splash-github/gh-publish.sh

branch_name="$(git rev-parse --abbrev-ref HEAD)"

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
echo "cd'ing into public"
cd public

echo "git add'ing all to staging"
git add --all
echo "git commit'ing"
git commit -m "Publishing to gh-pages (gh-publish.sh), ${branch_name}"

echo "pushing all to git"
cd ..
git push --all
