SHELL := /bin/bash
PYTHON = /usr/bin/env python3
PWD = $(shell pwd)
GREP := $(shell command -v ggrep || command -v grep)

.PHONY: clean-pyc clean-build docs clean register release clean-docs help travis

help:
	@$(GREP) --only-matching --word-regexp '^[^[:space:].]*:' Makefile | sed 's|:[:space:]*||'

clean: clean-build clean-pyc clean-test

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info
	rm -fr src/*.egg-info

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/

lint:
	flake8 src/pdupes tests

test:
	py.test tests

test-all:
	tox

coverage:
	coverage run --source pdupes setup.py test
	coverage report -m
	coverage html
	open htmlcov/index.html

clean-docs:
	rm -f docs/pdupes*.rst
	rm -f docs/modules.rst

docs: clean-docs
	source venv/bin/activate && sphinx-apidoc -o docs/ src/pdupes
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	-open docs/_build/html/index.html

register: dist
	twine register dist/*.whl

release: dist
	twine upload dist/*

dist: clean docs
	$(PYTHON) setup.py --long-description | rst2html.py --halt=2
	$(PYTHON) setup.py sdist
	$(PYTHON) setup.py bdist_wheel
	ls -l dist

venv:
	$(PYTHON) -m venv venv
	venv/bin/pip install --upgrade pip wheel setuptools

update-reqs: requirements.txt
	venv/bin/python -c 'print("#" * 80)' >> $<
	while read lib; do \
		libname="$${lib%%=*}"; \
		venv/bin/pip install --upgrade "$${libname}"; \
	done < <($(GREP) --invert-match '^#' $<)
	for lib in $$(venv/bin/pip freeze --all | grep '=='); do \
		if grep "$${lib%%=*}" $< >/dev/null; then \
			echo "$${lib}" >> $<; \
		fi; \
	done

update-dev-reqs: requirements-dev.txt
	venv/bin/python -c 'print("#" * 80)' >> $<
	while read lib; do \
		libname="$${lib%%=*}"; \
		venv/bin/pip install --upgrade "$${libname}"; \
	done < <($(GREP) --invert-match '^#' $<)
	for lib in $$(venv/bin/pip freeze --all | grep '=='); do \
		if grep "$${lib%%=*}" $< >/dev/null; then \
			echo "$${lib}" >> $<; \
		fi; \
	done

travis:
	[ -f .travis.yml ] && travis enable || travis init
