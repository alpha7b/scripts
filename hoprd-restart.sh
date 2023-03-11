# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/hoprd-restart.sh -o hoprd-restart.sh && sudo bash hoprd-restart.sh

function main(){
    terminate_existing_hoprd_screen_session
    start_hoprd
}

# terminate all massa screen session
function terminate_existing_massa_screen_session(){
    echo "Display all screen sessions before terminating"
    screen -ls
    echo "Terminate hoprd screen sessions"
    screen -S hoprd -X quit
    echo "Display all screen sessions after terminating"
    screen -ls
    sleep 5s
}

# start hoprd in screen session
function start_hoprd(){
    cd ~/hopr
    echo 'Start hoprd node in screen session'
    screen -dmS "hoprd" bash -c "
        echo 'Start hoprd in screen session'; 
        pwd;
        cd cd ~/hopr; 
        pwd; 
        ls;
        docker run --pull always --restart on-failure -m 2g --log-driver json-file --log-opt max-size=100M --log-opt max-file=5 -ti -v $HOME/.hoprd-db-monte-rosa:/app/hoprd-db -p 9091:9091/tcp -p 9091:9091/udp -p 8080:8080 -p 3001:3001 -e DEBUG="hopr*" gcr.io/hoprassociation/hoprd:1.92.9 --environment monte_rosa --init --api --identity /app/hoprd-db/.hopr-id-monte-rosa --data /app/hoprd-db --password 'open-sesame-iTwnsPNg0hpagP+o6T0KOwiH9RQ0' --apiHost "0.0.0.0" --apiToken $apiToken --healthCheck --healthCheckHost "0.0.0.0";
        sleep 40s;
        bash
    "
}
# remove old docker container
function remove_old_hoprd_container(){
    docker ps -a
    docker rm $(docker ps -a -q --filter ancestor=gcr.io/hoprassociation/hoprd:1.92.9 --filter status=exited)
    docker ps -a
}

main "$@"
