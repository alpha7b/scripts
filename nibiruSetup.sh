# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/nibiruSetup.sh -o nibiruSetup.sh && sudo bash nibiruSetup.sh
# setup nibiru testnet node
# https://nibiru.fi/docs/run-nodes/testnet/

# set vars
read -p "Enter moniker name: " moniker
echo "moniker name is:" $moniker

function main(){
    build_nibiru
    init_chain
#     create_nibiru_service
#     start_nibiru_service
}

function build_nibiru(){
    cd ~
    mkdir -p nibiru
    cd nibiru
    git clone https://github.com/NibiruChain/nibiru
    cd nibiru
    git checkout  v0.19.2
    make install
    sleep 20s
}

function init_chain(){
    pwd
    cd ~/nibiru
    nibid init $moniker --chain-id=nibiru-itn-1
    nibid config chain-id nibiru-itn-1
    curl -Ls https://snapshots.kjnodes.com/nibiru-testnet/genesis.json > $HOME/.nibid/config/genesis.json
    curl -Ls https://snapshots.kjnodes.com/nibiru-testnet/addrbook.json > $HOME/.nibid/config/addrbook.json
    sed -i -e "s|^seeds *=.*|seeds = \"3f472746f46493309650e5a033076689996c8881@nibiru-testnet.rpc.kjnodes.com:39659\"|" $HOME/.nibid/config/config.toml
    sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025unibi\"|" $HOME/.nibid/config/app.toml
    curl -L https://snapshots.kjnodes.com/nibiru-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.nibid
    [[ -f $HOME/.nibid/data/upgrade-info.json ]] && cp $HOME/.nibid/data/upgrade-info.json $HOME/.nibid/cosmovisor/genesis/upgrade-info.json
}

# function create_nibiru_service(){
#     sudo tee <<EOF >/dev/null /etc/systemd/system/nibid.service
#     [Unit]
#     Description=nibid daemon
#     After=network-online.target
#     [Service]
#     User=$USER
#     ExecStart=$(which nibid) start
#     Restart=on-failure
#     RestartSec=3
#     LimitNOFILE=10000
#     [Install]
#     WantedBy=multi-user.target
#     EOF
# }

# function start_nibiru_service(){
#     sudo systemctl daemon-reload
#     sudo systemctl enable nibid
#     sudo systemctl start nibid
#     journalctl -u nibid -f --no-hostname -o cat
# }

main "$@"
