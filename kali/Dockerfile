FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Docker base images strip man pages; put them back so `man` is real.
RUN rm -f /etc/dpkg/dpkg.cfg.d/docker /etc/dpkg/dpkg.cfg.d/excludes \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      openssh-server openssh-client sudo init-system-helpers \
      man-db manpages less nano vim-tiny file tree bc \
      procps psmisc lsof cron rsyslog plocate \
      iputils-ping iproute2 net-tools traceroute bind9-dnsutils \
      curl wget rsync sshpass \
      zip unzip tar gzip bzip2 xz-utils \
      bsdextrautils ncal diffutils findutils sqlite3 \
 && apt-get clean && rm -rf /var/lib/apt/lists/* \
 && mandb -q || true

# --- users and groups (all real; see seed/generate.sh for passwords) ---
RUN groupadd students && groupadd developers && groupadd admins \
 && useradd -m -s /bin/bash -G sudo,students copycat \
 && useradd -m -s /bin/bash -G developers alex \
 && useradd -m -s /bin/bash -G students sam \
 && useradd -m -s /bin/bash -G developers,admins jordan \
 && echo 'copycat:copycat' | chpasswd \
 && echo 'alex:password'   | chpasswd \
 && echo 'sam:password'    | chpasswd \
 && echo 'jordan:password' | chpasswd

# --- sshd: password login on, root login off, host keys baked in so they survive resets ---
RUN ssh-keygen -A && mkdir -p /run/sshd \
 && sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/; s/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# rsyslog in a container has no kernel log to read
RUN sed -i 's/^module(load="imklog"/#&/' /etc/rsyslog.conf

# --- the training filesystem ---
COPY seed/generate.sh /tmp/generate.sh
COPY labs/ /tmp/labs/
RUN bash /tmp/generate.sh /home/copycat /tmp/labs && rm -rf /tmp/generate.sh /tmp/labs \
 && updatedb

COPY kali/lib/color.sh kali/lib/grade.sh /usr/local/lib/copycat/
# Graded-lab checks and their setup scripts live outside ~/labs so the answers are not on the
# student's path. Root owns them; sudoers lets the student run only the setup scripts (as root),
# because they deliberately break things (root-owned files and so on).
COPY grading/ /usr/local/lib/copycat/grading/
RUN find /usr/local/lib/copycat/grading -name '*.sh' -exec chmod 755 {} + \
 && printf '%s\n' 'copycat ALL=(root) NOPASSWD: /usr/local/lib/copycat/grading/*/setup.sh' \
      > /etc/sudoers.d/copycat-grading \
 && chmod 440 /etc/sudoers.d/copycat-grading
COPY kali/motd /usr/local/share/copycat/motd.txt
COPY kali/copycat-bashrc /tmp/copycat-bashrc
RUN cat /tmp/copycat-bashrc >> /home/copycat/.bashrc && rm /tmp/copycat-bashrc
COPY kali/bin/ /usr/local/bin/
RUN chmod +x /usr/local/bin/* \
 && COPYCAT_FORCE_COLOR=1 /usr/local/bin/copycat > /etc/motd

COPY kali/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
HEALTHCHECK --interval=10s --timeout=3s --retries=5 CMD bash -c '</dev/tcp/127.0.0.1/22' || exit 1
ENTRYPOINT ["/entrypoint.sh"]
