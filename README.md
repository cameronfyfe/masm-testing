# masm-testing

sandbox repo for testing MASM execution with the [Miden VM](https://github.com/0xPolygonMiden/miden-vm)

# Quick Start

Enter nix shell with miden installed

    nix develop

Run sha256 hasher

    make sha256.run

Generate proof for sha256 hasher

    make sha256.prove

Verify generated proof for sha256 hasher

    make sha256.verify

# Example Code and IO

MASM Program and IO for `sha256-blake3/`

`sha256-blake3.masm`
```present cat sha256-blake3/sha256-blake3.masm
use.std::crypto::hashes::sha256
use.std::crypto::hashes::blake3

begin

  # load 64 byte hash input from the advice stack to the main stack
  # (each value in stack is a 32-bit value for the hash computation)
  adv_push.16

  # store hash input in memory
  mem_storew.0 dropw
  mem_storew.1 dropw
  mem_storew.2 dropw
  mem_storew.3

  # load hash input to stack
       mem_loadw.3 
  padw mem_loadw.2 
  padw mem_loadw.1
  padw mem_loadw.0

  # perform and store sha256 in memory
  exec.sha256::hash_2to1

  mem_storew.4 dropw
  mem_storew.5

  # load hash input to stack
       mem_loadw.3 
  padw mem_loadw.2 
  padw mem_loadw.1
  padw mem_loadw.0

  # perform blake3
  exec.blake3::hash_2to1

  # load sha256 to stack
  padw mem_loadw.5
  padw mem_loadw.4

end
```

`sha256-blake3.in`
```present cat sha256-blake3/sha256-blake3.in
{
    "operand_stack": [],
    "advice_stack": [
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
        "11",
        "12",
        "13",
        "14",
        "15",
        "16"
    ]
}
```

`sha256-blake3.out`
```present cat sha256-blake3/sha256-blake3.out
{
  "stack": [
    "3215339949",
    "2676693650",
    "145776625",
    "3299822417",
    "863564951",
    "1147708797",
    "616338819",
    "4169561920",
    "4191074185",
    "2159343350",
    "831231409",
    "290943167",
    "29124900",
    "4255647887",
    "217477570",
    "2966802291",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0"
  ],
  "overflow_addrs": [
    "0",
    "19338",
    "19339",
    "19340",
    "19341",
    "19345",
    "19346",
    "19347",
    "19348",
    "19399",
    "19400",
    "19401",
    "19402",
    "19405",
    "19406",
    "19407",
    "19408"
  ]
}```