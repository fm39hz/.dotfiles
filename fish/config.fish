if status is-interactive
    # Commands to run in interactive sessions can go here
end
# Ibus config
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
# Android Studio config
export ANDROID_HOME=$HOME/Android/Sdk
set -U fish_user_paths $ANDROID_HOME/emulator $fish_user_paths 
set -U fish_user_paths $ANDROID_HOME/platforms-tools  $fish_user_paths 
set fish_greeting ""
