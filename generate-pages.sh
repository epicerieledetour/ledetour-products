#!/bin/bash

mkdir -p pages

for i in `seq 1 6 24`
do
  am=20
  bm=20
  cm=20
  dm=20
  em=20
  fm=20
  d=210901
  dfr="Expire le 15 octobre 2021"
  den="Expires 15th of Oct., 2021"
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

echo Copying recto.png and verso.png to pages/
cp -v templates/*png pages

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
pdfunite pages/pages-*.pdf pages/rectos.pdf

echo Generating final output pages/versos.pdf
cairosvg --dpi 300 --output-width 3300 --output-height 2550 -o pages/versos.pdf templates/verso.svg
