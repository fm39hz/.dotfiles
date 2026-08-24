for d in "$HOME/.cargo/bin" "$HOME/go/bin" "$HOME/.cache/.bun/bin" "$HOME/.dotnet/tools" "$HOME/.local/bin" "$HOME/.local/share/Steam/steamapps/common/Aseprite"
    if test -d "$d"
        contains -- "$d" "$PATH" || set -g -x PATH "$d" $PATH
    end
end