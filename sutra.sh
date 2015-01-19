#!/bin/bash
#
# Copyright (c) 2014 Simon Arjuna Erat (sea)  <erat.simon@gmail.com>
# All rights reserved.
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# ------------------------------------------------------------------------
#
#	File:		sutra2
#	Author: 	Simon Arjuna Erat (sea)
#	Contact:	erat.simon@gmail.com
#	License:	GNU Lesser General Public License (LGPL)
#	Created:	2014.07.27
#	Changed:	2014.07.27
	script_version=0.0.1
	TITLE="sutra"
#	Description:	Text
#			...
#			...
#
#
#	Script Environment
#
	ME="${0##*/}"			# Basename of $0
	ME="${ME/.sh/}"			# Cut off .sh extension
	[[ ! "." = "$(dirname $0)" ]] && \
		ME_DIR="$(dirname $0)" || \
		ME_DIR="$(pwd)"		# Dirname of $0
	
	ME_DIR=/usr/share/$ME/
	CFG_DIR="$HOME/.config/$ME"	# Configuration directory
	CONFIG="$CFG_DIR/$ME.conf"	# Configuration file
	CONFIG_FILE_ARRAY=("$CONFIG")	# An array of all configuration scripts used by sutra2
	LOG="$CFG_DIR/$ME.log"		# Logfile
	tempfile="$CFG_DIR/$ME.tmp"	# Tempfile
	#REQUIRES="pack ages as string"
	#mach="/home/sea/prjs/tui/bin/tui-printf -E "
	#$mach "test"
	#exit
#
#	Help text
#
	help_text="
$ME ($script_version)
${TITLE^}
Usage: 		$ME [options] [arguments]
Examples:	$ME -a
		$ME -e optVAL
		$ME ARG
