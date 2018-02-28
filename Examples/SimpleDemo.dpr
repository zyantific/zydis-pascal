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

program SimpleDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Zydis in '../Zydis/Zydis.pas',
  Zydis.Exception in '../Zydis/Zydis.Exception.pas',
  Zydis.Decoder in '../Zydis/Zydis.Decoder.pas',
  Zydis.Formatter in '../Zydis/Zydis.Formatter.pas';

{* ============================================================================================== *}
{* Entry point                                                                                    *}
{* ============================================================================================== *}

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

