# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/nym-sandbox.sh -o nym-sandbox.sh && sudo bash nym-sandbox.sh

# setup nym testnet sandbox
# https://nymtech.net/docs/stable/run-nym-nodes/build-nym

# Install packages
sudo apt update
sudo apt install pkg-config build-essential libssl-dev curl jq -y

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Download & build Nym binaries
cd ~
rustup update
git clone https://github.com/nymtech/nym.git
cd nym
git reset --hard # in case you made any changes on your branch
git pull # in case you've checked it out before

# Note: the default branch you clone from Github, `develop`, is guaranteed to be
# broken and incompatible with the running testnet at all times. You *must*
# `git checkout tags/v0.12.1` in order to join the testnet.

git checkout tags/v0.12.1
sleep 1
ls
cargo build --release
