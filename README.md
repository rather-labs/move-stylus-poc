# Moving stylus

## Overview

This repository contains a proof of concept to compile the Move language to WASM, for running it in Arbitrum's Stylus Environment.

The generated code can be deployed to the Arbitrum chain as a Stylus contract and called using Solidity interfaces.

### Currently supported features:

#### Move Language

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
- Support for the import and usage of foreign structs/functions within the same package and from external packages
- Support functions with generic parameters
- Support for *native* functions (functions directly implemented in the MoveVM, ported as runtime or host-io functions inside WASM and tailored for EVM/Arbitrum)
- Struct packing and unpacking, mutable/immutable borrow of fields
- Support the [*init* function](https://move-book.com/programmability/module-initializer), used as constructor of the contract
- Enums packing

#### SDK - Framework

The `stylus-framework` package serves a role similar to the [`sui-framework`](https://intro.sui-book.com/unit-three/lessons/1_sui_framework.html) package. Its primary purpose is to provide Arbitrum/EVM-specific operations required for interacting with the blockchain and for enforcing semantic aspects of the language—most notably, the object-centric model.

- **`event.move`**
  Provides functions for emitting ABI-encoded [events/logs](https://docs.arbitrum.io/stylus-by-example/basic_examples/events).
- **`object.move`**
  Manages storage-backed objects. It defines:
  - `UID` and `ID` types, used in structs with the `key` ability to uniquely identify stored objects.
  - `new`, a function for creating globally unique IDs (represented by the `UID` struct).
  - `delete`, a function for removing structs from storage.
- **`transfer.move`**
  Implements object transfer functions that enforce Sui’s ownership model:
  - `transfer`: moves an object to a single owner; only the owner can read and write it.
  - `share_object`: shares an object; once shared, it can be read and written by anyone.
  - `freeze_object`: freezes an object; once frozen, it can be read by anyone but not modified.
- **`tx_context.move`**
  Defines the `TxContext` object, which provides methods for accessing information about the current transaction.
- **`types.move`**
  Provides the `is_one_time_witness` function, which checks if a struct is a [one-time witness](https://move-book.com/programmability/one-time-witness/).

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
make deploy-example-2
make deploy-example-primitives
make deploy-counter
make deploy-counter-with-init
```

run test interactions (make sure to setup a `.env` file):
```bash
make example-interaction
make example-interaction-2
make example-interaction-primitives
make example-counter
make example-counter-with-init
make example-dog-walker
```

## Fully functional contracts

In the `example/sources` folder, among contracts that only demonstrates the Move Language capabilities, there are three contracts fully functional that showcase different aspects of the Move language semantics:

- **`counter.move`**
  - Uses the `share_object` function to make counters globally accessible so anyone can increment their value.
  - Emits an event for each created counter so users can capture its ID.
  - Allows seamless retrieval of objects from storage by their ID.
  - Enforces access control in the `set_value` function using the `TxContext.sender` method.

- **`counter_with_init.move`**
  - Same as `counter.move`, but the counter is created with a constructor function (`init`).

- **`dog_walker.move`**
  - Enforces access control using the capability pattern.
  - Uses the `transfer` function to assign the capability to a unique owner.
  - Emits an event when the dog goes out for a walk.
  - Prevents the action if the contract is not called by the dog's owner.
