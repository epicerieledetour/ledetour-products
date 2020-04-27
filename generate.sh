#!/bin/bash

TEMPLATESDIR=templates
TEMPLATE_FR=wp-fr.html
TEMPLATE_EN=wp-en.html
OUTDIR=build
HTML_EN=$OUTDIR/en.html
HTML_FR=$OUTDIR/fr.html

CSV_URL="https://docs.google.com/spreadsheets/d/e/2PACX-1vQr9XX63mfgngLidkaQQly6N5gDjt4JGgs9lLeeve7shsPKegV4OQ7piuj_wAvl0fOmF6rfgVhEUxjH/pub?gid=0&single=true&output=csv"
CSV=$OUTDIR/data.csv

JSON=$OUTDIR/data.json

mkdir -p $OUTDIR
curl -s "$CSV_URL" > $CSV
python scripts/csv2json.py < $CSV > $JSON
python scripts/render-jinja-template.py --template $TEMPLATE_FR < $JSON > $HTML_FR
python scripts/render-jinja-template.py --template $TEMPLATE_EN < $JSON > $HTML_EN

#
# airtable_get() {
#   BASE_URL=$1
#   BASE_OUT=$2
#
#   PAGE=0
#   OFFSET=
#   while [[ $OFFSET != "null" ]]
#   do
#     URL=$BASE_URL
#
#     if [[ ! -z $OFFSET ]]
#     then
#       URL+="&offset=$OFFSET"
#     fi
#
#     ((PAGE++))
#     INDEX=`printf %04d $PAGE`
#     OUT=$BASE_OUT-$INDEX.json
#
#     echo Fetching $URL to $OUT
#     curl -s -H "$AT_AUTH_HEADER" $URL | python3 -m json.tool > $OUT
#
#     OFFSET=`jq -r .offset $OUT`
#   done
# }
#
# echo Making directory $OUTDIR
# mkdir -p $OUTDIR
#
# airtable_get $AT_ITEMS_URL $AT_BASE_ITEMS_OUT
#
# echo Merging items to $AT_ITEMS and adding additional properties
# jq -n ".iso_date = \"`date --iso-8601=minutes`\" | .date = \"`date "+%Y-%m-%d %H:%M:%S"`\"" > $DATE_DATA
# jq -s --argfile static_data static/data.json --argfile date_data  $DATE_DATA 'reduce .[] as $dot ({}; .records += $dot.records) | . + $static_data | . + $date_data' $AT_BASE_ITEMS_OUT* > $AT_ITEMS
#
# echo Export FR page $HTML_FR
# mkdir -p $SITE_FR
# python scripts/render-jinja-template.py --template $TEMPLATE_FR < $AT_ITEMS > $HTML_FR
#
# echo Export EN page $HTML_EN
# mkdir -p $SITE_EN
# python scripts/render-jinja-template.py --template $TEMPLATE_EN < $AT_ITEMS > $HTML_EN
