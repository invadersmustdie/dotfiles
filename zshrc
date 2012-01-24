#!/bin/zsh

export SHELL=`which zsh`

# Colors
export red=$'%{\e[0;31m%}'
export RED=$'%{\e[1;31m%}'
export green=$'%{\e[0;32m%}'
export GREEN=$'%{\e[1;32m%}'
export blue=$'%{\e[0;34m%}'
export BLUE=$'%{\e[1;34m%}'
export purple=$'%{\e[0;35m%}'
export PURPLE=$'%{\e[1;35m}'
export cyan=$'%{\e[0;36m%}'
export CYAN=$'%{\e[1;36m}'
export WHITE=$'%{\e[1;37m}'
export white=$'%{\e[0;37m}'
export NC=$'%{\e[0m%}'

# prompt
# PS1='%{%}[%{%}%B%n@%m%b%{%}]%{%} {%~}$ '
# PS1='%{%}(%{%}%B%n@%m%b%{%})%{%} (%~) --> '
# PS1='%{%}(%{%}%B%n@%m%b%{%})%{%} (%20<..<%~) --> '
# PS1="${cyan}%y %n@%m%(!.${red}#${NC}.$)${NC} "
# PS1='%n@%m> '
# PS1=$'%{\e[1;31m%}%B(%b%{\e[0m%}%n@%m%{\e[1;31m%})%{\e[0m%} : %{\e[1;31m%}(%{\e[0m%}%~%{\e[1;31m%})%{\e[0m%}: '
# PS1='%{%}[%{%}%n@%m%{%} %C]$ '
PS1=$'%{\e[1;32m%}%B[%b%{\e[0m%}%n@%m%{\e[1;32m%}%B]%b (%{\e[0m%}%~%{\e[1;32m%}) %{\e[0m%}'

# vars
path=(/bin /usr/bin /usr/local/bin /usr/X11R6/bin /opt/bin)

# new style completion
if [ -d /usr/share/zsh/$ZSH_VERSION/functions/Completion/ ]; then
  fpath=(/usr/share/zsh/$ZSH_VERSION/functions/Completion/)
  if [ -d $HOME/.zsh_functions ]; then
    fpath=($fpath $HOME/.zsh_functions)
  fi
  autoload -U compinit
  compinit
fi

RC=~/.zshrc
EDITOR=vim
TERM=xterm
PAGER=less
USER=`whoami 2>/dev/null`
HISTFILE=~/.zshhistroy
HISTSIZE=3000
SAVEHIST=3000
MAILCHECK=0
LOGCHECK=10
READNULLCMD=less
WINDOWMANAGER="openbox"

# solaris comp mode
test -z $UID && UID=`id -u`

# where getmail stores his mails
export MAILDIR=$HOME/Mail
export MAIL=$HOME/Mail

# cvs backup system
export CVS_RSH=ssh
export CVSEDITOR=vim

# mv cvs svn
export SVN_EDITOR="vim"

# time to color my life :)
export TERM=xterm-color

# required by rubygems
export RUBYOPT=rrubygems

# remove duplicate entries from path,cdpath,manpath & fpath
typeset -U path cdpath manpath fpath

# Set up some other useful options...
setopt hash_dirs glob_complete mail_warning all_export correct_all \
menu_complete extended_glob NO_beep posix_builtins numeric_glob_sort \
complete_aliases auto_pushd NO_bang_hist bg_nice brace_ccl bsd_echo \
complete_in_word interactive_comments automenu no_sh_glob brace_expand \
nobeep nohup autocd

# history stuff
setopt inc_append_history hist_ignore_space hist_NO_store hist_NO_functions \
NO_hist_beep hist_ignore_all_dups hist_find_NO_dups hist_save_NO_dups

# remove csh junk
setopt NO_csh_junkie_history NO_csh_junkie_loops NO_csh_junkie_quotes \
NO_csh_null_cmd NO_csh_null_glob

