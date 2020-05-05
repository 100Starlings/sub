if [[ ! -o interactive ]]; then
    return
fi

compctl -K _sub + sub

_sub() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(sub commands --shallow)"
  else
    completions="$(sub completions "${words[2,-2][@]}")"
  fi

  if [ -z $completions ]; then
    reply=()
  else
    reply=("${(ps:\n:)completions}")
  fi
}
