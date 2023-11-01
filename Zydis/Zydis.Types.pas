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

unit Zydis.Types;

{$IfDef FPC}
  {$mode delphi}
  {$PackRecords C}
{$ENDIF}

interface

Type
  ZyanU8       = UInt8;
  ZyanU16      = UInt16;
  ZyanU32      = UInt32;
  ZyanU64      = UInt64;
  ZyanI8       = Int8;
  ZyanI16      = Int16;
  ZyanI32      = Int32;
  ZyanI64      = Int64;
  ZyanUSize    = PtrUInt;
  ZyanISize    = int64;
  ZyanUPointer = UIntPtr;
  ZyanIPointer = IntPtr;
  ZyanBool     = ZyanU8;

  PZyanU8 = ^ZyanU8;
  PZyanU16 = ^ZyanU16;
  PZyanU32 = ^ZyanU32;
  PZyanU64 = ^ZyanU64;
  PZyanI8 = ^ZyanI8;
  PZyanI16 = ^ZyanI16;
  PZyanI32 = ^ZyanI32;
  PZyanI64 = ^ZyanI64;
  PZyanUSize = ^ZyanUSize;
  PZyanISize = ^ZyanISize;
  PZyanUPointer = ^ZyanUPointer;
  PZyanIPointer = ^ZyanIPointer;
  PZyanBool = ^ZyanBool;

{$I stdinth.inc} // Taken from fpcsrc\packages\libc\src\stdinth.inc

const
  ZYAN_INT8_MIN   = INT8_MIN;
  ZYAN_INT16_MIN  = INT16_MIN;
  ZYAN_INT32_MIN  = INT32_MIN;
  ZYAN_INT64_MIN  = INT64_MIN;
  ZYAN_INT8_MAX   = INT8_MAX;
  ZYAN_INT16_MAX  = INT16_MAX;
  ZYAN_INT32_MAX  = INT32_MAX;
  ZYAN_INT64_MAX  = INT64_MAX;
  ZYAN_UINT8_MAX  = UINT8_MAX;
  ZYAN_UINT16_MAX = UINT16_MAX;
  ZYAN_UINT32_MAX = UINT32_MAX;
  ZYAN_UINT64_MAX = UINT64_MAX;


// Defines decoder/encoder-shared macros and types.
const
  ZYDIS_MAX_INSTRUCTION_LENGTH = 15;
  ZYDIS_MAX_OPERAND_COUNT = 10;
  ZYDIS_MAX_OPERAND_COUNT_VISIBLE = 5;

