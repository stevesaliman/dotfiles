#!/usr/bin/env bash
set -x
db=max_dev
# Figure out where files should go and what they should be called.  This changes
# depending on if we are doing a normal backup or a month-end one.
if [[ "$1" == "monthly" ]]; then
	# On the first of the month at midnight, we'll get a backup which we'll
	# name after the previous month since it has that month's ending
	# snapshot.
	remote_dir="${db}_backup/monthly"
        dt=$(date -d "$(date) -1 day" +%Y-%m)
else
	# the date on the directory is not the same as the one on the file.
        dt=$(date +%Y-%m-%d)
	remote_dir="${db}_backup/regular/$dt"
        dt=$(date +%Y-%m-%d_%H-%M)
fi
backup_dir="/c/tmp/${db}_backup"
backup_file="${backup_dir}/${db}_${dt}.sql"
mysqldump -umax_owner -pm@x0wner --quick --single-transaction --triggers --routines -c $db > $backup_file
gzip -f $backup_file
# We're using rsync instead of scp because rsync will create the daily 
# directory for us.
rsync -tv -e "ssh -i /c/home/salimans/.ssh/sqlbackup.pem -l sqlbackup" ${backup_file}.gz maxdevcloud:${remote_dir}/
#scp -i /home/getsmart/.ssh/sqlbackup.pem ${backup_file}.gz sqlbackup@maxdevcloud:$remote_dir
status=$?
if [ $status -eq 0 ]; then
  rm ${backup_file}.gz
fi
