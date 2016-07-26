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

export step_counter=0
step() {
  step_counter=$[step_counter+1]
  func=$1
  shift
  if [[ -z $skip_steps || $skip_steps -lt $step_counter ]]; then
    bold $(blue "Step $step_counter: ")
    blue -n "$@"
    _line_prefix="  "
    $func
    _line_prefix=
  else
    bold $(blue "Skipping step $step_counter: ")
    blue -n "$@"
  fi
}
export -f step

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
