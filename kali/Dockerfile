FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Docker base images strip man pages; put them back so `man` is real.
# The apt step retries as a whole: the http.kali.org redirector sometimes hands out a mirror that
# is unreachable (seen on CI), and a retry gets fresh mirror picks.
RUN rm -f /etc/dpkg/dpkg.cfg.d/docker /etc/dpkg/dpkg.cfg.d/excludes \
 && for i in 1 2 3 4; do \
      apt-get update \
      && apt-get install -y --no-install-recommends -o Acquire::Retries=3 \
        openssh-server openssh-client sudo init-system-helpers \
        man-db manpages less nano vim-tiny file tree bc \
        procps psmisc lsof cron rsyslog plocate \
        iputils-ping iproute2 net-tools traceroute bind9-dnsutils \
        curl wget rsync sshpass \
        zip unzip tar gzip bzip2 xz-utils \
        bsdextrautils ncal diffutils findutils sqlite3 \
        git acl e2fsprogs sysstat apt-utils \
      && break; \
      [ "$i" = 4 ] && exit 1; \
      echo "apt failed (attempt $i); retrying, the Kali redirector may pick another mirror"; \
      sleep 5; \
    done \
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
 && printf '%s\n' \
      'copycat ALL=(root) NOPASSWD: /usr/local/lib/copycat/grading/*/setup.sh' \
      'copycat ALL=(root) NOPASSWD: /usr/bin/chage -l taylor, /usr/bin/passwd -S guest' \
      'copycat ALL=(root) NOPASSWD: /usr/bin/getfacl -p /srv/lab24/shared/handbook.txt, /usr/bin/stat -c %a /srv/lab24/shared/handbook.txt, /usr/bin/grep -q Team /srv/lab24/shared/handbook.txt' \
      > /etc/sudoers.d/copycat-grading \
 && chmod 440 /etc/sudoers.d/copycat-grading

# --- troubleshooting mode (copycat-trouble): scenarios that break something real ---
# The student may sudo only `break` and `reset`; `fix` stays root-only and exists for the self-test.
COPY kali/lib/trouble-run.sh /usr/local/lib/copycat/trouble-run.sh
COPY scenarios/ /usr/local/lib/copycat/scenarios/
RUN cd /usr/local/lib/copycat/scenarios \
 && mv bin/copycat-app /usr/local/bin/copycat-app \
 && mv bin/copycat-app.init /etc/init.d/copycat-app \
 && mv bin/fwsim /usr/local/bin/fwsim \
 && rmdir bin \
 && chmod 755 /usr/local/bin/copycat-app /usr/local/bin/fwsim /etc/init.d/copycat-app /usr/local/lib/copycat/trouble-run.sh \
 && mkdir -p /mnt/smalldisk \
 && printf '%s\n' \
      'copycat ALL=(root) NOPASSWD: /usr/local/lib/copycat/trouble-run.sh break *, /usr/local/lib/copycat/trouble-run.sh reset *' \
      > /etc/sudoers.d/copycat-trouble \
 && chmod 440 /etc/sudoers.d/copycat-trouble
# Offline package repository for lab 36 (package troubleshooting).
COPY seed/build-localrepo.sh /tmp/build-localrepo.sh
RUN bash /tmp/build-localrepo.sh && rm /tmp/build-localrepo.sh
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
