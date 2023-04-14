#!/usr/bin/env bash
url="$1"

urlencode() {
	local string="${1}"
	local strlen=${#string}
	local encoded=""
	local pos c o

	for ((pos = 0; pos < strlen; pos++)); do
		c=${string:$pos:1}
		case "$c" in
		[-_.~a-zA-Z0-9]) o="${c}" ;;
		*) printf -v o '%%%02x' "'$c" ;;
		esac
		encoded+="${o}"
	done
	echo "${encoded}"
}

handle_google_login() {
	account="$(gcloud auth list --filter='active' --format 'value(account)')"

	echo "ext+container:name=${account}&url=$(urlencode "$1&autoAccountSelect=${account}")"
}

if [[ $url =~ https://accounts.google.com/o/oauth2/auth ]]; then
	url=$(handle_google_login "$url")
fi

firefox "$url"
