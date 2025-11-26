#!/usr/bin/bash


num=18

if [[ $num -gt 18 ]];
then
	echo "You are eligible for DL"

elif [[ $num -lt 18 ]];
then
	echo "You are inelgible for DL application"
else
   echo "Perfect! You match the eligibility for the DL"
fi

