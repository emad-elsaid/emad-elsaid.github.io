#!/usr/bin/env bash
echo -e "Deploying updates to GitHub..."
hugo

git add -A

msg="rebuilding site `LANG=C date`"
git commit -m "$msg"

git push origin master
