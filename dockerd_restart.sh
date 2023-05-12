# mkdir -p ~/dockerd_restart && curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/dockerd_restart.sh -o ~/dockerd_restart/dockerd_restart.sh && chmod +x ~/dockerd_restart/dockerd_restart.sh && sudo bash ~/dockerd_restart/dockerd_restart.sh
#!/bin/bash

# 杀死所有正在运行的docker容器
ps axf | grep docker | grep -v grep | awk '{print "kill -9 " $1}' | sudo sh

# 启动docker服务
/usr/bin/dockerd -H unix:// > /dev/null 2>&1 &