# ksh stuff
setopt ksh_arrays ksh_autoload ksh_glob ksh_optionprint ksh_typeset

# expanding stuff
setopt EQUALS histexpand

function precmd () {
  case $TERM in
    xterm*|Eterm|rxvt)
    echo -ne "\033]0;${USER}@${HOST}";\
    echo -ne ' : '${PWD}' \007'
    ;;
    *)
    ;;
  esac
}

# ssh-agent hijacking
if [[ -e $HOME/.ssh/agent ]]; then
  . $HOME/.ssh/agent .
else
  ssh-agent|head -n2 > $HOME/.ssh/agent
  chmod 0700 $HOME/.ssh/agent
  . $HOME/.ssh/agent .
  ssh-add ~/.ssh/id_dsa
fi

# local bindir
if [ -d $HOME/bin ] && [ -z "`echo $PATH|grep $HOME/bin`" ]; then
  export PATH=$PATH:$HOME/bin
fi

# solaris extra bindir
if [ -d /opt/csw/bin ]; then
  export PATH=$PATH:/opt/csw/bin
fi

if [ -d /usr/lib/ccache ] && [ -z "`echo $PATH|grep ccache`"]; then
  export PATH=/usr/lib/ccache:$PATH
fi

if [ -d $HOME/bin ]; then
  export PATH=$HOME/bin:$PATH
fi

if [ $UID = '0' ]; then
  export PATH=$PATH:/sbin:/usr/sbin
  echo "     you are root"
fi

if [ -e /etc/pkgmk.conf ]; then
  echo
  echo "  -> using zsh on gnu/crux [$(/bin/arch)]"
  echo "     $(date)"
  echo "     $USER logged in on $TTY"
  echo

  for service in `cd /etc/rc.d/; ls --color=never`
  do
    alias "rc${service}"="/etc/rc.d/${service}"
  done

  if [ `/bin/arch` = "ppc" ]; then
    if [ -e /dev/pmu ]; then
      alias eject="pbbcmd config TAG_EJECTCD command"
    fi
  fi
fi

if [ -e /bsd ]; then
  echo
  echo "  -> using zsh on openbsd"
  echo "     $(date)"
  echo "     $USER logged in on $TTY"
  echo

  alias ping='/sbin/ping' # ping for all
fi

if [ $(uname) = "Darwin" ]; then
  echo
  echo "  -> using zsh on Darwin"
  echo "	   $(date)"
  echo "	   $USER logged in on $TTY"
  echo
  export PATH=$PATH:/sw/bin
  export MANPATH=/sw/share/man:/usr/share/man:/usr/local/teTeX/man:/usr/local/man
  alias ruby="/usr/local/bin/ruby"
  alias ping="/sbin/ping"
fi

if [ $(uname) = "NetBSD" ]; then
  echo
  echo "  -> using zsh on NetBSD"
  echo "     $(date)"
  echo "     $USER logged in on $TTY"
  echo
  export PATH=$PATH:/usr/pkg/bin
  if [ $UID = "0" ]; then
    export PATH=$PATH:/usr/pkg/sbin
  fi
fi

if [ -d /usr/lib/java/bin ]; then
  PATH=$PATH:/usr/lib/java/bin
fi

if [ -d /tools/bin ]; then
  export PATH=$PATH:/tools/bin
fi

## shell stuff
alias rc='vim ~/.zshrc'
alias reload_zsh='clear;source ~/.zshrc'

## vim alias
alias vim="vim -X"

## grep variables
GREP_OPTIONS="-I --colour=auto"
GREP_COLOR="0;32"

## less stuff
LESS="-RSM~gIsw"

## accounts
alias mplayer='mplayer -vo x11'
alias mplayer-vcd='mplayer -vo x11 -vcd://1 /dev/sr0'
alias sl='ls'
alias gvim='gvim 2>/dev/null'
alias fetchmail="fetchmail -as -m '/usr/bin/procmail -d %T'"

alias duff='diff -Nru'
alias irb='irb --readline -r irb/completion'

