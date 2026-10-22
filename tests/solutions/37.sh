r=/home/copycat/labs/37-git-fundamentals/config-repo
bad=$(runuser -u copycat -- git -C "$r" log --format='%H %s' | awk '/Tune timeout for speed/{print $1}')
runuser -u copycat -- git -C "$r" revert --no-edit "$bad" </dev/null
