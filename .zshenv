export PERL_HOME="/usr/bin/perl:/usr/bin/core_perl"
export JAVA_HOME="/usr/lib/jvm/default"

export HASKELL_BIN="$HOME/.cabal/bin"
export RUST_BIN="$HOME/.cargo/bin"


export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib"

export RUST_SRC_PATH="/usr/src/rust/src"


export ANDROID_STUDIO_HOME="/opt/android-studio"
if [[ -e $ANDROID_STUDIO_HOME ]]; then
    PATH="$PATH:$ANDROID_STUDIO_HOME/bin"
fi

export ANDROID_HOME="/opt/android-sdk"
export ANDROID_NDK_ROOT="/opt/android-ndk"
if [[ -e $ANDROID_HOME ]]; then
    if [[ -e $ANDROID_HOME/build-tools ]]; then
        ANDROID_BUILD_AVAILABLE="$(ls -Art $ANDROID_HOME/build-tools)"
        ANDROID_BUILD_LASTEST="$ANDROID_HOME/build-tools/$(echo $ANDROID_BUILD_AVAILABLE | head -n 1)"
        PATH="$PATH:$ANDROID_BUILD_LASTEST"
    fi
    ANDROID_TOOLS="$ANDROID_HOME/tools/:$ANDROID_HOME/platform-tools"
    PATH="$PATH:$ANDROID_HOME:$ANDROID_TOOLS"
fi


PATH="/bin:/usr/local/bin:/usr/local/sbin:$PATH:$HOME/.bin:$RUST_BIN:$JAVA_HOME:$PERL_HOME:$HASKELL_BIN"
export PATH



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

export DATE=$(date +%F)

export LD_PRELOAD="/usr/lib/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}"

systemctl --user import-environment PATH
systemctl --user import-environment JAVA_HOME
systemctl --user import-environment GTK_MODULES
systemctl --user import-environment UBUNTU_MENUPROXY


source /etc/profile.d/*
