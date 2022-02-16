# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/massaUpdate.sh -o massaUpdate.sh && sudo bash massaSetup.sh

# Update massa testnet node
# https://github.com/massalabs/massa/wiki/update

cd ~
rustup default nightly
sleep 30s
rustup update
sleep 30s

cd massa
git stash
git checkout testnet
git pull
sleep 30s
git pull

RUST_BACKTRACE=full cargo run --release |& tee logs.txt

# cd massa/massa-node/
# source $HOME/.cargo/env
# nohup cargo run --release &

# sleep 10m

# cd massa/massa-client/
# cargo run
# sleep 10m

# wallet_info

# wallet_new_privkey
# wallet_info
