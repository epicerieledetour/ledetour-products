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

for i in `seq 1 6 600`
do
  am=25
  bm=25
  cm=25
  dm=25
  em=10
  fm=10
  d=200517
  printf -v index "%04d" $i
  printf -v an "$d-%04d" $(($i + 0))
  printf -v bn "$d-%04d" $(($i + 1))
  printf -v cn "$d-%04d" $(($i + 2))
  printf -v dn "$d-%04d" $(($i + 3))
  printf -v en "$d-%04d" $(($i + 4))
  printf -v fn "$d-%04d" $(($i + 5))
  json=pages/pages-$index.json
  echo Generating $json
  jq -n ".am = $am | .an = \"$an\" | .bm = $bm | .bn = \"$bn\" | .cm = $cm | .cn = \"$cn\" | .dm = $dm | .dn = \"$dn\" | .em = $em | .en = \"$en\" | .fm = $fm | .fn = \"$fn\"" > $json
done

for json in pages/*.json
do
  svg=${json%%.json}.svg
  pdf=${json%%.json}.pdf
  echo Making $svg
  python scripts/render-jinja-template.py --template page.svg < $json > $svg
  echo Making $pdf
  cairosvg --dpi 300 --output-width 3300 --output-height 2550 -o $pdf $svg
done

echo Generating final output pages/bons-achats.pdf
pdfunite pages/*.pdf pages/bons-achats.pdf
