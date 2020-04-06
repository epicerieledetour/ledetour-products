#!/bin/bash

TEMPLATESDIR=templates
TEMPLATE_EN=at-en.html
TEMPLATE_FR=at-fr.html
OUTDIR=build
SITE_EN=site/en
SITE_FR=site
HTML_EN=$SITE_EN/index.html
HTML_FR=$SITE_FR/index.html

AT_AUTH_HEADER="Authorization: Bearer $AT_API_TOKEN"
AT_ITEMS_URL="https://api.airtable.com/v0/appANF0S1mnPZKQ4r/items?filterByFormula=%7Bis_valid%7D"

AT_BASE_CATEGORIES_OUT=$OUTDIR/at_categories
AT_BASE_ITEMS_OUT=$OUTDIR/at_items
AT_ITEMS=$AT_BASE_ITEMS_OUT.json

DATE_DATA=$OUTDIR/date.json

airtable_get() {
  BASE_URL=$1
  BASE_OUT=$2

  PAGE=0
  OFFSET=
  while [[ $OFFSET != "null" ]]
  do
    URL=$BASE_URL

    if [[ ! -z $OFFSET ]]
    then
      URL+="&offset=$OFFSET"
    fi

    ((PAGE++))
    INDEX=`printf %04d $PAGE`
    OUT=$BASE_OUT-$INDEX.json

    echo Fetching $URL to $OUT
    curl -s -H "$AT_AUTH_HEADER" $URL | python3 -m json.tool > $OUT

    OFFSET=`jq -r .offset $OUT`
  done
}

echo Making directory $OUTDIR
mkdir -p $OUTDIR

airtable_get $AT_ITEMS_URL $AT_BASE_ITEMS_OUT

echo Merging items to $AT_ITEMS and adding additional properties
jq -n ".iso_date = \"`date --iso-8601=minutes`\" | .date = \"`date "+%Y-%m-%d %H:%M:%S"`\"" > $DATE_DATA
jq -s --argfile static_data static/data.json --argfile date_data  $DATE_DATA 'reduce .[] as $dot ({}; .records += $dot.records) | . + $static_data | . + $date_data' $AT_BASE_ITEMS_OUT* > $AT_ITEMS

echo Export FR page $HTML_FR
mkdir -p $SITE_FR
python scripts/render-jinja-template.py --template $TEMPLATE_FR < $AT_ITEMS > $HTML_FR

echo Export EN page $HTML_EN
mkdir -p $SITE_EN
python scripts/render-jinja-template.py --template $TEMPLATE_EN < $AT_ITEMS > $HTML_EN
