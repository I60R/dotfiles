#                           Globals
#

POWERLEVEL9K_IGNORE_TERM_COLORS=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true


POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(background_jobs ip context dir_writable dir rust_version java_version newline)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vcs time command_execution_time status)

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1024

POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true
POWERLEVEL9K_JAVA_VERSION_FOREGROUND='black'
POWERLEVEL9K_JAVA_VERSION_VISUAL_IDENTIFIER_EXPANSION=' java:'
POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
POWERLEVEL9K_RUST_VERSION_FOREGROUND='black'
POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION=' rust:'




POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='—'
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND='240'


POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='   —'
POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='—   '

POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="        "

POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=""


POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='—'
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='—'

POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=''


POWERLEVEL9K_IP_INTERFACE='wlan0'
POWERLEVEL9K_IP_VISUAL_IDENTIFIER_EXPANSION=''
local RX='${${P9K_IP_RX_BYTES_DELTA#0}:+ ↓ $P9K_IP_RX_BYTES_DELTA }'
local TXRX='${${P9K_IP_RX_BYTES_DELTA#0}:+ $P9K_IP_TX_BYTES_DELTA ⇅ $P9K_IP_RX_BYTES_DELTA }'
local TXRX_OR_TX='${'$TXRX':- ↑ $P9K_IP_TX_BYTES_DELTA }'
local TXRX_OR_TX_OR_RX='${${${P9K_IP_TX_BYTES_DELTA#0}:+'$TXRX_OR_TX'}:-'$RX'}'
local IP='%F{235}%B$P9K_IP_IP%b%F{0}'
POWERLEVEL9K_IP_CONTENT_EXPANSION="$IP$TXRX_OR_TX_OR_RX"


POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND='olive'
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND='black'
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND='red'
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='black'

POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND='white'
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='black'

POWERLEVEL9K_DIR_CLASSES=(
    '~/*(|/*)' HOME_SUBFOLDER    ''
    '~(|/*)'   HOME              ''
    '*'        DEFAULT           ''
)
POWERLEVEL9K_DIR_HOME_BACKGROUND='olive'
POWERLEVEL9K_DIR_HOME_FOREGROUND='232'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='grey'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='232'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='fuchsia'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='232'

POWERLEVEL9K_STATUS_OK_BACKGROUND='lime'
POWERLEVEL9K_STATUS_OK_FOREGROUND='black'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='darkred'
POWERLEVEL9K_STATUS_ERROR_FOREGROUND='yellow'

POWERLEVEL9K_VCS_CLEAN_BACKGROUND='darkgreen'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='white'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'

POWERLEVEL9K_TIME_BACKGROUND='cyan'

POWERLEVEL9K_CONTEXT_TEMPLATE='%F{232} %B%m%b %n'
POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-aheadbehind git-stash git-remotebranch git-tagname)

POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


ZSH_PLUGINS_ALIAS_TIPS_REVEAL=1
__alias_tips_exclude() {
    for alias in $@; do
        printf "$alias $alias( .*)? "
    done
}
ZSH_PLUGINS_ALIAS_TIPS_REVEAL_EXCLUDES=(
    $(__alias_tips_exclude cd v . .. ... .... export ls la l L g)
)


ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
ZSH_AUTOSUGGEST_USE_ASYNC=yes
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="standout"


ZSH_HACKER_QUOTES_ENABLE_WHEN_INTERACTIVE=1



#                             Plugins

eval "$(sheldon source)"
eval "$(zoxide init zsh)"


zstyle ':completion:*:matches'  group 'yes'
zstyle ':completion:*'          group-name ''
zstyle ':completion:*'          extra-verbose yes
zstyle ':completion:*'          format '   :%B%U%d%u%b:'

zstyle ':autocomplete:*'     recent-dirs zoxide
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:*'     min-delay 0.1



#                               Aliases

alias            s="sudo "
alias            o="xdg-open "
alias            a="paru"
alias            d="__enhancd::cd"

alias            t="exa -Tla -I .git"
for i in $(seq 1 9); do;
    alias       "l$i"="exa -l  -bgHTL$i -I .git --icons" # U
    alias       "L$i"="exa -la -bgHTL$i -I .git --icons" # U
done
alias            L="L1 --group-directories-first"
alias            l="l1 --group-directories-first"

alias           ls="exa --group-directories-first --icons"
alias           la="exa --group-directories-first --icons -a"

alias           lf="bat * --paging=never"

alias            k="kill "
alias            K="killall "

alias            h="tldr"
alias            H="man"

alias            m="mv"

alias           sc="systemctl "
alias          scu="systemctl --user "
alias         logs="journalctl "

alias          gch="git checkout -f HEAD"
alias          gcl="git clean -df"
alias           gf="git-forest --reverse"
alias          gDc="git difftool --cached"
alias           gD="git difftool"
alias          gdc="git diff --cached"
alias          gau="git add -u"

alias            f=$FILTER
alias            p=$PAGER
alias         less=$PAGER
alias        zless=$PAGER

alias           cp=xcp
alias          cat=bat
alias           cd=z

alias          rm!='rm -rf'
alias          mv!='mvf'

alias          '.'='nvr -cc ":term ranger $PWD" -c ":norm! i"'
alias -g     '<<<'='tail -f '
alias -g      '~!'='/run/user/$UID'
alias -g      '\\'=' > $(page) '
alias -g      '//'=' | rg --smart-case'
alias -g      '>|'=' > /dev/null 2>&1 '

alias         rtrc='export RUST_BACKTRACE=full && export RUST_LOG=trace'
alias         rdbg='export RUST_BACKTRACE=full && export RUST_LOG=debug'
alias         rinf='export RUST_BACKTRACE=full && export RUST_LOG=info '
alias         rerr='export RUST_BACKTRACE=0    && export RUST_LOG=error'

alias            c='cargo'
alias           cb='cargo build'
alias           cr='cargo run -- '
alias           ct='[[ "$(pwd)" == */target/debug ]] && z ... || cd target/debug'



#                              Functions

preexec () {
    [ -z "$NVIM" ] && return
    WORDS=(${1// *|*})
    export PAGE_BUFFER_NAME="${WORDS[@]:0:2}"
}

chpwd () {
    [ ! -z "$NVIM" ] && nvr -cc "let b:working_dir = '$PWD'"
}

man () {
    PROGRAM="${@[-1]}"
    SECTION="${@[-2]}"
    page "man://$PROGRAM${SECTION:+($SECTION)}"
}

mkd() { mkdir -p $* && cd $1 }
mkp() { mkdir -p $* }
mvd() { mkdir $2 && mv $1 $2 && cd $2 }
mvp() { mv $1 .. && cd .. }
mvf() { dir=${@:$#} && mkdir -p $dir && mv ${@:1:(( $# - 1 ))} $dir }

bk() { cp -r $1 ~$1~ }
kb() { cp -r ~$1~ $1 }

acd() { P=$1.mount; mkdir $P && archivemount $1 $P && cd $P; }
abd() { P=$1.mount; umount $P && rm -r $P }

v() {
    if [ -t 1 ] && [ 1 -eq $# ] && [ -d $1 ]; then
        cd $1
    else
        nv $*
    fi
}



#                             Settings

setopt extendedglob

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
unsetopt completealiases

setopt rm_star_wait

setopt interactive_comments

echo -e '\e[>4;1m' # enables ctrl-tab in neovim

zmodload zsh/zpty
