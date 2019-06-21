#!/bin/bash

for i in lp nobody uucp games rpm smmsp nfsnobody listen gdm webservd
do
	echo "passwd -l $i"

done


