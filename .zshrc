
#                              Globals

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(background_jobs context dir_writable dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vcs time command_execution_time status)

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='green'
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='black'
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND='red'
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='black'

POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='blue'
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='white'

POWERLEVEL9K_DIR_HOME_BACKGROUND='024'
POWERLEVEL9K_DIR_HOME_FOREGROUND='012'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='023'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='012'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='025'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='012'

POWERLEVEL9K_STATUS_OK_BACKGROUND='022'
POWERLEVEL9K_STATUS_OK_FOREGROUND='014'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='124'
POWERLEVEL9K_STATUS_ERROR_FOREGROUND='202'

POWERLEVEL9K_VCS_CLEAN_FOREGROUND='051'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='055'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='051'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='056'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='051'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='057'

POWERLEVEL9K_TIME_BACKGROUND='195'


COMPLETION_WAITING_DOTS="true"

ZSH_PLUGINS_ALIAS_TIPS_EXPAND=1

ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

ENHANCD_FILTER=sk


#                             Plugins

fpath+=~/.zfunc

source /usr/share/zsh/scripts/zplug/init.zsh

zplug "bhilburn/powerlevel9k",                     use:powerlevel9k.zsh-theme, defer:1
zplug "b4b4r07/enhancd",                           use:init.sh
zplug "plugins/git", if:"(( $+commands[git] ))",   from:oh-my-zsh, defer:2
zplug "plugins/history-substring-search",          from:oh-my-zsh
zplug "plugins/fancy-ctrl-z",                      from:oh-my-zsh
zplug "plugins/extract",                           from:oh-my-zsh
zplug "plugins/archlinux",                         from:oh-my-zsh
zplug "plugins/jump",                              from:oh-my-zsh
zplug "lib/completion",                            from:oh-my-zsh
zplug "lib/termsupport",                           from:oh-my-zsh
zplug "lib/history",                               from:oh-my-zsh
zplug "lib/directories",                           from:oh-my-zsh
zplug "hlissner/zsh-autopair",                     defer:1
zplug "zsh-users/zsh-syntax-highlighting",         defer:2
zplug "zsh-users/zsh-autosuggestions",             defer:3
zplug "RobSis/zsh-completion-generator"
zplug "pxgamer/quoter-zsh"
zplug "zsh-users/zsh-completions"
zplug "t413/zsh-background-notify"
zplug "jreese/zsh-opt-path"
zplug "djui/alias-tips"
zplug "Tarrasch/zsh-bd"

zplug load


#                               Aliases

alias            s="sudo "
alias            o="xdg-open "
alias            t="exa -Tla -I .git"
alias            j="jump "
for i in $(seq 1 9); do
    alias       "K$i"="exa -labHUhgTL$i --git --group-directories-first -I .git "
    alias       "k$i"="exa -lbHhUgTL$i --git --group-directories-first -I .git "
done
alias            K="K1 "
alias            k="k1"
alias           sc="systemctl "
alias          scu="systemctl --user "
alias         logs="journalctl "
alias           k9="kill -9"
alias           ka="killall "
alias          gch="git checkout -f HEAD"
alias          gcl="git clean -df"
alias           gf="git-forest --reverse"
alias          gDc="git diff --cached"
alias           gD="git diff"
alias          gdc="git difftool --cached"
alias          gau="git add -u"
alias           sk="sk --reverse -e --height=40 --ansi"
alias            h="tldr"
alias            H="man"
alias            v=$EDITOR
alias         less=$PAGER
alias        zless=$PAGER
alias          rm!="rm -rf"
alias          ls="ls --color=always"


alias          '.'='nvr -cc ":term ranger $PWD" -c ":norm! i"'
alias -g     '<<<'='tail -f '
alias -g      '~!'="/run/user/$UID"
alias -g      '\\'=' | $PAGER '
alias -g      '//'=' | rg '
alias -g      '>|'=' > /dev/null 2>&1 '

alias -g      '__'=' | _sk '
_sk() { sk | read v; eval "$* $v" }


#                              Functions

preexec() {
    [[ $1 != $2 ]] && echo -e "\e[90m\e[5mAlias tip: $2\e[0m";
}


mkd() { mkdir -p $* && cd $1 }
mkp() { mkdir -p $* }
mvd() { mkdir $2 && mv $1 $2 && cd $2 }
mvp() { mv $1 .. && cd .. }

bk() { cp -r $1 ~$1~ }
kb() { cp -r ~$1~ $1 }

note () { echo '\n     ———————————————:( '$(date +%T)' ):———————————————\n\n'"$*"'\n' >> ~/.notes/$(date +%F) }
notes() { [[ -z $* ]] && cd ~/.notes || rg "$@" ~/.notes }

acd() { P=$1.mount; mkdir $P; archivemount $1 $P && cd $P; }

#                              Bindings

bindkey    -s            '^[[32;5u'     '^u o $(sk)\r\n'
bindkey    -M menuselect '\r'           '^w\r\r'
bindkey    -M menuselect '\e'           '\h\e'


#                             Settings

setopt extendedglob

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

setopt rm_star_wait

setopt interactive_comments

