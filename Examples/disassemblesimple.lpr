{
  Zydis DisassembleSimple Example By Coldzer0
}
program DisassembleSimple;
{$IFDEF FPC}
  {$mode Delphi}{$H+}{$J-}
{$ENDIF}

uses
  SysUtils,
  Zydis.apis,
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
