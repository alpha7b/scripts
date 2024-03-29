# crontab job
# 30 1-23/2 * * * export apiToken="<apiToken>" && mkdir -p ~/hopr && curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/hoprd_restart_cron.sh -o ~/hopr/hoprd_restart_cron.sh && chmod +x ~/hopr/hoprd_restart_cron.sh && sudo bash ~/hopr/hoprd_restart_cron.sh $apiToken
#!/bin/bash
export apiToken=$1
export hoprdImage="gcr.io/hoprassociation/hoprd:1.93.5"

# terminate old screen and container
screen -ls | awk '/hoprd/ {print $1}' | awk -F. '{print $1}' | xargs -I{} screen -X -S {} quit
screen -ls
screen -wipe
sleep 3s
docker kill $(docker ps -a -q --filter ancestor=$hoprdImage)
sleep 10s
docker rm $(docker ps -a -q --filter ancestor=$hoprdImage)
docker ps -a --filter ancestor=$hoprdImage
sleep 5s

# create new screen and container
screen -dmS "hoprd" bash -c "
    echo 'Start hoprd in screen session'; 
    pwd;
    cd cd ~/hopr; 
    pwd; 
    ls;
    docker run --pull always --restart always \
    -m 2g --log-driver json-file \
    --log-opt max-size=100M --log-opt max-file=5 -ti \
    -v $HOME/.hoprd-db-monte-rosa:/app/hoprd-db \
    -p 9091:9091/tcp -p 9091:9091/udp -p 8080:8080 -p 3001:3001 \
    -e DEBUG="hopr*" $hoprdImage \
    --environment monte_rosa --init --api \
    --identity /app/hoprd-db/.hopr-id-monte-rosa \
    --data /app/hoprd-db \
    --password 'open-sesame-iTwnsPNg0hpagP+o6T0KOwiH9RQ0' \
    --apiHost "0.0.0.0" \
    --apiToken $apiToken \
    --healthCheck \
    --healthCheckHost "0.0.0.0";
    sleep 40s;
    bash"
