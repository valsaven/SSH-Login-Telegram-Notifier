#!/usr/bin/env bash

# ipinfo.io token
readonly IPINFO_TOKEN="1**********0"

# Telegram Bot Token
readonly TG_TOKEN="1********0:1******************1"

# Chat ID for alert messages
readonly CHAT_ID="-100**********1"

# Telegram bot send URI
declare -r TG_SEND_URI="https://api.telegram.org/bot$TG_TOKEN/sendMessage"

# URL encode function
function urlencode() {
    local old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

# Alert function
function ssh_notifier()
{
    local IP_INFO="$(curl -s ipinfo.io/$PAM_RHOST?token=$IPINFO_TOKEN)"
    if [ $? -ne 0 ]; then
        echo "Failed to get IP info"
        return 1
    fi

    local DATETIME="$(date "+%Y-%m-%d %H:%M:%S")"

    local MESSAGE=$(printf "*%s* logged on *%s*\nat %s\nHost: %s\nService: %s\nTTY: %s\nUser info: %s" \
        "${PAM_USER}" "${HOSTNAME}" "${DATETIME}" "${PAM_RHOST}" "${PAM_SERVICE}" "${PAM_TTY}" "${IP_INFO}")

    local TG_PAYLOAD="chat_id=$CHAT_ID&text=$(urlencode "$MESSAGE")&parse_mode=Markdown&disable_web_page_preview=true"
    curl -s --max-time 10 --retry 3 --retry-delay 2 --retry-max-time 10 -d "$TG_PAYLOAD" $TG_SEND_URI > /dev/null 2>&1 &
    if [ $? -ne 0 ]; then
        echo "Failed to send Telegram message"
        return 1
    fi
}

# Run main function
ssh_notifier
