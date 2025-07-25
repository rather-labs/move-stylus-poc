module 0x00::struct_bug;

public struct Foo has drop, copy {
    r: vector<u32>,
}

public fun test(foo: Foo): Foo {
    let mut foo_2 = foo;

    foo_2.r = vector[255];

    foo_2
}

public fun test2(foo: Foo): (Foo, Foo) {
    let mut foo_2 = foo;

    foo_2.r = vector[255];

    (foo, foo_2)
}
