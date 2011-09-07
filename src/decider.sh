#!/bin/bash

# array of books of the bible (names)
books=(
    'ge'
    'ex'
    'le'
    'nu'
    'deu'
    'jos'
    'judg'
    'ru'
    '1s'
    '2s'
    '1k'
    '2k'
    '1ch'
    '2ch'
    'ezr'
    'neh'
    'es'
    'job'
    'ps'
    'pr'
    'ecc'
    'so'
    'is'
    'jer'
    'lam'
    'eze'
    'da'
    'ho'
    'joe'
    'am'
    'ob'
    'jon'
    'mi'
    'nah'
    'hab'
    'zeph'
    'hag'
    'zec'
    'mal'
    'mt'
    'mr'
    'lu'
    'joh'
    'ac'
    'ro'
    '1co'
    '2co'
    'ga'
    'ep'
    'phil'
    'co'
    '1th'
    '2th'
    '1ti'
    '2ti'
    'ti'
    'phile'
    'heb'
    'ja'
    '1p'
    '2p'
    '1jo'
    '2jo'
    '3jo'
    'jude'
    're'
    )

bookindex="`sed -n 1p .bookmark`" # has to be shifted to 0
bookindex=$[bookindex-1]
book=${books[$bookindex]}
chapter="`sed -n 2p .bookmark`" # string comparison with xml, doesn't need shifting
verse="`sed -n 3p .bookmark`" # string comparison with xml, doesn't need shifting
bibleindex=${#books[*]}
bibleindex=$[bibleindex-1]


#####################
# correct anomalies #
#####################

if [ ${bookindex} -gt $bibleindex ] # for some reason -ge kills re. dunno.
then
	bookindex=$bibleindex
	book=${books[$bookindex]}
	chapter=1
	verse=1
elif [ ${bookindex} -lt 0 ]
then
	bookindex=0
	book=${books[$bookindex]}
	chapter=1
	verse=1
fi

# check the max number of chapters in the current book.
xchaptersperbook=`curl --silent -G -d 'key=IP&q='$book'1-150' 'http://www.esvapi.org/v2/rest/queryInfo'`
tmp=${xchaptersperbook#*<readable>} # strip prefix
chapterstring=${tmp%</readable>*} # strip suffix
for word in $chapterstring
do
	chapternum=$word # take the last one
done
if [ ${chapternum} == '1' ]
then
	maxchapters=1
else
	maxchapters=${chapternum:2}
fi
if [[ ${chapter} -ge $maxchapters ]]; then
	chapter=$maxchapters
fi

# check max number of verses in the current chapter.
xversesperchapter=`curl --silent -G -d 'key=IP&q='$book"$chapter" 'http://www.esvapi.org/v2/rest/queryInfo'`
tmp=${xversesperchapter#*<verse-count>}
maxverses=${tmp%</verse-count>*}
if [ ${verse} -ge ${maxverses} ]
then
	verse=$maxverses
fi

echo $book$chapter:$verse


##################
# bookmarks      #
# after the echo #
##################

# uh, just make sure bookmarks are always correct. x_x.

if [ ${verse} -ge $maxverses ] # check if we can use next verse
then
	if [ ${verse} -gt $maxverses ]
	then
		verse=$maxverses
		sed -i "3s/.*/$verse/" .bookmark
	else # equal, check if we can use next chapter
		if [ ${chapter} -ge $maxchapters ]
		then
			if [ ${chapter} -gt $maxchapters ]
			then
				chapter=$maxchapters
				sed -i "2s/.*/$chapter/" .bookmark
			else # equal, check if we can use next book
				if [ ${bookindex} -ge $bibleindex ]
				then
					if [ ${bookindex} -gt $bibleindex ]
					then
						bookindex=$[bibleindex+1]
					else # end of bible, start again
						bookindex=1
						chapter=1
						verse=1
						sed -i "2s/.*/$chapter/" .bookmark
						sed -i "3s/.*/$verse/" .bookmark
					fi
				else # use next book
						bookindex=$[bookindex+2]
						chapter=1
						verse=1
						sed -i "2s/.*/$chapter/" .bookmark
						sed -i "3s/.*/$verse/" .bookmark
				fi
				sed -i "1s/.*/$bookindex/" .bookmark
			fi
		else # use the next chapter
			chapter=$[chapter+1]
			verse=1
			sed -i "2s/.*/$chapter/" .bookmark
			sed -i "3s/.*/$verse/" .bookmark
		fi
	fi
else # use the next verse
	verse=$[verse+1]
	sed -i "3s/.*/$verse/" .bookmark
fi

