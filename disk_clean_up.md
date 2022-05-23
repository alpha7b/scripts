### 查整个系统的磁盘占用情况
`df -h`

### 查当前目录下的文件及文件夹的大小
```
du -h --max-depth=1
du -sh *
```

### shrink /var/log/journal/*
https://unix.stackexchange.com/questions/130786/can-i-remove-files-in-var-log-journal-and-var-cache-abrt-di-usr
Yes you can delete everything inside of /var/log/journal/* but do not delete the directory itself. You can also query journalctl to find out how much disk space it's consuming:

`journalctl --disk-usage`

Edit this file to change the journal max use to 50M
/etc/systemd/journald.conf
SystemMaxUse=50M

`sudo systemctl kill --kill-who=main --signal=SIGUSR2 systemd-journald.service`
`sudo systemctl restart systemd-journald.service`

### capser node consumes too many disk space. the files locates at 
check and delete this folder /var/lib/casper
