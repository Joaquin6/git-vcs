#!/bin/bash

# Shell script that can be executed with NPM scripts.
# The original plan is to run this script at "postinstall" as it executes the script for the current repo.

echo "Applying Git Aliases..."

# Remove existing aliase section from the config file
git config --remove-section alias

# Set a bunch of aliases

# Get my working directory up to date.
# When I’m ready to start some work, I always do the work in a new branch.
# But first, I make sure that my working directory is up to date with the origin
# before I create that branch. Typically, I’ll want to run the following commands:
# 	git pull --rebase --prune
# 	git submodule update --init --recursive
# The first command pulls changes from the remote. If I have any local commits,
# it’ll rebase them to come after the commits I pulled down. The --prune option removes
# remote-tracking branches that no longer exist on the remote.
# This combination is so common, I’ve created an alias up for this.
git config alias.up '!git pull --rebase --prune $@ && git submodule update --init --recursive' 	#*****
# Note that I’m combining two git commands together. I can use the ! prefix to execute everything
# after it in the shell. This is why I needed to use the full git commands.
# Using the ! prefix allows me to use any command and not just git commands in the alias.

# Starting new work
# At this point, I can start some new work.
# All new work starts in a branch so I would typically use `git checkout -b new-branch`.
# However I alias this to cob to build upon co.
git config alias.cob 'checkout -b' 	#*****
# Note that this simple alias is expanded in place.
# So to create a branch named “emoji-completion” I simply type git cob emoji-completion
# which expands to git checkout -b emoji-completion.
# With this new branch, I can start writing the crazy codes. As I go along, I try and commit regularly with my cm alias.
git config alias.cm '!git add -A && git commit -m' 	#*****
# For example, git cm "Making stuff work". This adds all changes including untracked files to the index and then creates a
# commit with the message “Making Stuff Work”.
# Sometimes, I just want to save my work in a commit without having to think of a commit message.
# I could stash it, but I prefer to write a proper commit which I will change later. git save or git wip.
# The first one adds all changes including untracked files and creates a commit.
# The second one only commits tracked changes. I generally use the first one.
git config alias.save '!git add -A && git commit -m "SAVEPOINT"'	#*****
git config alias.wip 'commit -am "WIP"'								#*****
# When I return to work, I’ll just use git undo which resets the previous commit,
# but keeps all the changes from that commit in the working directory.
git config alias.undo 'reset HEAD~1 --mixed'	#*****
# Or, if I merely need to modify the previous commit, I’ll use git amend
git config alias.amm 'commit --amend'		#*****
git config alias.amend 'commit -a --amend' 	#*****
# The -a adds any modifications and deletions of existing files to the commit but ignores brand new files.
# The --amend launches your default commit editor (Notepad in my case) and lets you change the commit message
# of the most recent commit.

# A proper reset
# There will be times when you explore a promising idea in code and it turns out to be crap. You just want to throw your hands up in disgust and burn all the work in your working directory to the ground and start over.
# In an attempt to be helpful, people might recommend: git reset HEAD --hard.
# Slap those people in the face. It’s a bad idea. Don’t do it!
# That’s basically a delete of your current changes without any undo. As soon as you run that command, Murphy’s Law dictates you’ll suddenly remember there was that one gem among the refuse you don’t want to rewrite.
# Too bad. If you reset work that you never committed it is gone for good. Hence, the wipe alias.
git config alias.wipe '!git add -A && git commit -qm "WIPE SAVEPOINT" && git reset HEAD~1 --hard'	#*****
# This commits everything in my working directory and then does a hard reset to remove that commit.
# The nice thing is, the commit is still there, but it’s just unreachable.
# Unreachable commits are a bit inconvenient to restore, but at least they are still there.
# You can run the git reflog command and find the SHA of the commit if you realize later that you made a mistake with the reset.
# he commit message will be “WIPE SAVEPOINT” in this case.

