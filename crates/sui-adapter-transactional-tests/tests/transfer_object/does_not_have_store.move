// Copyright (c) 2022, Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

// tests TransferObject should fail for an object _without_ public transfer

//# init --accounts A B --addresses test=0x0

//# publish

module test::m {
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, Info};

    struct S has key { info: Info }
    struct Cup<phantom T> has key { info: Info }

    public entry fun mint_s(ctx: &mut TxContext) {
        let info = object::new(ctx);
        transfer::transfer(S { info }, tx_context::sender(ctx))
    }

    public entry fun mint_cup<T>(ctx: &mut TxContext) {
        let info = object::new(ctx);
        transfer::transfer(Cup<T> { info }, tx_context::sender(ctx))
    }
}

// Mint S to A. Fail to transfer S from A to B, which should fail

//# run test::m::mint_s --sender A

//# view-object 107

//# transfer-object 107 --sender A --recipient B

//# view-object 107


// Mint Cup<S> to A. Fail to transfer Cup<S> from A to B

//# run test::m::mint_cup --type-args test::m::S --sender A

//# view-object 110

//# transfer-object 110 --sender A --recipient B

//# view-object 110
