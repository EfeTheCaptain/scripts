#!/bin/sh

clock=$(date '+%I')

case $BLOCK_BUTTON in
	6) st -e nvim "$0" ;;
esac

#case "$clock" in
#	"00") icon="🕛" ;;
#	"01") icon="🕐" ;;
#	"02") icon="🕑" ;;
#	"03") icon="🕒" ;;
#	"04") icon="🕓" ;;
#	"05") icon="🕔" ;;
#	"06") icon="🕕" ;;
#	"07") icon="🕖" ;;
#	"08") icon="🕗" ;;
#	"09") icon="🕘" ;;
#	"10") icon="🕙" ;;
#	"11") icon="🕚" ;;
#	"12") icon="🕛" ;;
#esac

date "+%I:%M%p"
