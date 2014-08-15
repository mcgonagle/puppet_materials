test -s /etc/profile && . /etc/profile || true
test -s ~/.bashrc && . ~/.bashrc || true
PS1="\u@\h:\w>\$ "