// Instruction attributes
const
  // The instruction has the `ModRM` byte.
  ZYDIS_ATTRIB_HAS_MODRM = 1 shl 0;

  // The instruction has the `SIB` byte.
  ZYDIS_ATTRIB_HAS_SIB = 1 shl 1;

  // The instruction has the `REX` prefix.
  ZYDIS_ATTRIB_HAS_REX = 1 shl 2;

  // The instruction has the `XOP` prefix.
  ZYDIS_ATTRIB_HAS_XOP = 1 shl 3;

  // The instruction has the `VEX` prefix.
  ZYDIS_ATTRIB_HAS_VEX = 1 shl 4;

  // The instruction has the `EVEX` prefix.
  ZYDIS_ATTRIB_HAS_EVEX = 1 shl 5;

  // The instruction has the `MVEX` prefix.
  ZYDIS_ATTRIB_HAS_MVEX = 1 shl 6;

  // The instruction has one or more operands with position-relative offsets.
  ZYDIS_ATTRIB_IS_RELATIVE = 1 shl 7;

  // The instruction is privileged.
  // Privileged instructions are any instructions that require a current ring level below 3.
  ZYDIS_ATTRIB_IS_PRIVILEGED = 1 shl 8;

  // The instruction accesses one or more CPU-flags.
  ZYDIS_ATTRIB_CPUFLAG_ACCESS = 1 shl 9;

  // The instruction may conditionally read the general CPU state.
  ZYDIS_ATTRIB_CPU_STATE_CR = 1 shl 10;

  // The instruction may conditionally write the general CPU state.
  ZYDIS_ATTRIB_CPU_STATE_CW = 1 shl 11;

  // The instruction may conditionally read the FPU state (X87, MMX).
  ZYDIS_ATTRIB_FPU_STATE_CR = 1 shl 12;

  // The instruction may conditionally write the FPU state (X87, MMX).
  ZYDIS_ATTRIB_FPU_STATE_CW = 1 shl 13;

  // The instruction may conditionally read the XMM state (AVX, AVX2, AVX-512).
  ZYDIS_ATTRIB_XMM_STATE_CR = 1 shl 14;

  // The instruction may conditionally write the XMM state (AVX, AVX2, AVX-512).
  ZYDIS_ATTRIB_XMM_STATE_CW = 1 shl 15;

  // The instruction accepts the `LOCK` prefix (`0xF0`).
  ZYDIS_ATTRIB_ACCEPTS_LOCK = 1 shl 16;

  // The instruction accepts the `REP` prefix (`0xF3`).
  ZYDIS_ATTRIB_ACCEPTS_REP = 1 shl 17;

  // The instruction accepts the `REPE`/`REPZ` prefix (`0xF3`).
  ZYDIS_ATTRIB_ACCEPTS_REPE = 1 shl 18;

  // The instruction accepts the `REPNE`/`REPNZ` prefix (`0xF2`).
  ZYDIS_ATTRIB_ACCEPTS_REPNE = 1 shl 19;

  // The instruction accepts the `BND` prefix (`0xF2`).
  ZYDIS_ATTRIB_ACCEPTS_BND = 1 shl 20;

  // The instruction accepts the `XACQUIRE` prefix (`0xF2`).
  ZYDIS_ATTRIB_ACCEPTS_XACQUIRE = 1 shl 21;

  // The instruction accepts the `XRELEASE` prefix (`0xF3`).
  ZYDIS_ATTRIB_ACCEPTS_XRELEASE = 1 shl 22;

  // The instruction accepts the `XACQUIRE`/`XRELEASE` prefixes (`0xF2`, `0xF3`)
  // without the `LOCK` prefix (`0x0F`).
  ZYDIS_ATTRIB_ACCEPTS_HLE_WITHOUT_LOCK = 1 shl 23;

  // The instruction accepts branch hints (0x2E, 0x3E).
  ZYDIS_ATTRIB_ACCEPTS_BRANCH_HINTS = 1 shl 24;

  // The instruction accepts the `CET` `no-track` prefix (`0x3E`).
  ZYDIS_ATTRIB_ACCEPTS_NOTRACK = 1 shl 25;

  // The instruction accepts segment prefixes (`0x2E`, `0x36`, `0x3E`, `0x26`,
  // `0x64`, `0x65`).
  ZYDIS_ATTRIB_ACCEPTS_SEGMENT = 1 shl 26;

  // The instruction has the `LOCK` prefix (`0xF0`).
  ZYDIS_ATTRIB_HAS_LOCK = 1 shl 27;

  // The instruction has the `REP` prefix (`0xF3`).
  ZYDIS_ATTRIB_HAS_REP = 1 shl 28;

  // The instruction has the `REPE`/`REPZ` prefix (`0xF3`).
  ZYDIS_ATTRIB_HAS_REPE = 1 shl 29;

  // The instruction has the `REPNE`/`REPNZ` prefix (`0xF2`).
  ZYDIS_ATTRIB_HAS_REPNE = 1 shl 30;

  // The instruction has the `BND` prefix (`0xF2`).
  ZYDIS_ATTRIB_HAS_BND = 1 shl 31;

  // The instruction has the `XACQUIRE` prefix (`0xF2`).
  ZYDIS_ATTRIB_HAS_XACQUIRE = 1 shl 32;

  // The instruction has the `XRELEASE` prefix (`0xF3`).
  ZYDIS_ATTRIB_HAS_XRELEASE = 1 shl 33;

  // The instruction has the branch-not-taken hint (`0x2E`).
  ZYDIS_ATTRIB_HAS_BRANCH_NOT_TAKEN = 1 shl 34;

  // The instruction has the branch-taken hint (`0x3E`).
  ZYDIS_ATTRIB_HAS_BRANCH_TAKEN = 1 shl 35;

  // The instruction has the `CET` `no-track` prefix (`0x3E`).
  ZYDIS_ATTRIB_HAS_NOTRACK = 1 shl 36;

  // The instruction has the `CS` segment modifier (`0x2E`).
  ZYDIS_ATTRIB_HAS_SEGMENT_CS = 1 shl 37;

  // The instruction has the `SS` segment modifier (`0x36`).
  ZYDIS_ATTRIB_HAS_SEGMENT_SS = 1 shl 38;

  // The instruction has the `DS` segment modifier (`0x3E`).
  ZYDIS_ATTRIB_HAS_SEGMENT_DS = 1 shl 39;

  // The instruction has the `ES` segment modifier (`0x26`).
  ZYDIS_ATTRIB_HAS_SEGMENT_ES = 1 shl 40;

  // The instruction has the `FS` segment modifier (`0x64`).
  ZYDIS_ATTRIB_HAS_SEGMENT_FS = 1 shl 41;

  // The instruction has the `GS` segment modifier (`0x65`).
  ZYDIS_ATTRIB_HAS_SEGMENT_GS = 1 shl 42;

  // The instruction has a segment modifier.
  ZYDIS_ATTRIB_HAS_SEGMENT = ZYDIS_ATTRIB_HAS_SEGMENT_CS or
                            ZYDIS_ATTRIB_HAS_SEGMENT_SS or
                            ZYDIS_ATTRIB_HAS_SEGMENT_DS or
                            ZYDIS_ATTRIB_HAS_SEGMENT_ES or
                            ZYDIS_ATTRIB_HAS_SEGMENT_FS or
                            ZYDIS_ATTRIB_HAS_SEGMENT_GS;

  // The instruction has the operand-size override prefix (`0x66`).
  ZYDIS_ATTRIB_HAS_OPERANDSIZE = 1 shl 43;

  // The instruction has the address-size override prefix (`0x67`).
  ZYDIS_ATTRIB_HAS_ADDRESSSIZE = 1 shl 44;

  // The instruction has the `EVEX.b` bit set.
  // This attribute is mainly used by the encoder.
  ZYDIS_ATTRIB_HAS_EVEX_B = 1 shl 45;


Type
  // Defines the `ZydisInstructionAttributes` data-type.
  TZydisInstructionAttributes = ZyanU64;
  // Defines the `ZydisElementSize` datatype.
  TZydisElementSize = ZyanU16;
  // Defines the `ZydisOperandActions` data-type.
  TZydisOperandActions = ZyanU8;


Type
  // Defines the `ZyanVoidPointer` data-type.
  TZyanVoidPointer = Pointer;
  // Defines the `ZyanConstVoidPointer` data-type.
  TZyanConstVoidPointer = Pointer;

Type
  TZyanStringFlags = ZyanU8;

const
  ZYAN_NULL = nil;


Type { Enums and types }
  // Defines the `ZyanStatus` data type.
  ZyanStatus = ZyanU32;

implementation


end.
