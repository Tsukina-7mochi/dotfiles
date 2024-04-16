#!/bin/zsh

local opthash
zparseopts -D -E -A opthash h -help s: -source:=s t: -target:=t -formality:

local source=""
local target="EN-US"
local formality="default"

if [[ $# < 1 ]] || [[ -n "${opthash[(i)--help]}" ]] || [[ -n "${opthash[(i)-h]}" ]]; then
    echo "Usage: deepl [text]"
    echo "Options:"
    echo "  -h, --help              : show this help"
    echo "  -s, --source [language] : set source language (default: auto detect)"
    echo "  -t, --target [language] : set target language (default: EN-US)"
    echo "  --formality  [formality]: set formality (default|more|less|prefer_more|prefer_less)"
    exit
fi

if [[ -n "${opthash[(i)-s]}" ]]; then
    source="${opthash[-s]}"
fi
if [[ -n "${opthash[(i)--source]}" ]]; then
    source="${opthash[--source]}"
fi

if [[ -n "${opthash[(i)-t]}" ]]; then
    target="${opthash[-t]}"
fi
if [[ -n "${opthash[(i)--target]}" ]]; then
    target="${opthash[--target]}"
fi

if [[ -n "${opthash[(i)--formality]}" ]]; then
    formality="${opthash[--formality]}"
fi

if [[ ! -n "$DEEPL_AUTH_KEY" ]]; then
    echo "authentication key must be set to variable DEEPL_AUTH_KEY"
    exit
fi
if [[ ! -n "$DEEPL_API_ENDPOINT" ]]; then
    echo "api endpoint must be set to variable DEEPL_API_ENDPOINT"
    exit
fi

local response=""
if [[ -n "$source" ]]; then
    echo "$source -> $target (formality: $formality)"
    response=$(curl -sSL \
        -X POST \
        -H "Authorization: DeepL-Auth-Key $DEEPL_AUTH_KEY" \
        --data-urlencode "text=$@" \
        -d "source_lang=$source" \
        -d "target_lang=$target" \
        -d "formality=$formality" \
        $DEEPL_API_ENDPOINT)
else
    echo "(auto detect) -> $target (formality: $formality)"
    response=$(curl -sSL \
        -X POST \
        -H "Authorization: DeepL-Auth-Key $DEEPL_AUTH_KEY" \
        --data-urlencode "text=$@" \
        -d "target_lang=$target" \
        -d "formality=$formality" \
        $DEEPL_API_ENDPOINT)
fi

if [ "$?" != 0 ]; then
    exit 127
fi

local translated_text=$(echo "$response" | jq ".translations[0].text")
if [ "$translated_text" != "null" ]; then
    echo "--"
    echo "$translated_text" | sed -e 's/^"//' | sed -e 's/"$//'
else
    local message=$(echo "$response" | jq ".message")
    if [ "$message" != "null" ]; then
        echo "message from DeepL: $message" | sed -e 's/^"//' | sed -e 's/"$//'
    else
        echo "failed to parse response: $response"
    fi

    exit 127
fi
