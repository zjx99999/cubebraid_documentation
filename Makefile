# Make file to generate documentation

SOURCE     = source
OUT        = build
LINKCHECKDIR  = $(OUT)/linkcheck
PYTHON := python3
ifeq ($(OS),Windows_NT)
    PYTHON := python
endif
BUILD      = $(PYTHON) -m sphinx
JOBS       ?= auto
OPTS       =-c . -W -j$(JOBS) # Treat warnings as errors, build in parallel ($(JOBS) workers)
LIVE_HOST  ?= localhost
LIVE_PORT  ?= 8000

DICTIONARIES := codespell_whitelist.txt

help:
	@$(BUILD) -M help "$(SOURCE)" "$(OUT)" $(OPTS)

%: Makefile
	@$(BUILD) -M $@ "$(SOURCE)" "$(OUT)" $(OPTS)

lint:
	sphinx-lint source

test:
	doc8 --ignore D001  --ignore-path $(OUT) -- $(SOURCE)

test-tools:
	$(PYTHON) -m pytest test/

spellcheck:
	git ls-files '*.md' '*.rst' | xargs codespell --config codespell.cfg

check-dictionaries:
	@echo "Checking dictionaries..."
	@for dict in $(DICTIONARIES); do \
		echo "Checking $$dict..."; \
		if grep -E -n "^\s*$$|\s$$|^\s" $$dict; then \
			echo "Dictionary $$dict contains empty lines or leading/trailing spaces, triming..."; \
			sed -E -i.bak -e 's/^[[:space:]]+//; s/[[:space:]]+$$//; /^$$/d' $$dict && rm $$dict.bak; \
		fi; \
	done

sort-dictionaries:
	@echo "Sorting dictionaries..."
	@for dict in $(DICTIONARIES); do \
		echo "Sorting $$dict..."; \
		if ! LC_ALL=C sort -f -b -c $$dict; then \
			echo "Dictionary $$dict is not sorted, sorting..."; \
			LC_ALL=C sort -f -b -o $$dict $$dict; \
		fi; \
	done

linkcheck:
	$(BUILD) -b linkcheck $(OPTS) $(SOURCE) $(LINKCHECKDIR)
	@echo
	@echo "Check finished. Report is in $(LINKCHECKDIR)."

serve:
	$(PYTHON) serve_docs.py --host "$(LIVE_HOST)" --port "$(LIVE_PORT)" --directory "$(abspath $(OUT)/html)"

.PHONY: help Makefile test test-tools linkcheck serve lint spellcheck check-dictionaries sort-dictionaries
