Zydis Pascal Bindings
=====================

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Pascal language bindings for the [Zydis library](https://github.com/zyantific/zydis), a fast and lightweight x86/x86-64 disassembler.

## TODO
This repo still in development & Supports only FPC for now

---

## Example
```pascal
program DisassembleSimple;

uses
  SysUtils,
  Zydis,
  Zydis.enums,
  Zydis.types,
  Zydis.Status,
  Zydis.Disassembler;

var
  offset : ZyanUSize;
  runtime_address: ZyanU64;
  instruction : TZydisDisassembledInstruction;
  Data: array[0..24] of ZyanU8 = ($51, $8D, $45, $FF, $50, $FF,
    $75, $0C, $FF, $75, $08, $FF, $15, $A0, $A5, $48, $76, $85, $C0,
    $0F, $88, $FC, $DA, $02, $00);

{$R *.res}

begin
  offset := 0;
  runtime_address := $007FFFFFFF400000;

  Initialize(instruction);
  // Loop over the instructions in our buffer.
  while ZYAN_SUCCESS(ZydisDisassembleIntel(ZYDIS_MACHINE_MODE_LONG_64,
      runtime_address, @data[offset], SizeOf(data) - offset, instruction)) do
  begin
    WriteLn(Format('%.16X  %s', [runtime_address, UTF8ToString(instruction.text)]));
    offset += instruction.info.length;
    runtime_address += instruction.info.length;
  end;

  ReadLn;
end.
```

#### Output
```
007FFFFFFF400000  push rcx
007FFFFFFF400001  lea eax, [rbp-0x01]
007FFFFFFF400004  push rax
007FFFFFFF400005  push [rbp+0x0C]
007FFFFFFF400008  push [rbp+0x08]
007FFFFFFF40000B  call [0x008000007588A5B1]
007FFFFFFF400011  test eax, eax
007FFFFFFF400013  js 0x007FFFFFFF42DB15
```

## License
The Zydis Pascal Bindings are licensed under the MIT License.

## With ❤️ From Home.
