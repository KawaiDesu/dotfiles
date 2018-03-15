# ~/.bashrc: executed by bash(1) for non-login shells.
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
#shopt -s failglob
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=unlimited
HISTFILESIZE=unlimited

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
		color_prompt=yes
    else
		color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -al --group-directories-first'
alias la='ls -Ap'
alias l='ls -p'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

########
# VARS #
########

export EDITOR=nano
export PAGET=less
export GOPATH="/home/9362/.gopath"

# "proxy" in /etc/hosts
PROXY="proxy:3128"
export http_proxy="http://${PROXY}"
export https_proxy="$PROXY"
export ftp_proxy="$PROXY"


##########
# PROMPT #
##########

export PROMPT_COMMAND=_pc

_pc(){
	local RETURN_CODE="$?"

	local color_lred='\[\033[1;31m\]'  # light red
	local color_green='\[\033[1;32m\]' # green

	local color_user='\[\033[0;33m\]'  # brown/orange
	local color_line='\[\033[1;30m\]'  # light gray
	local color_host='\[\033[1;34m\]'  # light blue

	local color_off='\[\033[0m\]'      # disable color

	# set return code color
	local RC_COLOR="${color_lred}"
	if [[ "$RETURN_CODE" == "0" ]]; then
		RC_COLOR="${color_green}"
	fi

	# set pwd home prefix
	local PWDNAME="$PWD"
	if [[ "$HOME" == "$PWD" ]]; then
		PWDNAME="~"
	else
		if [[ "$HOME" == "${PWD:0:${#HOME}}" ]]; then
			PWDNAME="~${PWD:${#HOME}}"
		fi
	fi

	# detect if root and set color
	local USER_TYPE="$color_green"
	if [[ "$UID" -eq "0" ]]; then
		USER_TYPE="$color_lred"
	fi

	local LINE_LEN=$(($COLUMNS-${#USER}-${#HOSTNAME}-${#PWDNAME}-${#RETURN_CODE}-4))
	local FILL_LINE=$(printf '─%.0s' $(eval echo {1..$LINE_LEN}))

	PS1="${color_user}\u${color_off}@\
${color_host}${HOSTNAME}${color_off}:\
${PWDNAME} \
${color_line}${FILL_LINE}${color_off} \
${RC_COLOR}${RETURN_CODE}${color_off}\n\
${USER_TYPE}➜${color_off} ";


	echo -en "\033[6n" && read -sdR CURPOS;
	[[ ${CURPOS##*;} -gt 1 ]] && echo "${color_}↵${color_error_off}";
}

