# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/massaSetup.sh -o massaSetup.sh && sudo bash massaSetup.sh

# setup massa testnet node
# https://docs.massa.net/en/latest/testnet/install.html

# terminate all massa screen session
screen -S massa* -X quit

cd ~/massa
wget https://github.com/massalabs/massa/releases/download/TEST.18.0/massa_TEST.18.0_release_linux.tar.gz
tar -xvf massa_TEST.18.0_release_linux.tar.gz
pwd

# add these info to ~/massa/massa-node/base_config/config.toml
# [network]
# routable_ip = "xxx.xxx.xxx.xxx"
sed -i "/\[network\]/a\    routable_ip = \"$(curl -s ifconfig.me)\"" ~/massa/massa/massa-node/base_config/config.toml
cat ~/massa/massa/massa-node/base_config/config.toml

# start node in screen session

screen -dmS "massa" bash -c """
echo "let's start massa node in screen session"
pwd
cd ~/massa/massa/massa-node/
./massa-node -p 123 |& tee logs.txt
bash
"""
