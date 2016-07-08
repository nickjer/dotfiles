SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${normal}"
SCM_GIT_CHAR="${bold_green}±${normal}"
SCM_SVN_CHAR="${bold_cyan}⑆${normal}"
SCM_HG_CHAR="${bold_red}☿${normal}"

is_vim_shell() {
  if [ ! -z "$VIMRUNTIME" ]
  then
    echo "[${cyan}vim shell${normal}]"
  fi
}

modern_scm_prompt() {
  CHAR=$(scm_char)
  if [ $CHAR = $SCM_NONE_CHAR ]
  then
    return
  else
    echo "[$(scm_char)][$(scm_prompt_info)]"
  fi
}

prompt() {
  local EXIT=$?
  if [ ${EXIT} -ne 0 ]; then
    PS1="${red}┌─[${bold_white}${EXIT}${red}]${normal}[${bold_green}\u@\h${normal}][${bold_blue}\w${normal}]$(modern_scm_prompt)$(is_vim_shell)\n${red}└─▪${normal} "
  else
    PS1="┌─[${bold_green}\u@\h${normal}][${bold_blue}\w${normal}]$(modern_scm_prompt)$(is_vim_shell)\n└─▪${normal} "
  fi
}

PS2="└─▪\e[0m\] "
PS3=">> "

PROMPT_COMMAND=prompt
