_sub() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(sub commands --shallow)" -- "$word") )
  else
    local command=("${COMP_WORDS[@]:1:${COMP_CWORD}-1}")
    local completions="$(sub completions "${command[@]}")"
    local IFS=$'\n'
    local candidates=($(compgen -W "${completions[*]}" -- "$word"))

    if [ ${#candidates[*]} -eq 0 ]; then
      return 1
    else
      COMPREPLY=($(printf '%q\n' "${candidates[@]}"))
    fi
  fi
}

complete -o default -F _sub sub
