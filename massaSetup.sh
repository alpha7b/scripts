# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/massaSetup.sh -o massaSetup.sh && sudo bash massaSetup.sh
# setup massa testnet node
# https://docs.massa.net/en/latest/testnet/install.html

# set vars
read -p "Enter Massa Version: " MassaVersion
echo "Massa Version is:" $MassaVersion
read -p "Enter Address: " Address
echo "Address is:" $Address
read -p "Enter SecretKey: " SecretKey

function main(){
    terminate_existing_massa_screen_session
    install_node
    start_node_in_screen_session
    start_staking_in_client
}
# terminate all massa screen session
function terminate_existing_massa_screen_session(){
    echo "Display all screen sessions"
    screen -ls
    echo "Terminate all massa screen sessions"
    screen -S massa -X quit
    echo "Display all screen sessions"
    screen -ls
    sleep 5s
}

function install_node(){
    cd ~/massa
    rm -rf massa_TEST.*
    echo "Massa Version is:" $MassaVersion
    wget https://github.com/massalabs/massa/releases/download/TEST.$MassaVersion/massa_TEST.$MassaVersion'_release_linux.tar.gz'
    tar -xvf massa_TEST.$MassaVersion'_release_linux.tar.gz'
    pwd
    ls
    sleep 5s

    # add these info to ~/massa/massa-node/base_config/config.toml
    # [network]
    # routable_ip = "xxx.xxx.xxx.xxx"
    sed -i "/\[network\]/a\    routable_ip = \"$(curl -s ifconfig.me)\"" ~/massa/massa/massa-node/base_config/config.toml
    cat ~/massa/massa/massa-node/base_config/config.toml
    sleep 5s
}

# start node in screen session
function start_node_in_screen_session(){
    echo 'Start massa node in screen session'
    screen -dmS "massa" bash -c "
    echo 'Start massa node in screen session'; 
    pwd;
    cd ~/massa/massa/massa-node/; 
    pwd; 
    ls;
    ./massa-node -p 123 |& tee logs.txt;
    sleep 40s;
    bash
    "
    echo 'Wait 300s till node is started'
    sleep 300s
    cd ~/massa/massa/massa-client/
    ./massa-client -p 123 get_status
}

# start staking in client
function start_staking_in_client(){    
    cd ~/massa/massa/massa-client/
    NodeStatus=$(./massa-client -p 123 get_status)
    echo "Node status is:" $NodeStatus
    STATUS=$(./massa-client -p 123 get_status | grep error)
    echo "Status is:" $STATUS
    if [ -z "$STATUS" ]; then 
        echo 'Node is running, wills start staking'
        ./massa-client -p 123 get_status
        ./massa-client -p 123 wallet_info
        echo "Address is:" $Address
        ./massa-client -p 123 buy_rolls $Address 1 0
        sleep 120s
        ./massa-client -p 123 wallet_info
        ./massa-client -p 123 node_add_staking_secret_keys $SecretKey
        currentUtcTime=$(date)
        echo 'Current UTC Time is:' $currentUtcTime
        echo 'Staking started, wait 120min to operate in discord'

        else
        echo 'Node is not running, please check in massa screen session'
    fi
}

main "$@"
