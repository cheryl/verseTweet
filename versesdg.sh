#!/bin/bash
# testing
# 0. at the correct time,
# 1. decide which verse and format the request
# (decider.sh) calls grabverse.php
# 2. grab it from esv.
# (grabverse.php) outputs plaintext verse
# 3. split it into the appropriate lines if necessary
# (splitter.sh) - calls tweeter in a loop
# 4. tweet it
# (tweeter.sh)

#php src/grabverse.php | xargs -0 src/tweeter.sh
#echo 'here is a verse of great interest and significance because it comes from the Word of God, living and active and powerful to change lives' | xargs -0 src/splitter.sh

source src/decider.sh | xargs -0 src/grabber.sh | xargs -0 src/splitter.sh
