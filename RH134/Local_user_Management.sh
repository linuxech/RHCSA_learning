#!/usr/bin/bash

file_path=users_lists.txt   #Files contains the list of users

for U in $(cat $file_path);	#using cat as variable to read the file_path
do useradd $U;
done

for U in $(cat $file_path);			#min - 5
do chage -m 5 -M 90 -W 8 -I 5 $U;		#max - 90
done						#warn - 8
						#Inactive - 5



