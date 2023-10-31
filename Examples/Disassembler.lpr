{
  Zydis Disassembler Example By Coldzer0
}
program Disassembler;

{$IFDEF FPC}
  {$mode Delphi}{$H+}{$J-}
  {$PackRecords C}
{$ENDIF}

uses
  SysUtils,
  Zydis.apis,
  Zydis.enums,
  Zydis.types,
  Zydis.Status,
  Zydis.Disassembler,
  zydis.decoder,
  zydis.decoder.Types,
  zydis.formatter;

var
  offset : ZyanUSize = 0;
  runtime_address: ZyanU64 = $007FFFFFFF400000;

  decoder : TZydisDecoder;
  Formatter : TZydisFormatter;
  instruction : TZydisDecodedInstruction;

  operands : Array [1..ZYDIS_MAX_OPERAND_COUNT] of TZydisDecodedOperand;

  length : ZyanUSize;

  buffer: array[0..255] of AnsiChar;

  Data: array[0..24] of ZyanU8 = ($51, $8D, $45, $FF, $50, $FF,
    $75, $0C, $FF, $75, $08, $FF, $15, $A0, $A5, $48, $76, $85, $C0,
    $0F, $88, $FC, $DA, $02, $00);

begin
  ZydisDecoderInit(@decoder, ZYDIS_MACHINE_MODE_LONG_64, ZYDIS_STACK_WIDTH_64);
  ZydisFormatterInit(@formatter, ZYDIS_FORMATTER_STYLE_INTEL);

  Initialize(operands);
  Initialize(instruction);

  length := sizeof(data);
  while ZYAN_SUCCESS(ZydisDecoderDecodeFull(@decoder, @data[offset], length - offset,
      instruction, operands)) do
  begin
    // Print current instruction pointer.
    Write(Format('%.16X  ', [runtime_address]));

    // Format & print the binary instruction structure to human-readable format
    ZydisFormatterFormatInstruction(formatter, @instruction, @operands,
        instruction.operand_count_visible, buffer, SizeOf(buffer), runtime_address, nil);
    WriteLn(buffer);

    offset += instruction.length;
    runtime_address += instruction.length;
  end;


  ReadLn;
end.





