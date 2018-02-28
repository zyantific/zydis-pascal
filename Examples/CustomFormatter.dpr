{***************************************************************************************************

  Zydis

  Original Author : Florian Bernd

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.

***************************************************************************************************}

program CustomFormatter;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Zydis in '..\Zydis\Zydis.pas',
  Zydis.Exception in '..\Zydis\Zydis.Exception.pas',
  Zydis.Decoder in '..\Zydis\Zydis.Decoder.pas',
  Zydis.Formatter in '..\Zydis\Zydis.Formatter.pas';

{* ============================================================================================== *}
{* Formatter                                                                                      *}
{* ============================================================================================== *}

type
  TZydisCustomFormatter = class(Zydis.Formatter.TZydisFormatter)
  strict private
    FRewriteMnemonics: Boolean;
    FOmitImmediate: Boolean;
  strict protected
    function DoFormatOperandImm(const Formatter: Zydis.TZydisFormatter; var Str: TZydisString;
      const Instruction: TZydisDecodedInstruction;
      const Operand: TZydisDecodedOperand): TZydisStatus; override;
    function DoPrintMnemonic(const Formatter: Zydis.TZydisFormatter;
      var Str: TZydisString; const Instruction: TZydisDecodedInstruction): TZydisStatus; override;
  public
    property RewriteMnemonics: Boolean read FRewriteMnemonics write FRewriteMnemonics;
  end;

{ TZydisCustomFormatter }

function TZydisCustomFormatter.DoFormatOperandImm(const Formatter: Zydis.TZydisFormatter;
  var Str: TZydisString; const Instruction: TZydisDecodedInstruction;
  const Operand: TZydisDecodedOperand): TZydisStatus;
begin
  // The @c DoPrintMnemonic sinals us to omit the immediate (condition-code) operand
  if (FOmitImmediate) then
  begin
    Exit(ZYDIS_STATUS_SKIP_OPERAND);
  end;

  // Default immediate formatting
  Result := inherited;
end;

function TZydisCustomFormatter.DoPrintMnemonic(const Formatter: Zydis.TZydisFormatter;
  var Str: TZydisString; const Instruction: TZydisDecodedInstruction): TZydisStatus;
const
  ConditionCodeStrings: array[0..31] of AnsiString = (
    {00} 'eq',
    {01} 'lt',
    {02} 'le',
    {03} 'unord',
    {04} 'neq',
    {05} 'nlt',
    {06} 'nle',
    {07} 'ord',
    {08} 'eq_uq',
    {09} 'nge',
    {0A} 'ngt',
    {0B} 'false',
    {0C} 'oq',
    {0D} 'ge',
    {0E} 'gt',
    {0F} 'true',
    {10} 'eq_os',
    {11} 'lt_oq',
    {12} 'le_oq',
    {13} 'unord_s',
    {14} 'neq_us',
    {15} 'nlt_uq',
    {16} 'nle_uq',
    {17} 'ord_s',
    {18} 'eq_us',
    {19} 'nge_uq',
    {1A} 'ngt_uq',
    {1B} 'false_os',
    {1C} 'neq_os',
    {1D} 'ge_oq',
    {1E} 'gt_oq',
    {1F} 'true_us'
  );
var
  ConditionCode: UInt8;
begin
  if (not FRewriteMnemonics) then
  begin
    Exit(inherited);
  end;

  // We use a custom field to pass data to the @c DoFormatOperandImm callback
  FOmitImmediate := true;

  // Rewrite the instruction-mnemonic for the given instructions
  if (Instruction.Operands[Instruction.OperandCount - 1].&Type = ZYDIS_OPERAND_TYPE_IMMEDIATE) then
  begin
    ConditionCode := Instruction.Operands[Instruction.OperandCount - 1].Imm.Value.u;
    case Instruction.Mnemonic of
      ZYDIS_MNEMONIC_CMPPS:
        if (ConditionCode < $08) then
        begin
          Str.Append(PAnsiChar(AnsiString(
            Format('cmp%sps', [ConditionCodeStrings[ConditionCode]]))));
          Exit(ZYDIS_STATUS_SUCCESS);
        end;
      ZYDIS_MNEMONIC_CMPPD:
        if (ConditionCode < $08) then
        begin
          Str.Append(PAnsiChar(AnsiString(
            Format('cmp%spd', [ConditionCodeStrings[ConditionCode]]))));
          Exit(ZYDIS_STATUS_SUCCESS);
        end;
      ZYDIS_MNEMONIC_VCMPPS:
        if (ConditionCode < $20) then
        begin
          Str.Append(PAnsiChar(AnsiString(
            Format('vcmp%sps', [ConditionCodeStrings[ConditionCode]]))));
          Exit(ZYDIS_STATUS_SUCCESS);
        end;
      ZYDIS_MNEMONIC_VCMPPD:
        if (ConditionCode < $20) then
        begin
          Str.Append(PAnsiChar(AnsiString(
            Format('vcmp%spd', [ConditionCodeStrings[ConditionCode]]))));
          Exit(ZYDIS_STATUS_SUCCESS);
        end;
    end;
  end;

  // We did not rewrite the instruction-mnemonic. Signal the @c DoFormatOperandImm callback not to
  // omit the operand
  FOmitImmediate := false;

  // Default mnemonic printing
  Result := inherited;
end;

{* ============================================================================================== *}
{* Entry point                                                                                    *}
{* ============================================================================================== *}

const
  X86DATA: array of Byte =
  [
    // cmpps xmm1, xmm4, 0x03
    $0F, $C2, $CC, $03,
    // vcmppd xmm1, xmm2, xmm3, 0x17
    $C5, $E9, $C2, $CB, $17,
    // vcmpps k2 {k7}, zmm2, dword ptr ds:[rax + rbx*4 + 0x100] {1to16}, 0x0F
    $62, $F1, $6C, $5F, $C2, $54, $98, $40, $0F
  ];

var
  Formatter: TZydisCustomFormatter;
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

    Formatter := TZydisCustomFormatter.Create(ZYDIS_FORMATTER_STYLE_INTEL);
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

        WriteLn;
        Formatter.RewriteMnemonics := true;

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

