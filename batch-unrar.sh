#!/bin/bash
for i in $(find $(pwd) -name '*.rar')
do
cd $(dirname $i)
unrar x $i
done
