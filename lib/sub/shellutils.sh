colorize() {
  color=$1; shift
  [ "$1" = "-n" ] && newline=1 && shift
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

error() {
  red -n "$@" 1>&2
  exit 1
}

status() {
  cyan "$(printf "%16s" "$1")"
  shift
  echo " $@"
}

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
