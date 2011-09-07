-------
 About
-------

A semi-hastily hacked together twitter bot in bash for tweeting whole bible verses using the ESV.  Also known as a personal project to learn a bit more about bash.

When installing, please include a 'config.sh' file in the src/ folder and enter your account details there.  A sample config is provided.

Thanks to 360percents.com for the twitter api script in src/tweeter.sh (modified) :)


--------
 Issues
--------

* 140 characters at splitter is more than 140 characters according to tweeter
* some juggling with numbers in splitter - not quite sure what is happening, but at least it works
* pretty poor separation of anything really :(
* echoed variables include \n I think, which is an issue if it's supposed to be in a url (grabber)
* .bookmark doesn't HAVE to be an invisible file really..
