python3 -m venv python

source python/bin/activate.fish

python3 -m pip install -r requirements.txt

mkdocs build

mkdocs serve

pre-commit run --all-files

