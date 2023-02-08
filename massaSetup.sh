# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/massaSetup.sh -o massaSetup.sh && sudo bash massaSetup.sh
# setup massa testnet node
# massa node will be running in screen session massa_node
# buy rolls and stake rolls will be operated in screen session massa_client
# https://docs.massa.net/en/latest/testnet/install.html

# set vars
read -p "Enter Massa Version: " MassaVersion
echo "Massa Version is:" $MassaVersion
read -p "Enter Address: " Address
echo "Address is:" $Address
read -p "Enter Node password: " passwd
echo "Node password is:" $passwd
# read -p "Enter SecretKey: " SecretKey

function main(){
    terminate_existing_massa_screen_session
    install_node
    start_node
    start_staking
}

# terminate all massa screen session
function terminate_existing_massa_screen_session(){
    echo "Display all screen sessions before terminating"
    screen -ls
    echo "Terminate all massa screen sessions"
    screen -S massa -X quit
    screen -S massa_node -X quit
    screen -S massa_client -X quit
    echo "Display all screen sessions after terminating"
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

# start node in screen session massa_node
function start_node(){
    echo 'Start massa node in screen session'
    screen -dmS "massa_node" bash -c "
        echo 'Start massa node in screen session'; 
        pwd;
        cd ~/massa/massa/massa-node/; 
        pwd; 
        ls;
        ./massa-node -p $passwd |& tee logs.txt;
        sleep 40s;
        bash
    "
    echo 'Wait 300s till node is started'
    sleep 300s
    cd ~/massa/massa/massa-client/
    ./massa-client -p $passwd get_status
}

# start staking in screen session massa_client
function start_staking(){    
    cd ~/massa/massa/massa-client/
    NodeStatus=$(./massa-client -p $passwd get_status)
    echo "Node status is:" $NodeStatus
    STATUS=$(./massa-client -p $passwd get_status | grep error)
    echo "Status is:" $STATUS
    
    # check if STATUS is empty, it indicates node is running.
    if [ -z "$STATUS" ]; then
        echo 'Node is running, wills start staking'
        screen -dmS "massa_client" bash -c "
            pwd;
            cd ~/massa/massa/massa-client/;
            pwd;
            ./massa-client -p $passwd get_status;
            ./massa-client -p $passwd wallet_info;
            echo 'Address is:' $Address;
            echo '======buy_rolls=======';
            ./massa-client -p $passwd buy_rolls $Address 1 0;
            sleep 120s;
            ./massa-client -p $passwd wallet_info;
            echo '======node_start_staking=======';
            ./massa-client -p $passwd node_start_staking $Address;
            echo 'Current UTC Time is:' $(date);
            echo 'Staking started, wait 100min to operate in discord';
            sleep 100m;
            echo 'Current UTC Time is:' $(date);
            echo '100 minutes passed, show wallet_info again';
            ./massa-client -p $passwd wallet_info;
            echo 'If active roll is 1, please operate in discord';
            bash            
        "
        echo 'Staking started in screen session massa_client, wait 100min to operate in discord'
        
        else
        echo 'Node is not running, please check in massa screen session massa_node'
    fi
}

main "$@"
