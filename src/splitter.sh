#!/bin/bash

sVerse=$*
sEllipsis='..'

sVerse=$(sed -e 's/^[[:space:]]*//'<<<"$sVerse") # remove leading spaces
# declare other constants
iTweetLength=140
iEllipsisLength=$[${#sEllipsis}+2]

bEnoughTweets=0 # raw number of tweets required, ellipses not included
n=1 # current number of tweets
iDisplacedChars=0 # char displacement

while [ $bEnoughTweets != 1 ]; do
# number of chars in verse
	iVerseLength=${#sVerse}
	iTweetQuotient=0
	iPredictedChars=0
# total available characters in the current number of tweets
	let iAvailableChars=$iTweetLength*$n 
	echo '#' tweets[$n] for verse length[$iVerseLength]

# is it at least as long as the verselength?
	if [ $iVerseLength -lt $iAvailableChars ]; then
		bEnoughTweets=1
		if [[ $n -ne 1 ]]; then # last tweet of multiple
			iLengthInString=$[$[iTweetLength-${#iEllipsisLength}]-2]
			sPartVerse=$sEllipsis
			sPartVerse="$sPartVerse ${sVerse:$iDisplacedChars:$iLengthInString}"
		else # entire verse fits in 1 tweet
			sPartVerse=$sVerse
		fi
	else
		if [[ $n -ne 1 ]]; then # not last tweet, not first twet
			iLengthInString=$[$[iTweetLength-$[${#iEllipsisLength}*2]]-5]
			sPartVerse=$sEllipsis
			sPartVerse="$sPartVerse ${sVerse:$iDisplacedChars:$iLengthInString}"
			sPartVerse="$sPartVerse $sEllipsis" # this tweet
			iDisplacedChars=$[iDisplacedChars+$iLengthInString]
		else # first tweet of multiple
			iLengthInString=$[$[iTweetLength-${#iEllipsisLength}]-3]
			sPartVerse=${sVerse:$iDisplacedChars:$iLengthInString}
			sPartVerse="$sPartVerse $sEllipsis" # this tweet
			iDisplacedChars=$iLengthInString
		fi
		n=$(( n+1 ))
	fi
	tweet=${sPartVerse}
	echo Twittering:[$tweet]
	echo length:[${#tweet}]
	./src/tweeter.sh $tweet
done

