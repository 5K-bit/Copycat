FROM alpine:3.20

RUN apk add --no-cache openssh rsync bash busybox-extras curl iputils iproute2 procps tree \
 && ssh-keygen -A \
 && adduser -D -s /bin/bash student \
 && echo 'student:student' | chpasswd \
 && sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/; s/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

COPY home/ /home/student/
COPY www/ /var/www/
COPY motd /tmp/motd.txt
RUN awk 'NR>=2 && NR<=4 { printf "\033[38;5;220m%s\033[0m\n", $0; next } NR==5 { printf "\033[2m%s\033[0m\n", $0; next } { print }' /tmp/motd.txt > /etc/motd \
 && rm /tmp/motd.txt
COPY copycat-profile.sh /etc/profile.d/copycat.sh
RUN echo '[ -r /etc/profile.d/copycat.sh ] && . /etc/profile.d/copycat.sh' > /home/student/.bashrc \
 && chown -R student:student /home/student && chmod -R a+rX /var/www

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 22 80
ENTRYPOINT ["/entrypoint.sh"]
