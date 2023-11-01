{*******************************************************************************

  Zydis Pascal API By Coldzer0

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

*******************************************************************************}
unit Zydis.Disassembler.Types;

{$IFDEF FPC}
  {$mode Delphi}
  {$PackRecords C}
{$ENDIF}

interface

uses
  Zydis.Types,
  Zydis.Decoder.Types;

type
  {
   All commonly used information about a decoded instruction that Zydis can provide.
   This structure is filled in by calling `ZydisDisassembleIntel` or `ZydisDisassembleATT`.
  }
  TZydisDisassembledInstruction = record
    // The runtime address that was passed when disassembling the instruction.
    runtime_address : ZyanU64;
    info : TZydisDecodedInstruction;
    operands : Array [1..ZYDIS_MAX_OPERAND_COUNT] of TZydisDecodedOperand;
    text : Array [1..96] of Char;
  end;
  PZydisDisassembledInstruction = ^TZydisDisassembledInstruction;

implementation

end.

