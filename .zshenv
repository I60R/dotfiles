export PERL_HOME="/usr/bin/perl:/usr/bin/core_perl"
export JAVA_HOME="/usr/lib/jvm/default"

export HASKELL_BIN="$HOME/.cabal/bin"
export RUST_BIN="$HOME/.cargo/bin"

export RUST_SRC_PATH="/usr/src/rust/src"


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


export PATH="$PATH:$HOME/.local/bin:$RUST_BIN:$JAVA_HOME:$PERL_HOME:$HASKELL_BIN"



export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib"
export LD_PRELOAD="/usr/lib/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"



export QT_SELECT=5
export QT_STYLE_OVERRIDE=gtk

if [ -n "$GTK_MODULES" ]; then
    GTK_MODULES="${GTK_MODULES}:appmenu-gtk-module"
else
    GTK_MODULES="appmenu-gtk-module"
fi

if [ -z "$UBUNTU_MENUPROXY" ]; then
    UBUNTU_MENUPROXY=1
fi

export UBUNTU_MENUPROXY
export GTK_MODULES

#export _JAVA_OPTIONS="${_JAVA_OPTIONS} -javaagent:/usr/share/java/jayatanaag.jar"
#export JAYATANA_FORCE=1



export EDITOR="nvr"
export VISUAL="nvr"
export MANPAGER="nvr -c 'set ft=man' - "
export PAGER="page"
export BROWSER="firefox"
export SELECT="sk --reverse -e --height=40 --ansi"



systemctl --user import-environment PATH
systemctl --user import-environment JAVA_HOME
systemctl --user import-environment GTK_MODULES
systemctl --user import-environment UBUNTU_MENUPROXY
