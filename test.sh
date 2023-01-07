# curl -sL https://raw.githubusercontent.com/alpha7b/scripts/main/test.sh -o test.sh && sudo bash test.sh
screen -S test* -X quit

screen -dmS "test" bash -c "echo 'start massa node in screen session'; pwd; pwd; pwd; bash"