Where options are:
	-h(elp) 		This screen
	-C(onf			Show the config/setup dialog
	-a(bout)		About the authors (translations of books)
	-----------------------------------------------------------------
	-b	'FULL NAME'	The books name
	-c	NUM		Chapters number
	-v	NUM		Vers's number
	

Files:
--------------------------------------
Script:		$ME
Script-Dir:	$ME_DIR
Config: 	$CONFIG
Config_Dir:	$CFG_DIR
Log:		$LOG
Tempfile:	$tempfile
"
#
#	Configuration file template
#
	config_template="#!/bin/bash
# Configuration file for $ME ($script_version) by Simon Arjuna Erat (sea)
#
#	Variables
#
	lang=german
		
"
#
#	Functions
#
	doLog() { # "MESSAGE STRING"
	# Prints: Time & "Message STRING"
	# See 'tui-log -h' for more info
		tui-log -t "$LOG" "$1"
	}
	
	MenuSetup() { # 
	# Configures the variables/files used by the script
	#
	#	Check for config file
	#
		 [[ -d "$CFG_DIR" ]] || mkdir -p "$CFG_DIR"
		 [[ -f "$CONFIG" ]] || \
			( printf "$config_template" > "$CONFIG" ; doLog "Config: Default configuration created" )
	#
	#	Menu entries
	#
		opwd=$(pwd)
		cd "$CFG_DIR"
	#
	#	Menu / Action
	#
		current=$(tui-conf-get $CONFIG lang)
		tui-echo "Your current language choice is:" "$current"
		tui-yesno "Change this?" || return 0
		select newlang in $(cd $ME_DIR/lang/; ls|grep ^[a-z]);do break;done
		tui-conf-set $CONFIG lang $newlang
	}
#
#	Environment checks
#
	# This is optimized for a one-time setup
	if [[ ! -e "$CONFIG" ]]
	then	[[ -d "$CFG_DIR" ]] || 			( mkdir -p "$CFG_DIR" ; tui-echo "Entering first time setup." "$SKIP" )
		[[ ! -e "$LOG" ]] && \
			touch $LOG && \
			doLog "------------------------------------------" && \
			doLog "Created logfile of $ME ($script_version)" && \
			doLog "------------------------------------------" && \
			doLog "Setup : First config"
		sleep 0.5
		MenuSetup
	fi
	. "$CONFIG"
	# Load default values before argument handling
	myLanguage="german"	# Hardcoded default (because of config file)
	myBook=""
	myChap=""
	myVers=""
	langs=""
	unset lblChapter[@] lblVers[@] lblTitle[@] lblLanguage[@] 
	unset lblChooseBookOne[@] lblChooseBook[@] lblChooseBookDone[@] 
	unset lblNoPath[@] lblAboutTitle[@] langRevlbl[@] langRevCommentlbl
	source "$CONFIG" || \
		( doLog "Failed to load: $CONFIG" ; tui-status 1 "Failed to load: $CONFIG" )
#
#	Catching Arguments
#
	#[[ -z $1 ]] && printf "$help_text" && exit $RET_FAIL
	# A ':' after a char indicates that this option requires an argument
	while getopts "ab:c:v:hCL" opt
	do 	case $opt in
		a)	# This is about
			tui-header "$ME ($script_version)" "written by: Simon Arjuna Erat (sea)"
			for lang in $DIR/lang/[A-Z]*;do
				books=""
				this="$(basename $lang)"
				LANG="$this"
				this="${this:0:1}"
				this_cap="${this^^}"
				if [ "$this" = "$this_cap" ]
				then	tui-title "${TITLE[$LANG]}"
					tui-title "${lblAboutTitle[$LANG]}" #"Installed Languages & Books"
					tui-echo "${lblLanguage[$LANG]}:" "$LANG"
					source "${lang,,}"
					tui-echo "${LangRevlbl[$LANG]}:" 	"${LangRevval[$LANG]}"
					tui-echo "Authors:" 			"${LangAuthors[@]}" 
					tui-echo "${LangRevCommentlbl[$LANG]}" 	"${LangRevComment[$LANG]}"
					
					for b in "$lang"/*;do 
						books+=" $b"
						tui-title "${lblTitle[$LANG]}: ${b:(${#lang} + 1)}"
						CHAPTERS=( "$b"/* )
						unset chaps[@]
						for CHAPTER in "${CHAPTERS[@]}" ;do
							cd "${CHAPTER}"
							chaps=( $(ls) )
							tui-echo "${lblChapter[$LANG]}: ${CHAPTER:${#b} + 1}" \
								"${lblVers[$LANG]}: ${#chaps[@]}"  
						done
					done
					
				fi
			done
			exit 0
			;;
		b)	# book
			myBook="$OPTARG"
			;;
		c)	# chapter
			myChap="$OPTARG"
			;;
		v)	# vers
			myVers="$OPTARG"
			;;
		h)	printf "$help_text"
			exit $RET_HELP
			;;
		L)	less "$LOG"	
			exit $RET_DONE
			;;
		C)	MenuSetup
			exit $RET_DONE
			;;
		# *)	printf "$help_text" ; exit $?	;;
		esac
	done
	shift $(($OPTIND - 1))
#
#	Verify Variables
#
	[[ -z $lang ]] && lang=$myLanguage
	list_books=( $(cd $ME_DIR/lang/${lang^};ls) )
	
	# BOOK
	[[ -z $myBook ]] && myBook=${list_books[$(rnd $[ ${#list_books[@]} -1 ] )]}
	BOOK_DIR="$ME_DIR/lang/${lang^}/$myBook"
	list_chaps=( $(cd $BOOK_DIR;ls))
	
	# CHAPTER
	[[ -z $myChap ]] && \
		myChap=${list_chaps[$(rnd $[ ${#list_chaps[@]} -1 ] )]} || \
		myChap=$(cd $BOOK_DIR;ls *_${myChap}_*)
	THISFILE=$BOOK_DIR/$myChap
	
	# VERS
	list_verses=$(grep -v "#" $THISFILE|wc -l )
	[[ -z $myVers ]] && myVers=$(rnd $list_verses )
	[[ 0 -eq $myVers ]] && myVers=1
#
#	Display & Action
#
	tui-header "$ME ($script_version)" "$myBook"
	lblChap=
	lblChap=$(echo "${myChap:3:-4}"|sed s,_,' ',g) #|while read num title;do printf "$title - $num.";done)
#	set -x
	# sed s,'_',' ',g
#	oIFS="$IFS"
#	IFS="_"
#	lblChap=$(printf "$myChap"| while read ABR ID TITLE;do printf "$ID) $TITLE";done)
#	IFS="$oIFS"
#	set +x
	tui-title "${lblChap/ /) } : $myVers"
	
	# Get the string
	oIFS="$IFS"
	IFS=":"
	STR=$(grep -nv "#"  $THISFILE | grep ^$myVers:|while read ID TEXT;do printf "$TEXT";done)
	IFS="$oIFS"
	
	# Fix odd chars
	case ${lang^} in
	German)	# TODO : doesnt work yet properly
		STR=$(printf "$STR"|sed s,"ä",ae,g|sed s,"ö",oe,g|sed s,"ü",ue,g|sed s,"ã",a,g|sed s,"ñ",n,g)
	#	StR=$(printf "$STR"|sed s,"\303\274","ü",g)
	esac
	
	# Finaly print it
	# This STR below prints just fine, strings with umlauts not..
	#STR="AAAAAAAAAAAAAAaaaaaaaaaaaaa BBBBBBBBBBBBBBbbbbbbbbbbbbbbbbbb cccccccccccccccccccccccDDDDDDDDDDDDDDDDDDDDD                                                  eeeeeeeeeeeeeeeeeeeeeeeeeeEEEEEEEEEEEEEEEEEEEEEEEEEeee fffffffffffffffffffffffffffFFFFFFFFFFFFFFFFFFFFFFFFFFFFfff                                           gggggggggggggggggggggggggGGGGGGGGGGGGGGGGGGGGGGGGGggg hhhhhhhhhhhhhhhhhhhhhhHHHHHHHHHHHHHHHHHHHHHHHHHHh iiiiiiiiiiiiiiiiiiiiiiiiiIIIIIIIIIIIIIIIIIIIIIIIIiiii" ; STR+="$STR"
	tui-echo "$STR"
