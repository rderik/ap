#!/bin/bash

_ap_wrapper()
{
  declare -a cur prev
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  COMPREPLY=()
  _ap
}
# Generates completions for ap
#
# Parameters
# - the start position of this parser; set to 1 if unknown
function _ap
{
    if [[ $COMP_CWORD == $(($1+0)) ]]; then
            return
    fi
    if [[ $COMP_CWORD == $1 ]]; then
        COMPREPLY=( $(compgen -W "--input -i --generate-bash-completion -g --names -n --last-names -l" -- $cur) )
        return
    fi
    case $prev in
        (--input|-i)
            _filedir
            return
        ;;
        (--generate-bash-completion|-g)
            return
        ;;
        (--names|-n)
            return
        ;;
        (--last-names|-l)
            COMPREPLY=( $(compgen -W "Ramirez Garcia Allende" -- $cur) )
            return
        ;;
    esac
    case ${COMP_WORDS[$1]} in
    esac
    COMPREPLY=( $(compgen -W "--input -i --generate-bash-completion -g --names -n --last-names -l" -- $cur) )
}

complete -F _ap_wrapper ap