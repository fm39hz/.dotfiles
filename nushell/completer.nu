let fish_completer = {|place|
    fish --command $"complete '--do-complete=($place.command | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
        let value = $row.value
        let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
        if ($need_quote and ($value | path exists)) {
            let expanded_path = if ($value starts-with ~) {
                $value | path expand --no-symlink
            } else {
                $value
            }
            $'"($expanded_path | str replace --all "\"" "\\\"")"'
        } else {
            $value
        }
    }
}

let carapace_completer = {|place: record|
    CARAPACE_LENIENT=1 carapace $place.command.0 nushell ...$place.command | from json
}

let external_completer = {|place: record|
    match $place.command.0 {
        nu => null
        ls => null
        cd => null
        rm => null
        _ => (do $fish_completer $place)
    }
}

$env.config = {
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 100
            completer: $external_completer
        }
    }
}
