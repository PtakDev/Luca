#!/bin/bash
ls | grep azure > /home/sinensia/piotrCarpeta/bash/remove_pip_azure/listPCKGs
File="listPCKGs"
Lines=$(cat $File)
for Line in $Lines
do
	rm -rf /usr/lib/python3/dist-packages/"$Line"
done
