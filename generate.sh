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
