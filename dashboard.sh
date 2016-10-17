#!/bin/bash

DIRECTORY_TO_EVALUATE=$1

sloc $DIRECTORY_TO_EVALUATE > sloc.tmp 
TOTAL=$(cat sloc.tmp | grep 'Physical' | awk '{print $3}')
SOURCE=$(cat sloc.tmp | grep 'Source' | awk '{print $3}')
COMMENTS=$(cat sloc.tmp | grep 'Comment' | awk '{print $3}')
rm -rf sloc.tmp

# Report the lines
echo "Total lines: "$TOTAL "Source lines: "$SOURCE "Comment lines: "$COMMENTS

# Report to dashboard
BODY="code_size,platform=ios total=$TOTAL,source=$SOURCE,comments=$COMMENTS"
curl -XPOST 'http://halo-dashboard.aws.mobgen.com:8086/write?db=halo' --data-binary "$BODY"