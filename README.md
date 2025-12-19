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
  - [x] Structs 
  - [x] Enum
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
- Support for the import and usage of foreign structs/functions within the same package and from external packages.
- Support functions with generic parameters.
- Support for *native* functions (functions directly implemented in the MoveVM, ported as runtime or host-io functions inside WASM and tailored for EVM/Arbitrum).
- Struct/Enums packing and unpacking, mutable/immutable borrow of fields.
- Support the [*init* function](https://move-book.com/programmability/module-initializer), used as constructor of the contract.
- Support `delete` support for storage objects.
- Support Solidity's `fallback` and `receive` functions.


#### SDK - Framework

The `stylus-framework` package serves a role similar to the [`sui-framework`](https://intro.sui-book.com/unit-three/lessons/1_sui_framework.html) package. Its primary purpose is to provide Arbitrum/EVM-specific operations required for interacting with the blockchain and for enforcing semantic aspects of the language—most notably, the object-centric model.

- **`account.move`**
  Provides functions for querying account information on the blockchain:
  - `get_account_code_size`: retrieves the size of code in bytes at a given address (equivalent to EVM's `EXT_CODESIZE`).
  - `get_account_balance`: retrieves the ETH balance in wei of an account at a given address (equivalent to EVM's `BALANCE` opcode).
- **`contract_calls.move`**
  Enables cross-contract calls with support for gas limits, value transfers, and delegate calls. Provides:
  - `CrossContractCall` struct for configuring and executing calls to other contracts.
  - `ContractCallResult` and `ContractCallEmptyResult` types for handling call results and status codes.
- **`dynamic_field.move`**
  Implements dynamic fields that can be added to objects after construction. Provides functions for adding, borrowing, removing, and checking existence of dynamic fields.
- **`dynamic_field_named_id.move`**
  Extends dynamic field functionality to work with `NamedId` objects, providing a wrapper around `dynamic_field` operations for objects with named identifiers.
- **`error.move`**
  Provides the `revert` function for reverting the current transaction with a custom error value.
- **`event.move`**
  Provides functions for emitting ABI-encoded [events/logs](https://docs.arbitrum.io/stylus-by-example/basic_examples/events).
- **`fallback.move`**
  Utilities for the fallack function. Defines the `Calldata` struct representing data passed to fallback functions. Provides methods to access calldata as a `vector<u8>` or query its length, similar to how calldata is handled in Solidity fallback functions.
- **`object.move`**
  Manages storage-backed objects. It defines:
  - `UID` and `ID` types, used in structs with the `key` ability to uniquely identify stored objects.
  - `new`, a function for creating globally unique IDs (represented by the `UID` struct).
  - `delete`, a function for removing structs from storage.
- **`sol_types.move`**
  Defines Solidity-compatible fixed-size byte types (`Bytes1` through `Bytes32`) and provides conversion functions to transform these types into `vector<u8>` for interoperability with Solidity contracts.
- **`table.move`**
  Implements a map-like collection where keys and values are stored using the object system rather than within the `Table` value itself. The `Table` struct acts as a handle for retrieving entries. Provides standard map operations: add, borrow, remove, and query operations like `contains`, `length`, and `is_empty`.
- **`transfer.move`**
  Implements object transfer functions that enforce Sui's ownership model:
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

In the `example/sources` folder, among contracts that only demonstrates the Move Language capabilities, there are several fully functional contracts that showcase different aspects of the Move language semantics:

### Core Examples

- **`counter.move`**
  - Uses the `share_object` function to make counters globally accessible so anyone can increment their value.
  - Emits an event for each created counter so users can capture its ID.
  - Allows seamless retrieval of objects from storage by their ID.
  - Enforces access control in the `set_value` function using the `TxContext.sender` method.

- **`counter_with_init.move`**
  - Same as `counter.move`, but the counter is created with a constructor function (`init`).

- **`counter_named_id.move`**
  - Variant of the counter contract using `NamedId` for object identification instead of standard `UID`.
  - Demonstrates named object management with deterministic addressing.
  - Provides the same functionality as `counter.move` with alternative ID management.

- **`dog_walker.move`**
  - Enforces access control using the capability pattern.
  - Uses the `transfer` function to assign the capability to a unique owner.
  - Emits an event when the dog goes out for a walk.
  - Prevents the action if the contract is not called by the dog's owner.

### Token Standards

- **`erc20.move`**
  - Full implementation of the ERC-20 token standard.
  - Includes mint, burn, transfer, and approval functionality.
  - Uses dynamic fields for storing balances and allowances.
  - Emits standard Transfer and Approval events.
  - Demonstrates initialization with constructor (`init`) creating shared and frozen objects for token metadata.

- **`erc721.move`**
  - Complete implementation of the ERC-721 (NFT) standard with metadata extension.
  - Supports minting, burning, transferring, and approving NFTs.
  - Implements operator approvals for managing multiple tokens.
  - Uses dynamic fields for tracking ownership, balances, and approvals.
  - Includes safe transfer checks for receiver contracts.
  - Demonstrates interface detection via `supports_interface`.

### Advanced Patterns

- **`delegated_counter.move` & `delegated_counter_logic_*.move`**
  - Demonstrates the proxy/delegate pattern for upgradeable contracts.
  - Main contract delegates increment operations to external logic contracts.
  - Supports changing the logic address dynamically via `change_logic`.
  - Shows how to maintain state while upgrading contract logic.
  - Tests delegation with modifications before and after delegated calls.

- **`delegated_counter_named_id.move` & `delegated_counter_named_id_logic_*.move`**
  - Same delegation pattern as `delegated_counter.move` but using `NamedId` for object identification.
  - Demonstrates how named IDs work with cross-contract calls and delegation.

- **`cross_contract_call.move`**
  - Demonstrates cross-contract calls to external ERC-20 contracts.
  - Shows how to query balance, total supply, and execute transfers on external tokens.
  - Uses the `contract_calls` module from the stylus-framework.

### Testing & Demonstration

- **`hello_world.move`**
  - Comprehensive demonstration of basic Move language features.
  - Includes constants, generic types, structs, enums, and function calls.
  - Tests local variable handling, copying, and moving semantics.

- **`primitives_and_operations.move`**
  - Showcases all supported primitive types and operations.
  - Demonstrates arithmetic, bitwise, boolean, and comparison operations.
  - Includes casting between different integer types.

- **`revert_errors.move`**
  - Demonstrates custom error handling with the `revert` function.
  - Shows ABI-encoded error types with various data structures.
  - Includes examples of standard, custom, and nested struct errors.

- **`simple_counter.move`**
  - Basic counter implementation without storage backing (uses `drop` ability).
  - Includes unit tests demonstrating Move's testing capabilities.
  - Shows test patterns including `#[test]` and `#[expected_failure]` attributes.

- **`stack.move`**
  - Implements a generic stack data structure using the wrapper type pattern.
  - Demonstrates generic programming with type parameters.
  - Shows safe stack operations with `Option` types for empty stack handling.

