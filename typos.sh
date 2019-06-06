#! /bin/bash

typos()
{
# error handling

if [[ "$#" -ne 3 ]]
then
	echo -e "illegal number of arguements.\n$0 <input file> <dictionary file> <top n typos>"
	return 1
fi

if [ ! -f $1 ];
then
	echo "input file not found"
	return 1
fi

if [ ! -f $2 ];
then
	echo "dictionary file not found"
	return 1
fi

if [[ ! "$3" =~ ^[0-9]+$ ]]
then
	echo "arguement 3 must be an integer"
	return 1
fi

# start typo list

touch typos.txt

# use input file without punctuation

cat $1 | tr -d '[:punct:]' > temp.txt

# read and search for each word per line

while IFS= read -r line; do
	for word in $line; do
		if grep -wim 1 "$word" $2 1> /dev/null; 
			#if [ awk '{ T=$0; gsub(/[^a-zA-Z]+/, "", T) } (T ~ MATCH)' MATCH="[=$word=]" /usr/share/dict/words ];
		then
			:
		else
			echo $word >> typos.txt
		fi
	done
done < temp.txt

# print results to terminal
cat typos.txt | sort | uniq -c | sort -rk 1 -rk 2 | head -$3

rm temp.txt typos.txt

return 0
}

typos $1 $2 $3
