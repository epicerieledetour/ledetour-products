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

for i in `seq 1 6 42`
do
  am=25
  bm=25
  cm=25
  dm=25
  em=25
  fm=25
  d=200531
  dfr="Expire le 31 mai 2020"
  den="Expires on 31st of May, 2020"
  printf -v index "%04d" $i
  printf -v an "$d-%04d" $(($i + 0))
  printf -v bn "$d-%04d" $(($i + 1))
  printf -v cn "$d-%04d" $(($i + 2))
  printf -v dn "$d-%04d" $(($i + 3))
  printf -v en "$d-%04d" $(($i + 4))
  printf -v fn "$d-%04d" $(($i + 5))
  json=pages/pages-$index.json
  echo Generating $json
  jq -n   ".am = $am | .an = \"$an\" | .adf = \"$dfr\" | .ade = \"$den\" | .bm = $bm | .bn = \"$bn\" | .bdf = \"$dfr\" | .bde = \"$den\" | .cm = $cm | .cn = \"$cn\" | .cdf = \"$dfr\" | .cde = \"$den\" | .dm = $dm | .dn = \"$dn\" | .ddf = \"$dfr\" | .dde = \"$den\" | .em = $em | .en = \"$en\" | .edf = \"$dfr\" | .ede = \"$den\" | .fm = $fm | .fn = \"$fn\" | .fdf = \"$dfr\" | .fde = \"$den\""  > $json
done

for json in pages/*.json
do
  svg=${json%%.json}.svg
  pdf=${json%%.json}.pdf
  echo Making $svg
  python scripts/render-jinja-template.py --template recto.svg < $json > $svg
  echo Making $pdf
  cairosvg --dpi 300 --output-width 3300 --output-height 2550 -o $pdf $svg
done

echo Generating final output pages/rectos.pdf
pdfunite pages/*.pdf pages/rectos.pdf

echo Generating final output pages/versos.pdf
cairosvg --dpi 300 --output-width 3300 --output-height 2550 -o pages/versos.pdf templates/verso.svg
