#!/bin/bash
# in production, change final script source to the esv api
source src/config.sh

vref="$*"

options='include-passage-references=false'
options=$options'&output-format=plain-text'
options=$options'&include-first-verse-numbers=false'
options=$options'&include-verse-numbers=false'
options=$options'&include-footnotes=false'
options=$options'&include-short-copyright=false'
options=$options'&include-passage-horizontal-lines=false'
options=$options'&include-heading-horizontal-lines=false'
options=$options'&include-headings=false'
options=$options'&include-subheadings=false'
options=$options'&include-selahs=false'
options=$options'&line-length=500'
options=$options'&correct-end-punctuation=false'

# because vref includes a newline. duh
valuefromapi=`curl --silent -G "http://www.esvapi.org/v2/rest/verse?key=$key&$options&passage=$vref"`

# add a link
link='esv.to/'$vref;
verse=$valuefromapi' '$link;

echo $verse
