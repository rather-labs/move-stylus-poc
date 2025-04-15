# Moving stylus

## Overview

This repository contains a proof of concept to compile the Move language to WASM, for running it in Arbitrum's Stylus Environment.

## Build instructions
Set up the stylus environment and install required tools:
```bash
make setup-stylus
```

build the example contract:
```bash
make build-example
```

test and debug wasm:
```bash
make test-move-bytecode-to-wasm
make disassemble
```

check web assembly output at arbitrum dev node:
```bash
make check-example
```

deploy to arbitrum dev node (local):
```bash
make deploy-example
```

run test interactions (make sure to setup a `.env` file):
```bash
make example-interaction
```
