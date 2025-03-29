#!/usr/bin/env bash

_debugln() {
  ./debugln $@
}
_infoln() {
  ./infoln $@
}
_warnln() {
  ./warnln $@
}
_errorln() {
  ./errorln $@
}

display_usage() {
  printf "sup suckers\n"
}

test $# -eq 0 && display_usage

verbose_exit() {
  IFS=""
  _ERROR_MESSAGE=$(sed -e 's/:.*$//g' <<< $@)
  _ERROR_CODE=$(sed -e 's/^[^:]*://g' <<< $@)
  if [[ -z $_ERROR_CODE ]]; then
    _ERROR_CODE=1
  fi
  [[ -n $_ERROR_MESSAGE ]] && _errorln $(printf "error: %s" $_ERROR_MESSAGE)
  exit $_ERROR_CODE
}

verify_dependency() {
  _DEP=$(sed -e 's/^[^=]*=\{0,1\}//g' <<< $1)
  [[ -n $_DEP ]] || verbose_exit "must supply dependency to check:1"
  _DEP=$(sed -e 's/^[^=]*=//g' <<< $1)
  _debugln $(printf "VERIFYING AVAILABILITY OF: %s\n" $_DEP)
  if [[ -n $(command -v $_DEP) ]]; then
    _infoln $(printf "FOUND AVAILABLE COMMAND: %s\n" $_DEP)
  else
    _warnln $(printf "NO AVAILABLE COMMAND: %s\n" $_DEP)
  fi
}

prepare_environment() {
  _CMD=$(sed -e 's/^[^=]*=\{0,1\}//g' <<< $1)
  [[ -n $_CMD ]] || verbose_exit "must supply preparation executable to run:1"
  if [[ -x $_CMD ]] || [[ -n $(command -v $_CMD) ]]; then
    _infoln $(printf "RUNNING PREPARATION EXECUTABLE: %s\n" $_CMD)
    [[ -n $(command -v $_CMD) ]] && $_CMD
    [[ -n $(command -v $_CMD) ]] || bash $_CMD
  else
    [[ -e $_CMD ]] && _warnln $(printf "NOT EXECUTABLE: %s\n" $_CMD)
    [[ -e $_CMD ]] || _warnln $(printf "DOES NOT EXIST: %s\n" $_CMD)
  fi
}

while test $# -gt 0; do
  case "$1" in
    --verify*)
      verify_dependency $1
      shift
      ;;
    --prepare*)
      prepare_environment $1
      shift
      ;;
    --log-file*)
      printf "nothing\n"
      ;;
    *)
      shift
      display_usage
      break
      ;;
  esac
done

