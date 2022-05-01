# https://moul.notion.site/Gno-New-testnet-wallet-71c7507e6ea548d5bee6be32d57390cd
# https://gno.land/r/boards:gnolang/4

# ========== step 1: install node =============
# 1. update to latest golang, https://github.com/FUSIONFoundation/efsn
add-apt-repository ppa:longsleep/golang-backports
apt-get update
apt-get install golang-go build-essential

# 2. download the repo
git clone https://github.com/gnolang/gno/
cd gno

# 3. compile the gnokey binary
make gnokey

# 4. verify that the binary works
./build/gnokey --help

========== step 2: setup accounts =============

# 1. generate Mnemonic
./build/gnokey generate

# 2. create account by Mnemonic
./build/gnokey add myaccount --recover
./build/gnokey list

# 3 Get some testnet tokens using the Faucet 
# https://gno.land/faucet

# 4 Check account
./build/gnokey query auth/accounts/<ADDRESS> --remote gno.land:36657


# ========== step 3: Create a board with a smart contract call =============
./build/gnokey maketx call rr01 --pkgpath "gno.land/r/boards" --func CreateBoard --args "BOARDNAME" --gas-fee 1gnot --gas-wanted 2000000 > createboard.unsigned.txt
./build/gnokey sign rr01 --txpath createboard.unsigned.txt --chainid "testchain" --number ACCOUNT_NUMBER --sequence SEQUENCE_NUMBER > createboard.signed.txt
./build/gnokey broadcast createboard.signed.txt --remote gno.land:36657
