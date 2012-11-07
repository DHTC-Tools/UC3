#!/bin/bash
cat output/mcpi.out.*  | grep "\[1\]" | awk '{sum+=$2} END { print "Average = ", sum/NR}'
