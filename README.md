# pdupes

[![Build Status](https://travis-ci.org/n8henrie/pdupes.svg?branch=master)](https://travis-ci.org/n8henrie/pdupes)

Python script to quickly find duplicate files, inspired by cwilper/pdupes.

- Free software: MIT
- Documentation: https://pdupes.readthedocs.org

## Features

- Looks for duplicates by comparing file sizes, and running an MD5 hash check
  on files with identical sizes.

## Introduction

Just a for-fun project to write a duplicate file finder in Python.

## Dependencies

- Python >= 3.6
- See `requirements.txt`

## Quickstart

1. `pip3 install pdupes`
- TODO

### Development Setup

1. Clone the repo: `git clone https://github.com/n8henrie/pdupes && cd
   pdupes`
1. Make a virtualenv: `python3 -m venv venv`
- TODO

## Configuration

- TODO

## Acknowledgements

- https://github.com/mainkats/pdupes

## Troubleshooting / FAQ

- How can I install an older / specific version of pdupes?
    - Install from a tag:
        - pip install git+git://github.com/n8henrie/pdupes.git@v0.1.0
    - Install from a specific commit:
        - pip install git+git://github.com/n8henrie/pdupes.git@aabc123def456ghi789
