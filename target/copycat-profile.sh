# Copycat target prompt: yellow =^-^= so you can tell it from copycat-kali (green =^.^=).
__cc_prompt() {
  if [ $? -eq 0 ]; then __cc_face='=^-^='; __cc_col=33; else __cc_face='=^x^='; __cc_col=31; fi
}
PROMPT_COMMAND=__cc_prompt
PS1='\[\e[1;${__cc_col}m\]${__cc_face}\[\e[0m\] \[\e[1;36m\]\u@copycat-target\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
