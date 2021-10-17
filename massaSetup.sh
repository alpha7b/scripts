# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/massaSetup.sh -o massaSetup.sh && sudo bash massaSetup.sh

# setup massa testnet node
# https://gitlab.com/massalabs/massa/-/tree/testnet

cd ~
rm -rf massa*

sudo apt update
sudo apt install pkg-config curl git build-essential libssl-dev
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -1
source $HOME/.cargo/env
rustc --version
rustup toolchain install nightly
rustup default nightly
rustc --version

git clone --branch testnet https://gitlab.com/massalabs/massa.git
cd massa/massa-node/
RUST_BACKTRACE=full cargo run --release |& tee logs.txt
