export _line_prefix=
colorize() {
  color=$1; shift
  [ "$1" = "-n" ] && local newline=1 && shift
  if [[ $newline == "1" && -n $_line_prefix ]]; then
    echo -en "${color}$_line_prefix\033[0m"
  fi
  echo -en "${color}$@\033[0m"
  if [ "$newline" = "1" ]; then
    echo
  fi
}
bold() {
  colorize "\033[1m" "$@"
}
black() {
  colorize "\033[30m" "$@"
}
red() {
  colorize "\033[31m" "$@"
}
green() {
  colorize "\033[32m" "$@"
}
yellow() {
  colorize "\033[33m" "$@"
}
blue() {
  colorize "\033[34m" "$@"
}
purple() {
  colorize "\033[35m" "$@"
}
cyan() {
  colorize "\033[36m" "$@"
}
white() {
  colorize "\033[37m" "$@"
}
on_black() {
  colorize "\033[40m" "$@"
}
on_red() {
  colorize "\033[41m" "$@"
}
on_green() {
  colorize "\033[42m" "$@"
}
on_yellow() {
  colorize "\033[43m" "$@"
}
on_blue() {
  colorize "\033[44m" "$@"
}
on_purple() {
  colorize "\033[45m" "$@"
}
on_cyan() {
  colorize "\033[46m" "$@"
}
on_white() {
  colorize "\033[47m" "$@"
}
export -f colorize bold black red green yellow blue purple cyan white
export -f on_black on_red on_green on_yellow on_blue on_purple on_cyan on_white

error() {
  red -n "$@" 1>&2
  exit 1
}
export -f error

status() {
  cyan "$(printf "%16s" "$1")"
  shift
  echo " $@"
}
export -f status

export _step_counter=0 _step_skip= _step_list= _step_countdown= _step_confirm=
step_options_for_completion() {
  echo --skip-steps
  echo --list-steps
  echo --step-countdown
  echo --confirm-steps
}
step_process_args() {
  remaining_args=()
  while [[ $# -gt 0 ]]; do
    local arg=$1
    shift

    case $arg in
      -S | --skip-steps )
        _step_skip=$1
        shift
        ;;
      -L | --list-steps )
        _step_list=1
        ;;
      -W | --step-countdown )
        _step_countdown=1
        ;;
      -C | --confirm-steps )
        _step_confirm=1
        ;;
      * )
        remaining_args+=("$arg")
        ;;
    esac
  done
}
step_countdown() {
  local seconds=5
  while [[ $seconds -gt 0 ]]; do
    purple "\a\r  starting step in $seconds..."
    sleep 1
    seconds=$[seconds-1]
  done
  echo -ne "\r                       \r" # clear line before moving on
}
step() {
  _step_counter=$[_step_counter+1]

  if [[ $1 == "-h" ]]; then
    local harmless=1
    shift
  fi

  func=$1
  shift

  if [[ -z $_step_skip || $_step_skip -lt $_step_counter ]]; then
    bold $(blue "Step $_step_counter: ")
    blue -n "$@"
    if [[ -z $_step_list ]]; then
      if [[ -z $harmless && $_step_confirm ]]; then
        purple -n "  Press return to continue"
        read -s
      elif [[ -z $harmless && $_step_countdown ]]; then
        step_countdown
      fi
      _line_prefix="  "
      $func
      _line_prefix=
    fi
  else
    bold $(blue "Skipping step $_step_counter: ")
    blue -n "$@"
  fi
}
export -f step_options_for_completion step_process_args step_countdown step

ensure_in_repo() {
  local repo=$1
  local symlink="$HOME/.Sub/$repo"

  [[ -L $symlink && -d $symlink ]] && cd "$(readlink $symlink)"

  if ! git remote -v 2>/dev/null | grep -q Sub/$repo; then
    bold $(blue "Where is your local copy of the $repo repo? ") >&2
    read dir
    mkdir -p ~/.Sub
    rm -f $symlink
    [ ${dir:0:2} = "~/" ] && dir="$HOME/${dir:2}"
    ln -s $dir $symlink
    cd $dir
  fi
}
export -f ensure_in_repo
