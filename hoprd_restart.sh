# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/hoprd_restart.sh -o hoprd_restart.sh && sudo bash hopr_restart.sh $apiToken

export ipAddr=$(curl ifconfig.me)
echo "ipAddr is: "
echo $ipAddr
export hoprdImage="gcr.io/hoprassociation/hoprd:1.92.9"
echo $hoprdImage

# terminate hoprd screen session
function terminate_existing_hoprd_screen_session(){
    echo "Display all screen sessions before terminating"
    screen -ls
    echo "Terminate hoprd screen sessions"
    screen -ls | awk '/hoprd/ {print $1}' | awk -F. '{print $1}' | xargs -I{} screen -X -S {} quit
    echo "Display all screen sessions after terminating"
    screen -ls
    sleep 5s
}

# stop running hoprd container
function stop_running_hoprd_container(){
    echo "Display all hoprd containers"
    docker ps -a --filter ancestor=$hoprImage
    echo "stop running hoprd container"
    docker stop $(docker ps -a -q --filter ancestor=$hoprdImage --filter status=running)
    sleep 20s
    echo "remove exited hoprd container"
    docker rm $(docker ps -a -q --filter ancestor=$hoprdImage --filter status=exited)
    echo "Display all hoprd containers"
    docker ps -a --filter ancestor=$hoprdImage
    sleep 5s
}

# start hoprd in screen session
function start_hoprd(){
    cd ~
    mkdir -p hopr
    cd ~/hopr
    echo 'Start hoprd node in screen session'
    screen -dmS "hoprd" bash -c "
        echo 'Start hoprd in screen session'; 
        pwd;
        cd cd ~/hopr; 
        pwd; 
        ls;
        docker run --pull always --restart on-failure -m 2g --log-driver json-file --log-opt max-size=100M --log-opt max-file=5 -ti -v $HOME/.hoprd-db-monte-rosa:/app/hoprd-db -p 9091:9091/tcp -p 9091:9091/udp -p 8080:8080 -p 3001:3001 -e DEBUG="hopr*" $hoprdImage --environment monte_rosa --init --api --identity /app/hoprd-db/.hopr-id-monte-rosa --data /app/hoprd-db --password 'open-sesame-iTwnsPNg0hpagP+o6T0KOwiH9RQ0' --apiHost "0.0.0.0" --apiToken $apiToken --healthCheck --healthCheckHost "0.0.0.0";
        sleep 40s;
        bash
    "
}
# wait for the old container to be existed and remove old container
function remove_old_hoprd_container(){
    echo 'Remove old hoprd container'
    sleep 30s
    docker ps -a
    echo 'Remove exited hoprd container'
    docker rm $(docker ps -a -q --filter ancestor=$hoprdImage --filter status=exited)
    sleep 30s
    echo 'Remove created hoprd container'
    docker rm $(docker ps -a -q --filter ancestor=$hoprdImage --filter status=created)
    docker ps -a
}

function main(){
    terminate_existing_hoprd_screen_session
    stop_running_hoprd_container
    start_hoprd
    remove_old_hoprd_container
}


main "$@"
