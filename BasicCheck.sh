#!/bin/bash

#$1 is the folder name
#$2 is the exe name(the file to execute)
arguments=$@ #if there is arguments make sure you save them
#path=$(find "$1" -name 'Makefile*')
path="$1"

if [[ $path != "" ]]
then
	echo "Found"
else
	echo "Not found"
fi
cd  $path
make #creating .exe file
#make MAIN=<path-to-cpp-file-with-main-program>.cpp

#st=$(make -f Makefile* --directory="$1")

#make -f Makefile
goodmake=$? #val checking if make command worked
if [ $goodmake -gt 0 ]
then echo "there is no makefile"
	exit 7
else
	goodmake=0
fi

#checking memory leak
valgrind --leak-check=full --log-file=/dev/null --error-exitcode=1  ./$2 $arguments > /dev/null
goodval=$?
#echo $goodval

if [ $goodval -eq 0 ]
then
	goodval=0
else
	goodval=1
fi

#checking thread race
valgrind --tool=helgrind --error-exitcode=1 ./$2 $arguments  &>/dev/null
goodhel=$? #for checking the threads

if [ $goodhel -eq 0 ]
then
	goodhel=0
else
	goodhel=1
fi

if [ $goodmake -eq 0 ]
then
	make=PASS
else
	make=FAIL
fi
if [ $goodval -eq 0 ]
then
	val=PASS
else
	val=FAIL

fi
if [ $goodhel -eq 0 ]
then
	hal=PASS
else
	hal=FAIL
fi

#convert the result to binary and exit the final answer
answer=$goodmake$goodval$goodhel
#echo "compiltion"    "memory leaks"    "thread race"
#echo   "   $make  "	  "       $val   "	    "   $hal    "
#echo  "final exit :"$answer
if [ $answer -eq 010 ] 
then 
	exit 2
elif [ $answer -eq 011 ] 
then
	exit 3
elif [ $answer -eq 001 ] 
then 
	exit 1
fi

