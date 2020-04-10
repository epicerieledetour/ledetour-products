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

mkdir -p pages

for i in `seq 1 4 1000`
do
  v=50
  printf -v index "%05d" $i
  printf -v ida "%05d" $(($i + 0))
  printf -v idb "%05d" $(($i + 1))
  printf -v idc "%05d" $(($i + 2))
  printf -v idd "%05d" $(($i + 3))
  json=pages/pages-$index.json
  echo Generating $json
  jq -n ".a = $v | .ida = \"$ida\" | .b = $v | .idb = \"$idb\" | .c = $v | .idc = \"$idc\" | .d = $v | .idd = \"$idd\"" > $json
  # jq -n ".iso_date = \"`date --iso-8601=minutes`\" | .date = \"`date "+%Y-%m-%d %H:%M:%S"`\"" > $DATE_DATA
done

for json in pages/*.json
do
  svg=${json%%.json}.svg
  pdf=${json%%.json}.pdf
  echo Making $svg
  python scripts/render-jinja-template.py --template page.svg < $json > $svg
  echo Making $pdf
  cairosvg $svg -o $pdf
done

echo Generating final output pages/bons-achats.pdf
pdfunite pages/*.pdf pages/bons-achats.pdf

# jq -n ".iso_date = \"`date --iso-8601=minutes`\" | .date = \"`date "+%Y-%m-%d %H:%M:%S"`\"" > $DATE_DATA
# python scripts/render-jinja-template.py --template $TEMPLATE_FR < $AT_ITEMS > $HTML_FR
