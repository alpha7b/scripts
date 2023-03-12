# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/3-massa_restart.sh -o 3-massa_restart.sh && sudo bash 3-massa_restart.sh
# check if massa node is still running, if not, start it and re-restaking

# # set vars
# read -p "Enter Massa Version: " MassaVersion
# echo "Massa Version is:" $MassaVersion
# read -p "Enter Address: " Address
# echo "Address is:" $Address
# read -p "Enter Node password: " passwd
# echo "Node password is:" $passwd

function main(){
    start_staking
}

# start staking in screen session massa_client
function start_staking(){    
    cd ~/massa/massa/massa-client/
    NodeStatus=$(./massa-client -p $passwd get_status)
    echo "Node status is:" $NodeStatus
    STATUS=$(./massa-client -p $passwd get_status | grep error)
    echo "Status is:" $STATUS
    
    # check if STATUS is empty, it indicates node is running.
    
    if [ ! -z "$STATUS" ]; then
        echo 'Node is not running, will start node'
        while [ ! -z "$STATUS" ]
        do
           # code to be executed repeatedly as long as the condition is true
           echo 'Node is not running, will start node and re-staking'
           screen -S massa_node -X stuff './massa-node -p $passwd |& tee logs.txt\n'
           sleep 300s
           cd ~/massa/massa/massa-client/
           NodeStatus=$(./massa-client -p $passwd get_status)
           echo "Node status is:" $NodeStatus
           STATUS=$(./massa-client -p $passwd get_status | grep error)
           echo "Status is:" $STATUS
        done
        
        echo 'node is running, will re-stake'
        screen -S massa_client -X quit
        sleep 5s
        cd ~/massa/massa/massa-client/
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
        echo 'Staking started in screen session massa_client'
        echo 'Current UTC Time is:' $(date)
        
        else
        echo 'Node is still running, do nothing'
        
    fi
}

main "$@"
