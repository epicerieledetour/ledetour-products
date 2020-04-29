#!/usr/bin/env python3

import csv
import itertools
import json
import sys


def els(row):
    it = iter(row)
    try:
        while True:
            fr, en = next(it), next(it)
            yield fr, en
            next(it)
            next(it)
            next(it)
    except StopIteration:
        pass


def csv2json(csvfile, jsonfile):
    reader = csv.reader(csvfile)

    fr_dict = {}
    en_dict = {}
    lang_dicts = {"fr": fr_dict, "en": en_dict}
    lists = []
    lists_it = None

    is_first_row = True

    for row in reader:
        if is_first_row:
            for fr, en in els(row):
                list_fr = []
                fr_dict[fr] = list_fr

                list_en = []
                en_dict[en] = list_en

                lists.append((list_fr, list_en))

            lists_it = itertools.cycle(lists)
            is_first_row = False

        else:
            for fr, en in els(row):
                list_fr, list_en = next(lists_it)
                if fr and en:
                    list_fr.append(fr)
                    list_en.append(en)

    json.dump(lang_dicts, jsonfile, ensure_ascii=False)


if __name__ == "__main__":
    CSV = sys.stdin
    JSON = sys.stdout
    csv2json(CSV, JSON)
