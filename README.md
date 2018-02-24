Zydis Pascal Bindings
=====================

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Gitter](https://badges.gitter.im/zyantific/zyan-disassembler-engine.svg)](https://gitter.im/zyantific/zydis?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=body_badge) [![Discord](https://img.shields.io/discord/390136917779415060.svg)](https://discordapp.com/channels/390136917779415060/390138781313007626) 

Pascal language bindings for the [Zydis library](https://github.com/zyantific/zydis), a fast and lightweight x86/x86-64 disassembler.

## Readme
- Everything in this repository is WIP

## Example
```pascal
uses
  System.SysUtils,
  Zydis,
  Zydis.Exception,
  Zydis.Decoder,
  Zydis.Formatter;

const
  X86DATA: array of Byte = [$51, $8D, $45, $FF, $50, $FF, $75, $0C, $FF, $75,
                            $08, $FF, $15, $A0, $A5, $48, $76, $85, $C0, $0F,
                            $88, $FC, $DA, $02, $00];

var
  Formatter: Zydis.Formatter.TZydisFormatter;
  Decoder: Zydis.Decoder.TZydisDecoder;
  InstructionPointer: ZydisU64;
  Offset: Integer;
  Instruction: TZydisDecodedInstruction;
begin
  try
    if (ZydisGetVersion <> ZYDIS_VERSION) then
    begin
      raise Exception.Create('Invalid Zydis version');
    end;

    Formatter := Zydis.Formatter.TZydisFormatter.Create(ZYDIS_FORMATTER_STYLE_INTEL);
    try
      Formatter.ForceMemorySegments := true;
      Formatter.ForceMemorySize := true;
      Decoder :=
        Zydis.Decoder.TZydisDecoder.Create(ZYDIS_MACHINE_MODE_LONG_64, ZYDIS_ADDRESS_WIDTH_64);
      try
        InstructionPointer := $007FFFFFFF400000;
        Offset := 0;
        repeat
          Decoder.DecodeBuffer(@X86DATA[Offset], Length(X86DATA) - Offset, InstructionPointer,
            Instruction);
          WriteLn(Format('%.16x  %s',
            [InstructionPointer, Formatter.FormatInstruction(Instruction)]));
          Inc(InstructionPointer, Instruction.Length);
          Inc(Offset, Instruction.Length);
        until (Offset >= Length(X86DATA));
      finally
        Decoder.Free;
      end;
    finally
      Formatter.Free;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
```

#### Output
```
007FFFFFFF400000  push rcx
007FFFFFFF400001  lea eax, ss:[rbp-0x01]
007FFFFFFF400004  push rax
007FFFFFFF400005  push qword ptr ss:[rbp+0x0C]
007FFFFFFF400008  push qword ptr ss:[rbp+0x08]
007FFFFFFF40000B  call qword ptr ds:[0x008000007588A5B1]
007FFFFFFF400011  test eax, eax
007FFFFFFF400013  js 0x007FFFFFFF42DB15
```

## License
The Zydis Pascal Bindings are licensed under the MIT License.
