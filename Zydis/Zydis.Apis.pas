{******************************************************************************

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

unit Zydis.Apis;

{$IFDEF FPC}
  {$PackRecords C}
{$ENDIF}

interface

uses
  Zydis.Enums,
  Zydis.Types,
  Zydis.Decoder,
  Zydis.Encoder.Types,
  Zydis.Decoder.Types,
  Zydis.Formatter.Types,
  Zydis.Disassembler.Types;


  {.$DEFINE Z_DYN_LINK}
  {$IFDEF Z_DYN_LINK}
const
  {$IFDEF CPUX86}
  Z_LIB_NAME = 'Zydis32.dll';
  {$ENDIF}
  {$IFDEF CPUX64}
  Z_LIB_NAME = 'Zydis64.dll';
  {$ENDIF}
  _PREFIX = '';
  {$ELSE}

const
  {$ifdef OSWINDOWS}
    {$ifdef CPU64}
      _PREFIX = '';
    {$else}
      _PREFIX = '_';
    {$endif CPU64}
  {$else}
  {$ifdef OSDARWIN}
        _PREFIX = '_';
  {$else}
  _PREFIX = ''; // other POSIX systems don't haveany trailing underscore
  {$endif OSDARWIN}
  {$endif OSWINDOWS}
  {$IFDEF CPUX86}
      {$L 'Bin32/Decoder.obj'}
      {$L 'Bin32/DecoderData.obj'}
      {$L 'Bin32/Formatter.obj'}
      {$L 'Bin32/MetaInfo.obj'}
      {$L 'Bin32/Mnemonic.obj'}
      {$L 'Bin32/Register.obj'}
      {$L 'Bin32/SharedData.obj'}
      {$L 'Bin32/String.obj'}
      {$L 'Bin32/Utils.obj'}
      {$L 'Bin32/Zydis.obj'}
  {$ENDIF}
  {$IFDEF CPUX64}
    {$IFDEF FPC}
      {$LinkLib libZydis.a}
      {$LinkLib libZycore.a}

    {$ELSE}
      {$L 'Bin64/Decoder.obj'}
      {$L 'Bin64/DecoderData.obj'}
      {$L 'Bin64/Formatter.obj'}
      {$L 'Bin64/MetaInfo.obj'}
      {$L 'Bin64/Mnemonic.obj'}
      {$L 'Bin64/Register.obj'}
      {$L 'Bin64/SharedData.obj'}
      {$L 'Bin64/String.obj'}
      {$L 'Bin64/Utils.obj'}
      {$L 'Bin64/Zydis.obj'}
    {$ENDIF}
  {$ENDIF}
  {$ENDIF}



// ===========================================================================*}
// Constants
// ===========================================================================*}
const
  ZYDIS_VERSION = $0004000000000000;



// -------------------------------------------------------------------------- *}
// Zydis Version APIs
// -------------------------------------------------------------------------- *}
procedure ZydisDecoderInit(decoder: PZydisDecoder; machine_mode: TZydisMachineMode;
  stack_width: TZydisStackWidth); cdecl; external
    {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
    Name _PREFIX + 'ZydisDecoderInit';

// -------------------------------------------------------------------------- *}
// Zydis Disassembler
// -------------------------------------------------------------------------- *}

{
  Disassemble an instruction and format it to human-readable text in a single step (Intel syntax).

  @param machine_mode      The machine mode to assume when disassembling. When in doubt, pass
                          ZYDIS_MACHINE_MODE_LONG_64 for what is typically referred to as
                          "64-bit mode" or ZYDIS_MACHINE_MODE_LEGACY_32 for "32-bit mode".
  @param runtime_address   The program counter (eip / rip) to assume when formatting the
                          instruction. Many instructions behave differently depending on the
                          address they are located at.
  @param buffer            A pointer to the raw instruction bytes that you wish to decode.
  @param length            The length of the input buffer. Note that this can be bigger than the
                          actual size of the instruction -- you don't have to know the size up
                          front. This length is merely used to prevent Zydis from doing
                          out-of-bounds reads on your buffer.
  @param instruction       A pointer to receive the decoded instruction information. Can be
                          uninitialized and reused on later calls.

  This is a convenience function intended as a quick path for getting started with using Zydis.
  It internally calls a range of other more advanced functions to obtain all commonly needed
  information about the instruction. It is likely that you won't need most of this information in
  practice, so it is advisable to instead call these more advanced functions directly if you're
  concerned about performance.

  This function essentially combines the following more advanced functions into a single call:
    - ZydisDecoderInit
    - ZydisDecoderDecodeInstruction
    - ZydisDecoderDecodeOperands
    - ZydisFormatterInit
    - ZydisFormatterFormatInstruction

  @return  A zyan status code.
}
function ZydisDisassembleIntel(machine_mode: TZydisMachineMode;
  runtime_address: ZyanU64; buffer: Pointer; length: ZyanUSize;
  var instruction: TZydisDisassembledInstruction): ZyanStatus; external
  {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZydisDisassembleIntel';


// -------------------------------------------------------------------------- *}
// Zydis Decoder
// -------------------------------------------------------------------------- *}


{
  Decodes the instruction in the given input buffer and returns all details (e.g. operands).

  @param decoder       A pointer to the ZydisDecoder instance.
  @param buffer        A pointer to the input buffer.
  @param length        The length of the input buffer. Note that this can be bigger than the
                      actual size of the instruction -- you don't have to know the size up
                      front. This length is merely used to prevent Zydis from doing
                      out-of-bounds reads on your buffer.
  @param instruction   A pointer to the ZydisDecodedInstruction struct receiving the details
                      about the decoded instruction.
  @param operands      A pointer to an array with ZYDIS_MAX_OPERAND_COUNT entries that
                      receives the decoded operands. The number of operands decoded is
                      determined by the instruction.operand_count field. Excess entries are
                      zeroed.

  This is a convenience function that combines the following functions into one call:
  - ZydisDecoderDecodeInstruction
  - ZydisDecoderDecodeOperands

  Please refer to ZydisDecoderDecodeInstruction if operand decoding is not required or should
  be done separately (ZydisDecoderDecodeOperands).

  This function is not available in MINIMAL_MODE.

  @return  A zyan status code.
}

function ZydisDecoderDecodeFull(const decoder: PZydisDecoder; const buffer: Pointer;
  length: ZyanUSize; var instruction: TZydisDecodedInstruction;
  operands: array of TZydisDecodedOperand): ZyanStatus; cdecl; external
  {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZydisDecoderDecodeFull';





// -------------------------------------------------------------------------- *}
// Zydis Formatter APIs
// -------------------------------------------------------------------------- *}

{
  Initializes the given ZydisFormatter instance.

  @param formatter  A pointer to the ZydisFormatter instance.
  @param style      The base formatter style (either AT&T or Intel style).

  @return  A zyan status code.
}
function ZydisFormatterInit(formatter: PZydisFormatter; style: TZydisFormatterStyle): ZyanStatus; cdecl;external
  {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZydisFormatterInit';

  {
   * Formats the given instruction and writes it into the output buffer.
   *
   * @param   formatter       A pointer to the `ZydisFormatter` instance.
   * @param   instruction     A pointer to the `ZydisDecodedInstruction` struct.
   * @param   operands        A pointer to the decoded operands array.
   * @param   operand_count   The length of the `operands` array. Must be equal to or greater than
   *                          the value of `instruction^.operand_count_visible`.
   * @param   buffer          A pointer to the output buffer.
   * @param   length          The length of the output buffer (in characters).
   * @param   runtime_address The runtime address of the instruction or `ZYDIS_RUNTIME_ADDRESS_NONE`
   *                          to print relative addresses.
   * @param   user_data       A pointer to user-defined data which can be used in custom formatter
   *                          callbacks. Can be `ZYAN_NULL`.
   *
   * @return  A zyan status code.
   *}
  function ZydisFormatterFormatInstruction(const formatter: PZydisFormatter;
      const instruction: PZydisDecodedInstruction; const operands: PZydisDecodedOperand;
      operand_count: ZyanU8; buffer: PAnsiChar; length: ZyanUSize;
      runtime_address: ZyanU64; user_data: Pointer): ZyanStatus; cdecl;external
  {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZydisFormatterFormatInstruction';


// -------------------------------------------------------------------------- *}
// Zydis Encoder APIs
// -------------------------------------------------------------------------- *}

{
  Encodes instruction with semantics specified in encoder request structure.

  @param   request     A pointer to the `TZydisEncoderRequest` record.
  @param   buffer      A pointer to the output buffer receiving the encoded instruction.
  @param   length      A pointer to the variable containing the length of the output buffer.
                       Upon successful return, this variable receives the length of the encoded instruction.

  @return  A Zyan status code.
}
function ZydisEncoderEncodeInstruction(const request: PZydisEncoderRequest;
  buffer: Pointer; length: PZyanUSize): ZyanStatus; cdecl; external
  {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZydisEncoderEncodeInstruction';



{$IfDef ZYDIS_LIBC}
  // Zydis Memory APIs
{
  Returns the system page size.

  @return  The system page size.
}
function ZyanMemoryGetSystemPageSize: ZyanU32; cdecl; external
  {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZyanMemoryGetSystemPageSize';

{
  Returns the system allocation granularity.

  The system allocation granularity specifies the minimum amount of bytes which can be allocated
  at a specific address by a single call of `ZyanMemoryVirtualAlloc`.

  This value is typically 64KiB on Windows systems and equal to the page size on most POSIX
  platforms.

  @return  The system allocation granularity.
}
function ZyanMemoryGetSystemAllocationGranularity: ZyanU32; cdecl; external
  {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZyanMemoryGetSystemAllocationGranularity';

{
  Changes the memory protection value of one or more pages.

  @param   address     The start address aligned to a page boundary.
  @param   size        The size.
  @param   protection  The new page protection value.

  @return  A Zyan status code.
}
function ZyanMemoryVirtualProtect(address: Pointer; size: ZyanUSize;
  protection: TZyanMemoryPageProtection): ZyanStatus; cdecl; external
  {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZyanMemoryVirtualProtect';

{
  Releases one or more memory pages starting at the given address.

  @param   address The start address aligned to a page boundary.
  @param   size    The size.

  @return  A Zyan status code.
}
function ZyanMemoryVirtualFree(address: Pointer; size: ZyanUSize): ZyanStatus; cdecl; external
  {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZyanMemoryVirtualFree';

{$EndIf}




// -------------------------------------------------------------------------- *}
// Zydis Version APIs                                                         *}
// -------------------------------------------------------------------------- *}

function ZydisGetVersion: ZyanU64; cdecl; external {$IFDEF Z_DYN_LINK}Z_LIB_NAME{$ENDIF}
  Name _PREFIX + 'ZydisGetVersion';

function ZydisVersionMajor(Version: ZyanU64): ZyanU16; inline;
function ZydisVersionMinor(Version: ZyanU64): ZyanU16; inline;
function ZydisVersionPatch(Version: ZyanU64): ZyanU16; inline;
function ZydisVersionBuild(Version: ZyanU64): ZyanU16; inline;


implementation

function memset(dest: Pointer; val: integer; Count: PtrInt): Pointer; cdecl;
  {$ifdef FPC}public name _PREFIX + 'memset';{$endif}
begin
  FillChar(dest^, Count, val);
  Result := dest;
end;

// -------------------------------------------------------------------------- *}
// Zydis Version Utils Functions
// -------------------------------------------------------------------------- *}

function ZydisVersionMajor(Version: ZyanU64): ZyanU16;
begin
  Result := (Version and $FFFF000000000000) shr 48;
end;

function ZydisVersionMinor(Version: ZyanU64): ZyanU16;
begin
  Result := (Version and $0000FFFF00000000) shr 32;
end;

function ZydisVersionPatch(Version: ZyanU64): ZyanU16;
begin
  Result := (Version and $00000000FFFF0000) shr 16;
end;

function ZydisVersionBuild(Version: ZyanU64): ZyanU16;
begin
  Result := (Version and $000000000000FFFF);
end;

end.
