<pre>
Name:        log.lua
Usage:       lua log.lua
Commands:    exit, quit -> end logging
             view       -> takes a date in format YYYYMMDD and prints log for that day
             view today|yesterday -> prints relative log
Version:     1
Description:
A command line tool for taking notes during your day. Each note is timestamped in a log for that day.

Example session:
λ lua log.lua

log >> hello world
logged
log >> view today

Log for date: 20200322
----------------------
[21:37:47] hello world

log >> hi again
logged
log >> view today

Log for date: 20200322
----------------------
[21:37:47] hello world
[21:37:53] hi again

log >> exit
</pre>
