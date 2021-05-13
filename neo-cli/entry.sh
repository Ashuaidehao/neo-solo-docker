#!/bin/sh

# run app in background
screen -dmS node dotnet neo-cli.dll -r

rpc_host=http://localhost:20332
until $(curl -m 10 --output /dev/null --silent --head --fail $rpc_host); do
    printf 'Connecting..\n'
    sleep 5
done

printf 'Ok\n'

if [ -z "$INIT_ADDRESS" ]
then
      echo "\$INIT_ADDRESS is empty"
else
      echo "\$INIT_ADDRESS is $INIT_ADDRESS"
fi

if test -f inited; 
then
    echo "Inited"
else
    curl --location --request POST $rpc_host \
    --header 'Content-Type: application/json' \
    --data-raw '{"jsonrpc": "2.0","method": "openwallet","params": ["my-wallet.json","123456"],"id": 1}'

    curl --location --request POST $rpc_host \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "jsonrpc": "2.0",
        "id": 1,
        "method": "sendmany",
        "params": [
            "NND9o7jxgLJG2VcZfC7S62EWyoVDvDRXWy",
            [
                {
                    "asset": "0xef4073a0f2b305a38ec4050e4d3d28bc40ea63f5",
                    "value": 100000000,
                    "address": "'"$INIT_ADDRESS"'"
                },
                {
                    "asset": "0xd2a4cff31913016155e38e474a2c06d08be276cf",
                    "value": "2999999900000000",
                    "address": "'"$INIT_ADDRESS"'"
                }
            ]
        ]
    }'

    touch inited
fi

# keep container runnning 
/bin/sh
# sleep infinitys