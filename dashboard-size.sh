#!/bin/bash

# PARAMS
## Count
## Platform
## Color
function createSerie {
	local serie
	SERIE_START='{"name":"'$(echo $2)'", "color":"'$(echo $3)'",'
	SERIE_DATA='"data": [['$(date +%s000)','$(echo $1)']]}'
	serie=$SERIE_START$SERIE_DATA
	echo $serie
}

if [ $# -lt 4 -a $# -gt 1 ]; then
	if [ "$(type -t ./node_modules/sloc/bin/sloc)" != "file" ]; then
		npm install sloc
	fi

	$(./node_modules/sloc/bin/sloc -k total,source,comment -e $3 $2 >> tmp.txt) 
	PHYSICAL=$(cat tmp.txt | grep 'Physical' | awk '{print $3}')
	SOURCE=$(cat tmp.txt | grep 'Source' | awk '{print $3}')
	COMMENTS=$(cat tmp.txt | grep 'Comment' | awk '{print $3}')
	rm tmp.txt

	PLATFORM=$1

	SERIES=$(createSerie $PHYSICAL $PLATFORM" Total LOC" "blue")
	SERIES=$SERIES","$(createSerie $SOURCE $PLATFORM" Source LOC" "green")
	SERIES=$SERIES","$(createSerie $COMMENTS $PLATFORM" Comment LOC" "gray")

read -d '' JSON << EOF
	{ 
	    "auth_token": "p}Xat7#Wv=mRc9[m",
	    "xAxis": {
	        "type": "datetime"
	    },
	    "useSeriesNames": true,
	    "series": [
	    	$SERIES
	    ]
	}
EOF

	echo "Total lines: "$PHYSICAL
	echo "Source lines: "$SOURCE
	echo "Comment lines: "$COMMENTS
	echo $JSON

	curl -X PUT -d "$JSON" \http://52.30.218.175:3030/widgets/size
else
	echo "Run as: sh ./haloLineCount.sh 'Platform' 'Dir' 'Exclude Regexp'"
fi