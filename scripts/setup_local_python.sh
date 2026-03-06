#!/usr/bin/env bash
if [ ! -d "${SNIPPETS}/python/.venv" ]; then
  cd ${SNIPPETS}/python && python3 -m venv .venv
fi
source ${SNIPPETS}/python/.venv/bin/activate && pip install -e ${BINDINGS}/langs/python
