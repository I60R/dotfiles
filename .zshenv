export PERL_HOME="/usr/bin/perl:/usr/bin/core_perl"
export JAVA_HOME="/usr/lib/jvm/default"



export ANDROID_HOME="/opt/android-sdk"
export ANDROID_NDK_ROOT="/opt/android-ndk"
export ANDROID_STUDIO_HOME="/opt/android-studio"

if [[ -e $ANDROID_STUDIO_HOME ]]; then
    PATH="$PATH:$ANDROID_STUDIO_HOME/bin"
fi

if [[ -e $ANDROID_HOME ]]; then
    if [[ -e $ANDROID_HOME/build-tools ]]; then
        PATH="$PATH:$ANDROID_HOME/build-tools/$(ls -Art $ANDROID_HOME/build-tools | head -n 1)"
    fi
    PATH="$PATH:$ANDROID_HOME:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
fi



export PATH="$PATH:$HOME/.local/bin:$JAVA_HOME:$PERL_HOME"



export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib"
export LD_PRELOAD="/usr/lib/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"



if [[ $(lsmod | rg "nouveau") ]]; then
    export LIBVA_DRIVER_NAME=nouveau
    export VDPAU_DRIVER=nouveau
    export GDK_BACKEND=wayland
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_DESKTOP=sway
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM=wayland
else
    export GDK_BACKEND=x11
    export XDG_SESSION_TYPE=x11
    export XDG_CURRENT_DESKTOP=xfce4
    export XDG_SESSION_DESKTOP=xfce4
    export MOZ_ENABLE_WAYLAND=0
    export QT_QPA_PLATFORM=xcb
fi

export XCURSOR_THEME=Fuchsia
export XCURSOR_SIZE=22

export QT_SELECT=5
export QT_STYLE_OVERRIDE=kvantum

export GTK_THEME=Qogir-ubuntu-light

export WINIT_HIDPI_FACTOR=1.33

export _JAVA_AWT_WM_NONREPARENTING=1



export XDG_CONFIG_DIR="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export ZDOTDIR="$HOME/.config/zsh"
export HISTFILE="$XDG_DATA_HOME"/zsh/history



export EDITOR="nvr"
export VISUAL="nvr"
export MANPAGER="page -C -e 'au User PageDisconnect sleep 100m|%y p|enew! |bd! #|pu p| Man!'"
export PAGER="page -q 90000 -O"
export BROWSER="firefox"
export FILTER="fzf --reverse --inline-info --height=40 --ansi --color=dark,bg+:-1,border:0,info:8,prompt:8,hl:34,hl+:34,pointer:34 --bind=tab:down,btab:up"



systemctl --user import-environment PATH
systemctl --user import-environment JAVA_HOME