# lazzy fingers ..
alias l='ls -l'
alias ll='ls -la'
alias ..="cd .."
alias ...="cd ..."
alias exit='clear;exit' # secure
alias make='clear;make' # just for coding
alias psql='EDITOR=vim;PAGER=less psql'

# curl stuff
alias cget="curl -O --progress $1"

# special locales for de_exchange env
alias mutt='LC_CTYPE=de_DE.iso885915@euro mutt'

alias cj="java -cp $HOME/env/clojure/jline-0_9_5.jar:$HOME/env/clojure/clojure.jar jline.ConsoleRunner clojure.main"
alias gem_local="gem install --install-dir=~/.gem/ruby/1.8/ --no-rdoc --no-ri"
alias c="ruby script/console"
alias dist-ssh='noglob dist-ssh'
alias git="nocorrect git"
alias ack=ack-grep

# watch for logins
watch=(root rugek rele)
WATCHFMT="[%B%t%b] %B%n%b has %a %B%l%b from %B%M%b"

# security setting
umask 022

backward-delete-to-slash () {
  local WORDCHARS=${WORDCHARS//\//}
  zle .backward-delete-word
}
zle -N backward-delete-to-slash

# key bindings
bindkey -v
bindkey "^A"    beginning-of-line
bindkey "^[[A"  up-line-or-search
bindkey "^[[B"  down-line-or-search
bindkey " "     magic-space
bindkey "^B"    backward-word
bindkey "^E"    end-of-line
bindkey "^D"    delete-char
bindkey "^R"    history-incremental-search-backward
bindkey "^X"    list-choices
bindkey "^K"    vi-kill-eol
bindkey "^U"    backward-kill-line
bindkey "\e[3~" delete-char

## ctrl + w binding
bindkey "^W" backward-delete-to-slash
# bindkey "^W"    backward-delete-word

# quick listing of my latest mails
function listmails() { grep -h "^Subject:" $MAILDIR/cur/*|tail }

# quick hack to get all slashdot headlines
function slashdot() {
  CURDIR=${pwd};
  cd /tmp;
  test -s /tmp/slashdot.rdf && rm slashdot.rdf
  wget -q slashdot.org/slashdot.rdf;
  grep "title" slashdot.rdf|awk -F'<title>' '{ print $2 }'|awk -F'</title>' '{ print "\t + "$1 }'|tail -n 11|head;cd $CURDIR
}

# necessary for autoprobs in pekwm
function propstring () {
  echo -n 'Property '
  xprop WM_CLASS | sed 's/.*"\(.*\)", "\(.*\)".*/= "\1,\2" {/g'
  echo '}'
}

# show me which service belongs to given port
function port ()
{
  if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: port <number>"
    return
  fi

  [[ -r /etc/services ]] || return
  grep "[[:space:]]$1\/tcp" /etc/services
}

# fast googling
function google () {
  browsers=(links w3m lynx)

  for browser in ${browsers[*]}; do
    type -p $browser > /dev/null
    [[ $? -eq 0 ]] && ($browser "http://www.google.com/search?q="$1"") && return
  done
}

# set locales to de_DE
function locale_de() {
  export LANG=de_DE
  export LANGUAGE=de_DE:de
  export LC_CTYPE=de_DE.utf8
  export LC_COLLATE=de_DE.utf8
  export LC_TIME=de_DE.utf8
  export LC_MESSAGES=de_DE.utf8
  export LC_MONETARY=de_DE.utf8
  export LC_NUMERIC=de_DE.utf8
}

# list latest kernel releases
function kernel() {
  printf 'GET /kdist/finger_banner HTTP1.0\n\n' | netcat www.kernel.org 80 | grep latest
}

function start_mutt() {
  LC_CTYPE=de_DE.iso885915@euro muttng
}

function vitodo() {
  test -e ~/TODO && vim ~/TODO
}

function _todo() {
  cat ~/TODO
}

function today() {
  ruby -e 'lines=[];f=false;ARGF.each {|l| f=true if l =~/\[today\]/;lines << l if f && l != "\n";f=false if l == "\n"};lines.each {|l| puts l}' ~/TODO
}

function restcurl_post() {
  curl -i -X POST -H 'Content-Type: application/xml' $*
}

# color completion for the menu section
zmodload -i zsh/complist

# complete as much u can ..
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _match _correct _approximate _prefix

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:messages' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for: %d%{\e[0m%}'
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*' group-name ''

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zcompcache/$HOST

# add colors to completions
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# If the style is set to any other value, or is unset, files will be sorted alphabetically by name.
zstyle ':completion:*' file-sort name

# on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

# add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# completions for some progs. not in default completion system
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG):ogg\ files *(-/):directories'

# menucompletion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:less:*' menu yes select

# some nice autocompletions
hosts=("${(s: :)${(s:   :)${${(f)$(</etc/hosts)}%%\#*}#*[       ]*}}")

# setting up compctl options
compctl -g '*.class(:r)' java
compctl -g '*.Z *.gz *.tgz' + -g '*' zcat gunzip
compctl -g '*.tar.Z *.tar.gz *.tgz *.tar.bz2 *.tbz' + -g '*' tar
compctl -g '*.zip *.ZIP' + -g '*' unzip
compctl -g '*.(mp3|MP3)' + -g '*(-/)'  mpg123
compctl -g '*.(mp3|OGG)' + -g '*(-/)'  ogg123
compctl -g '*.(mp3|ogg)' + -g '*(-/)'  alsaplayer
compctl -g '*.(pdf|PDF)' + -g '*(-/)'  xpdf
compctl -c man
compctl -u chown
compctl -c {where,which}
compctl -g '/usr/lib/kbd/keytables/*(:t)' loadkeys
compctl -g '/usr/lib/kbd/consolefonts/*(:t)' setfont
compctl -g '/usr/portage/*(/:t)' emerge
compctl -k '( --search --diff --depends --test --update --list --installed --check-port --config --help --version --footprint)' rupkg
# compctl -k '(add addid addpls radd clear shuffle sort remove list play \
#  stop pause next prev seek jump move mlib status info \
#  config configlist quit help)' xmms2
compctl -k '( eth0 lo )' ifconfig

export GNOME_LIBCONFIG_PATH=/usr/lib
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export OOO_FORCE_DESKTOP=gnome

# ssh hostname stuff
if [[ -e ~/.ssh/known_hosts ]]; then
  hosts=${${(f)$(awk -F',' '{ if ($1 !~ /AA/) print $1 }' < ~/.ssh/known_hosts|uniq|tr '\n' ' ')}}
  # echo $hosts
  zstyle ':completion:*:hosts' hosts $hosts
fi

compctl -c sudo
autoload zfinit
autoload -z zed

function set_term_title () {
  case $TERM in
    xterm*|Eterm|rxvt)
    echo -ne "\033]0;$*";\
    echo -ne ' : ''\007'
    ;;
    *)
    ;;
  esac
}

function runtest() {
  # rails mode
  if [ -f config/environment.rb ]; then
    if [ -e log/test.log ]; then
      # truncate log
      echo '' > log/test.log
      echo '' > log/exceptions.log
    fi
    if [ -f test/unit/unit_test_test.rb ]; then
      RAILS_ENV=test NO_SERVER=true NO_REFRESH=true ruby test/unit/unit_test_test.rb
    fi
  fi

  RAILS_ENV=test NO_SERVER=true NO_REFRESH=true ruby $*
}

if [ -d /home/rele/env/xp ]; then
  PATH=$PATH:/home/rele/env/xp
fi

GIT_AUTHOR_NAME="rugek"
GIT_AUTHOR_EMAIL="rugek@dirtyhack.net"
GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL

unset GEM_HOME

rvm_loaded_flag=0
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# load local configurations
for i in ~/.zsh_extras/*; do
  source $i
done
