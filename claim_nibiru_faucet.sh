FAUCET_URL="https://faucet.itn-1.nibiru.fi/"
ADDR=$(echo $key | nibid keys show wallet -a)
curl -X POST -d '{"address": "'"$ADDR"'", "coins": ["11000000unibi","100000000unusd","100000000uusdt"]}' $FAUCET_URL
