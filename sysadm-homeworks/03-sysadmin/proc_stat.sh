#!/bin/bash
ps --no-header -o stat ax > listing.tmp
echo $(cat listing.tmp | grep D -c) "\tD\tuninterruptible sleep (usually IO)"
echo $(cat listing.tmp | grep I -c) "\tI\tIdle kernel thread"
echo $(cat listing.tmp | grep R -c) "\tR\trunning or runnable (on run queue)"
echo $(cat listing.tmp | grep S -c) "\tS\tinterruptible sleep (waiting for an event to complete)"
echo $(cat listing.tmp | grep T -c) "\tT\tstopped by job control signal"
echo $(cat listing.tmp | grep t -c) "\tt\tstopped by debugger during the tracing"
echo $(cat listing.tmp | grep W -c) "\tW\tpaging (not valid since the 2.6.xx kernel)"
echo $(cat listing.tmp | grep X -c) "\tX\tdead (should never be seen)"
echo $(cat listing.tmp | grep Z -c) "\tZ\tdefunct ("zombie") process, terminated but not reaped by its parent"
