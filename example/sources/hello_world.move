module 0x01::hello_world;

const INT_AS_CONST: u128 = 128128;

public fun get_constant(): u128 {
  INT_AS_CONST
}

public fun get_constant_local(): u128 {
  let x: u128 = INT_AS_CONST;
  x
}

// Forces the compiler to store literals on locals
public fun get_local(_z: u128): u128 {
  let x: u128 = 100;
  let y: u128 = 50;
  identity(x);

  identity_2(x, y)
}

// Forces the compiler to store literals on locals
public fun get_copied_local(): u128 {
  let x: u128 = 100;
  
  let y = x; // copy
  let mut z = x; // move
  identity(y);
  identity(z);

  z = 111;
  y
}

public fun echo(x: u128): u128 {
  identity(x)
}

public fun echo_2(x: u128, y: u128): u128 {
  identity_2(x, y)
}

fun identity(x: u128): u128 {
  x
}

fun identity_2(_x: u128, y: u128): u128 {
  y
}
