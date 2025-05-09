# Moving stylus

## Overview

This repository contains a proof of concept to compile the Move language to WASM, for running it in Arbitrum's Stylus Environment.

The generated code can be deployed to the Arbitrum chain as a Stylus contract and called using Solidity interfaces.

Currently supported features:
- **Entrypoint router**: Public Move functions are handled by a router to allow using ABI function selectors.
- **Function Interface translation and internal function calls**
- **Basic operations**: Constant definition, literals, local variables move and copy is implemented for the following types:
  - [x] u8, u16, u32, u64
  - [x] u128, u256
  - [x] bool
  - [x] address
  - [x] vector

## Disclaimer

⚠️ **IMPORTANT**: This is a proof of concept implementation and is NOT intended for production use. The code has not been audited, is incomplete, and may contain security vulnerabilities or bugs. Use at your own risk.

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
