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
  - [x] structs
- **Primitive types**: The following primitive types are supported:
  - [x] integers (u8, u16, u32, u64, u128, u256)
  - [x] booleans
  - [x] address
  - [x] signer
  - [x] references
  - [x] tuples and unit
  - [x] vector
- **User defined datatypes**: Structs and Enums
  - [x] Structs (with and without generic types and phantom generic types)
  - [x] Enums - partially supported
- **Operations**: The following operations are supported:
  - [x] Arithmetic operations (addition, subtraction, multiplication, division, mod)
  - [x] Boolean operations (and, or)
  - [x] Bitwise/bitshift operations (left/right shift, and, or, xor)
  - [x] Equality operations
  - [x] Comparisons (less than, less or equal, more than, more or equal) on all integer types
  - [x] Casting
- **Vector operations**: The following vector operations are supported:
  - [x] Push back
  - [x] Pop back
  - [x] Length
  - [x] Borrow fields (mutable and immutable)
- Struct packing and unpacking, mutable/immutable borrow of fields
- Enums packing

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
make check-example-primitives
```

deploy to arbitrum dev node (local):
```bash
make deploy-example
make deploy-example-primitives
```

run test interactions (make sure to setup a `.env` file):
```bash
make example-interaction
make example-interaction-primitives
```
