#!/bin/bash
# main program

source src/decider.sh | xargs -0 src/grabber.sh | xargs -0 src/splitter.sh
