#!/bin/bash

for i in box car forest memory; do echo ===== Building $i; echo; make -C $i; done
