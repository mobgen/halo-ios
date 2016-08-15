#!/bin/sh

cd Source
jazzy -m 'Halo SDK' -a 'MOBGEN Technology' -c -o ../docs -x '-workspace,../HALO.xcworkspace,-scheme,Halo' --module 'Halo' --min-acl 'public' --hide-documentation-coverage
