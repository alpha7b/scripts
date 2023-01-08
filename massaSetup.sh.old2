# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/massaSetup.sh -o massaSetup.sh && sudo bash massaSetup.sh
# setup massa testnet node
# https://docs.massa.net/en/latest/testnet/install.html

# terminate all massa screen session
echo "Display all screen sessions"
screen -ls
echo "Terminate all massa screen sessions"
screen -S massa -X quit
echo "Display all screen sessions"
screen -ls

sleep 5s

# set version
read -p "Enter Massa Version: " MassaVersion
echo $MassaVersion

cd ~/massa
rm -rf massa_TEST.*
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

# start node in screen session
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
