#!/bin/bash

rsync --archive --progress --human-readable --delete site/ root@charlesfleche.net:/srv/www/ledetour-produits
