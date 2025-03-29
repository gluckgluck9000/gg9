#!/usr/bin/env bash

iso8601utc() {
  TZ='Etc/UTC' date '+%Y-%m-%dT%H:%M:%S'
}


_LEVEL_DEBUG=1
_LEVEL_INFO=2
_LEVEL_WARN=3
_LEVEL_ERROR=4

_LOG_FILE_NAME=$GG9__LOG_FILE_NAME
[[ -n $_LOG_FILE_NAME ]] || _LOG_FILE_NAME="/dev/stdout"

log_level() {
  case $1 in
    1)
      printf "DEBUG"
      ;;
    2)
      printf "INFO"
      ;;
    3)
      printf "WARN"
      ;;
    4)
      printf "ERROR"
      ;;
    *)
      printf ""
      ;;
  esac
}

logln_debug() {
  _MSG=$@
  logln "${_LEVEL_DEBUG}:${@}" 
}
logln_info() {
  _MSG=$@
  logln "${_LEVEL_INFO}:${@}" 
}
logln_warning() {
  _MSG=$@
  logln "${_LEVEL_WARN}:${@}" 
}
logln_error() {
  _MSG=$@
  logln "${_LEVEL_ERROR}:${@}" 
}

logln() {
  IFS=""
  _LOG_LEVEL=$(sed -e 's/:.*$//g' <<< $@)
  _LOG_MESSAGE=$(sed -e 's/^[^:]*://g' <<< $@)
  printf "%s | %s | %s\n" $(iso8601utc) $(log_level $_LOG_LEVEL) $_LOG_MESSAGE > $_LOG_FILE_NAME
}

case $0 in
  *debugln)
    logln_debug $@
    ;;
  *infoln)
    logln_info $@
    ;;
  *warnln)
    logln_warning $@
    ;;
  *errorln)
    logln_error $@
    ;;
  *)
    logln $@
    ;;
esac

