#!/bin/sh
# This is a comment!

most_recent=`ls MOM6.log.* | tail -1`
vi $most_recent
