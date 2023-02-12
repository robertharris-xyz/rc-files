#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

stty -ixon # Disable ctrl-s and ctr-q
HISTSIZE= HISTFILESIZE= # Infinite history

# Bashrc coloured prompt
# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# Format of bash prompt
export PS1="\[\e[31m\][\[\e[m\]\[\e[33m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]:\[\e[35m\]\w\[\e[m\]\[\e[32m\]\`parse_git_branch\`\[\e[m\]\[\e[31m\]]\[\e[m\]\\$ "

#########################################################
# Aliases
alias off="shutdown now" # Power down the device.

# Adding colour
alias ls="ls -hN --color=auto --group-directories-first"
alias grep="grep --color=auto" # Colour grep - highlight desired sequence.
alias ccat="highlight --out-format=ansi" # Colour-cat: Print a file with syntax highlighting.

#########################################################
# Internet packages
alias yt="yt-dlp --add-metadata -ic" # Download video link
alias yt3="yt-dlp --add-metadata -xic" #Download video as audio only
alias yt-desc="yt-dlp --get-description" #Print the description of a youtube video

#########################################################
# Package manager
alias pac-autoinstalls="pacman -Qdtq"
alias pac-autoremove="pacman -Qdtq | sudo pacman -Rs -"

