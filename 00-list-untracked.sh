#!/bin/bash
# List the untracked files in this branch.
#
# Kevin Davies, 10/21/2012

branch=`git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3`
echo These files are not tracked on the current branch of the repository \($branch\):
git ls-files --others
