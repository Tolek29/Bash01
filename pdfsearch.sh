#!/bin/bash

#script search given html files containing links to a pdf (<a>) files (and downloads selected)

filename=

function extractLinksFromFiles {
	for file in ${files[@]}; do
		echo "$file"
		links=($(grep -o "<a href=\"http[[:graph:]]*pdf\"" $file | cut -d\" -f2))
		echo "Number of links founded ${#links[@]}"
		for link in ${links[@]}; do
			downloadPdf $link
		done
	done
}

function checkHtmlFiles() {
	echo "Checking files"
	while [ -n "$1" ]; do
		echo "Checking: $1"
		if [ -r "$1" ]; then
			files+=($1)
			echo "\"$1\" exists and is readable"
		else
			echo "\"$1\" doesn't exists or is not readable"
		fi
		shift
	done
}

function getName() {
	filename=
	while [ ! -n "$filename" ]; do
		read -p "Enter file name for pdf file:" filename
		if [[ ! "$filename" =~ \.pdf$ ]]; then
			filename="$filename.pdf"
		fi
	done
	echo $filename
}

function downloadPdf() {
	read -p "Download $1 ?(Y,y - yes; q,Q - exit; * - ommit current ):" download
	
	case $download in
		Q|q) echo "Program terminated."
			 exit
			;;
		Y|y) ;;
		*) continue
			;; 
	esac
	getName
	echo "Downloading $1"
	curl -so $filename $1
	echo "File downloaded"
}


files=()
clear
checkHtmlFiles "$@"
extractLinksFromFiles
checkHtmlFiles



