#!/bin/sh

targets=("HALOCore" "HALONetworking")

for t in "${targets[@]}"
do
    jazzy -x -target,$t -o ../docs/$t -a "MOBGEN Technology" -m $t
done
