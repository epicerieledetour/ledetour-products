# Generate products list

Generate a static website with [Le Détour](https://produits.epicerieledetour.org) product list from an [Airtable base](https://airtable.com/tblMxwhBtBOr2TPXO/viw7UV7UsTEKox7Il?blocks=hide).

## Dependencies

- a [`bash`](https://www.gnu.org/software/bash/) compatible shell
- [`python3`](https://www.python.org/)
- [`jinja2`](jinja.palletsprojects.com/) (run `pip install -r requirements.txr` from a python3 virtual environment)
- [`curl`](https://curl.haxx.se/)
- [`jq`](https://stedolan.github.io/jq/)

## Run

### Generate

Run `./generate.sh` to create the files `site/index.html` (French list) and `site/en/index.html` (English list). Requires an Airtable API token set in environment variable `AT_API_TOKEN`.

### Publish

Run `./publish.sh` to push the generated site to the production server. Requires an SSH public key set to the `root` account.

### Development server

Run `./serve.sh` to run a development server.