# Completing the pull request
# While working on a branch, I regularly push my changes to GitHub. At some point, I’ll go to github.com and create a pull request, people will review it, and then it’ll get merged. Once it’s merged, I like to tidy up and delete the branch via the Web UI. At this point, I’m done with this topic branch and I want to clean everything up on my local machine. Here’s where I use one of my more powerful aliases, git bdone.
# This alias does the following.
# Switches to master (though you can specify a different default branch)
# Runs git up to bring master up to speed with the origin
# Deletes all branches already merged into master using another alias, git bclean
# It’s quite powerful and useful and demonstrates some advanced concepts of git aliases. But first, let me show git bclean. This alias is meant to be run from your master (or default) branch and does the cleanup of merged branches.
git config alias.bclean '!f() { git branch --merged ${1-master} | grep -v " ${1-master}$" | xargs -r git branch -d; }; `f`' 	#*****
# If you’re not used to shell scripts, this looks a bit odd. What it’s doing is defining a function and then calling that function. The general format is !f() { /* git operations */; }; f We define a function named f that encapsulates some git operations, and then we invoke the function at the very end.
# What’s cool about this is we can take advantage of arguments to this alias. In fact, we can have optional parameters. For example, the first argument to this alias can be accessed via $1. But suppose you want a default value for this argument if none is provided. That’s where the curly braces come in. Inside the braces you specify the argument index ($0 returns the whole script) followed by a dash and then the default value.
# Thus when you type git bclean the expression ${1-master} evaluates to master because no argument was provided. But if you’re working on a GitHub pages repository, you’ll probably want to call git bclean gh-pages in which case the expression ${1-master} evaluates to gh-pages as that’s the first argument to the alias.
# Let’s break down this alias into pieces to understand it.
# git branch --merged ${1-master} lists all the branches that have been merged into the specify branch (or master if none is specified). This list is then piped into the grep -v "${1-master}" command. Grep prints out lines matching the pattern. The -v flag inverts the match. So this will list all merged branches that are not master itself. Finally this gets piped into xargs which takes the standard input and executes the git branch -d line for each line in the standard input which is piped in from the previous command.
# In other words, it deletes every branch that’s been merged into master except master. I love how we can compose these commands together.
# With bclean in place, I can compose my git aliases together and write git bdone.
git config alias.bdone '!f() { git checkout ${1-master} && git up && git bclean ${1-master}; }; `f`' 							#*****
# I use this one all the time when I’m deep in the GitHub flow. And now, you too can be a GitHub flow master.


git config alias.co 'checkout' 		#*****
git config alias.br 'branch'		#*****
git config alias.ci 'commit'		#*****
git config alias.s 'status -sb'		#*****
git config alias.st 'status'		#*****


git config alias.serve '!git daemon --reuseaddr --verbose  --base-path=.  --export-all ./.git'


git config alias.mr '!sh -c "git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2" -'
git config alias.unstage 'reset HEAD --'
git config alias.unmerged '!git ls-files --unmerged | cut -f2 | sort -u'
git config alias.b 'rev-parse --abbrev-ref HEAD' 															#*****


git config alias.a '!git add . && git status'						#*****
git config alias.au '!git add -u . && git status'					#*****
git config alias.aa '!git add . && git add -u . && git status'		#*****
git config alias.c 'commit'
git config alias.ca 'commit --amend'
git config alias.qca 'commit -a -m "Quick commit"'
git config alias.ac '!git add . && git commit'						#*****
git config alias.acm '!git add . && git commit -m'					#*****


# alias for long listing each commit - lines added and removed
git config alias.l 'log --graph --all --pretty=format:"%C(yellow)%h%C(cyan)%d%Creset %s %C(white)- %an, %ar%Creset" --decorate --date=short' #*****
git config alias.ll 'log --stat --abbrev-commit' #*****
git config alias.lg 'log --color --graph --pretty=format:"%C(bold white)%h%Creset -%C(bold green)%d%Creset %s %C(bold green)(%cr)%Creset %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative' #*****
git config alias.lgg 'log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --numstat'
git config alias.llg 'log --color --graph --pretty=format:"%C(bold white)%H %d%Creset%n%s%n%+b%C(bold blue)%an <%ae>%Creset %C(bold green)%cr (%ci)" --abbrev-commit' #*****
git config alias.graph 'log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative' #*****
git config alias.lline 'log --oneline -10' #*****
git config alias.count '!git log --all --oneline | wc -l' #*****
git config alias.gl1 'log -1 --name-status'

git config alias.d 'diff' 					#*****
git config alias.master 'checkout master' 	#*****
git config alias.qa 'checkout qa' 			#*****
git config alias.alias '!git config --list | grep "alias\." | sed "s/alias\.\([^=]*\)=\(.*\)/\1\	 => \2/" | sort' 	#*****


git config alias.path 'rev-parse --show-toplevel' 	#*****
git config alias.abandon 'reset --hard' 			#*****


# Grep from root folder
git config alias.gra '!f() { A=$(pwd) && TOPLEVEL=$(git rev-parse --show-toplevel) && cd $TOPLEVEL && git grep --full-name -In "$1" | xargs -I{} echo $TOPLEVEL/{} && cd $A; }; `f`' #*****


# In some of my workflows I wanted to quickly rename branches prepending done- to their names.
# Here is the alias that came out of that workflow:
git config alias.done '!f() { git branch | grep "$1" | cut -c 3- | grep -v done | xargs -I{} git branch -m {} done-{}; }; `f`'


# Add edit conflicted to gitconfig
git config alias.editconflicted '!f() {git ls-files --unmerged | cut -f2 | sort -u ; }; $EDITOR `f`'
# Create an alias to add the conflicted
git config alias.addconflicted '!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; git add `f`'	#*****


git config alias.assume 'update-index --assume-unchanged' 		#*****
git config alias.unassume 'update-index --no-assume-unchanged'	#*****


git config --global alias.visual '!gitk'


git config --remove-section color
git config color.ui true


git config --remove-section help
git config help.autocorrect 80
