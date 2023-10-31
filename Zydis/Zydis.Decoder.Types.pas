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

unit Zydis.Decoder.Types;

{$IFDEF FPC}
  {$mode Delphi}
  {$PackRecords C}
{$ENDIF}

interface

uses
  Zydis.Enums,
  Zydis.Types;

type
  // Defines the `ZydisOperandAttributes` data-type.
  TZydisOperandAttributes = ZyanU8;
  // Defines the `ZydisAccessedFlagsMask` data-type.
  TZydisAccessedFlagsMask = ZyanU32;

const
  {
  The operand is a `MULTISOURCE4` register operand.

  This is a special register operand-type used by `4FMAPS` instructions where the given register
  points to the first register of a register range (4 registers in total).

  Example: ZMM3 -> [ZMM3..ZMM6]
  }
  ZYDIS_OATTRIB_IS_MULTISOURCE4 = $01;


type
  // Information about CPU/FPU flags accessed by the instruction.
  TZydisAccessedFlags = record
    // As mask containing the flags `TESTED` by the instruction.
    tested: TZydisAccessedFlagsMask;
    // As mask containing the flags `MODIFIED` by the instruction.
    modified: TZydisAccessedFlagsMask;
    // As mask containing the flags `SET_0` by the instruction.
    set_0: TZydisAccessedFlagsMask;
    // As mask containing the flags `SET_1` by the instruction.
    set_1: TZydisAccessedFlagsMask;
    // As mask containing the flags `UNDEFINED` by the instruction.
    undefined: TZydisAccessedFlagsMask;
  end; // TZydisAccessedFlags
  PZydisAccessedFlags = ^TZydisAccessedFlags;

  // Extended info for `AVX` instructions.
  TZydisDecodedInstructionAvx = record
    // The `AVX` vector-length.
    vector_length: ZyanU16;
    // Info about the embedded writemask-register (`AVX-512` and `KNC` only).
    mask: record
      // The masking mode.
      mode: TZydisMaskMode;
      // The mask register.
      reg: TZydisRegister;
    end;
    // Contains info about the `AVX` broadcast.
    broadcast: record
      // Signals, if the broadcast is a static broadcast.
      // This is the case for instructions with inbuilt broadcast functionality, which is
      // always active and not controlled by the `EVEX/MVEX.RC` bits.
      is_static: ZyanBool;
      // The `AVX` broadcast-mode.
      mode: TZydisBroadcastMode;
    end;
    // Contains info about the `AVX` rounding.
    rounding: record
      // The `AVX` rounding-mode.
      mode: TZydisRoundingMode;
    end;
    // Contains info about the `AVX` register-swizzle (`KNC` only).
    swizzle: record
      // The `AVX` register-swizzle mode.
      mode: TZydisSwizzleMode;
      end;
    // Contains info about the `AVX` data-conversion (`KNC` only).
    conversion: record
      // The `AVX` data-conversion mode.
      mode: TZydisConversionMode;
    end;
    // Signals, if the `SAE` (suppress-all-exceptions) functionality is enabled for the instruction.
    has_sae: ZyanBool;
    // Signals, if the instruction has a memory-eviction-hint (`KNC` only).
    has_eviction_hint: ZyanBool;
  end; // TZydisDecodedInstructionAvx
  PZydisDecodedInstructionAvx = ^TZydisDecodedInstructionAvx;

  // Instruction meta info.
  TZydisDecodedInstructionMeta = record
    // The instruction category.
    category: TZydisInstructionCategory;
    // The ISA-set.
    isa_set: TZydisISASet;
    // The ISA-set extension.
    isa_ext: TZydisISAExt;
    // The branch type.
    branch_type: TZydisBranchType;
    // The exception class.
    exception_class: TZydisExceptionClass;
  end; // TZydisDecodedInstructionMeta
  PZydisDecodedInstructionMeta = ^TZydisDecodedInstructionMeta;

  // Detailed info about the `REX` prefix.
  TZydisDecodedInstructionRawRex = record
    // 64-bit operand-size promotion.
    W: ZyanU8;
    // Extension of the `ModRM.reg` field.
    R: ZyanU8;
    // Extension of the `SIB.index` field.
    X: ZyanU8;
    // Extension of the `ModRM.rm`, `SIB.base`, or `opcode.reg` field.
    B: ZyanU8;
    // The offset of the effective `REX` byte, relative to the beginning of the instruction, in bytes.
    offset: ZyanU8;
  end; // TZydisDecodedInstructionRawRex
  PZydisDecodedInstructionRawRex = ^TZydisDecodedInstructionRawRex;

  // Detailed info about the `XOP` prefix.
  TZydisDecodedInstructionRawXop = record
    // Extension of the `ModRM.reg` field (inverted).
    R: ZyanU8;
    // Extension of the `SIB.index` field (inverted).
    X: ZyanU8;
    // Extension of the `ModRM.rm`, `SIB.base`, or `opcode.reg` field (inverted).
    B: ZyanU8;
    // Opcode-map specifier.
    m_mmmm: ZyanU8;
    // 64-bit operand-size promotion or opcode-extension.
    W: ZyanU8;
    // `NDS`/`NDD` (non-destructive-source/destination) register specifier (inverted).
    vvvv: ZyanU8;
    // Vector-length specifier.
    L: ZyanU8;
    // Compressed legacy prefix.
    pp: ZyanU8;
    // The offset of the first xop byte, relative to the beginning of the instruction, in bytes.
    offset: ZyanU8;
  end; // TZydisDecodedInstructionRawXop
  PZydisDecodedInstructionRawXop = ^TZydisDecodedInstructionRawXop;

  // Detailed info about the `VEX` prefix.
  TZydisDecodedInstructionRawVex = record
    R: ZyanU8; // Extension of the `ModRM.reg` field (inverted).
    X: ZyanU8; // Extension of the `SIB.index` field (inverted).
    B: ZyanU8; // Extension of the `ModRM.rm`, `SIB.base`, or `opcode.reg` field (inverted).
    m_mmmm: ZyanU8; // Opcode-map specifier.
    W: ZyanU8; // 64-bit operand-size promotion or opcode-extension.
    vvvv: ZyanU8;
    // `NDS`/`NDD` (non-destructive-source/destination) register specifier (inverted).
    L: ZyanU8; // Vector-length specifier.
    pp: ZyanU8; // Compressed legacy prefix.
    offset: ZyanU8;
    // The offset of the first `VEX` byte, relative to the beginning of the instruction, in bytes.
    size: ZyanU8; // The size of the `VEX` prefix, in bytes.
  end; // TZydisDecodedInstructionRawVex
  PZydisDecodedInstructionRawVex = ^TZydisDecodedInstructionRawVex;

  // Detailed info about the `EVEX` prefix.
  TZydisDecodedInstructionRawEvex = record
    R: ZyanU8; // Extension of the `ModRM.reg` field (inverted).
    X: ZyanU8; // Extension of the `SIB.index/vidx` field (inverted).
    ExtB: ZyanU8; // Extension of the `ModRM.rm` or `SIB.base` field (inverted).
    R2: ZyanU8; // High-16 register specifier modifier (inverted).
    mmm: ZyanU8; // Opcode-map specifier.
    W: ZyanU8; // 64-bit operand-size promotion or opcode-extension.
    vvvv: ZyanU8;
    // `NDS`/`NDD` (non-destructive-source/destination) register specifier (inverted).
    pp: ZyanU8; // Compressed legacy prefix.
    z: ZyanU8; // Zeroing/Merging.
    L2: ZyanU8; // Vector-length specifier or rounding-control (most significant bit).
    L: ZyanU8; // Vector-length specifier or rounding-control (least significant bit).
    BroadcastContext: ZyanU8; // Broadcast/RC/SAE context.
    V2: ZyanU8; // High-16 `NDS`/`VIDX` register specifier.
    aaa: ZyanU8; // Embedded opmask register specifier.
    offset: ZyanU8;
    // The offset of the first evex byte, relative to the beginning of the instruction, in bytes.
  end;
  PZydisDecodedInstructionRawEvex = ^TZydisDecodedInstructionRawEvex;

  // Detailed info about the `MVEX` prefix.
  TZydisDecodedInstructionRawMvex = record
    // Extension of the `ModRM.reg` field (inverted).
    R: ZyanU8;
    // Extension of the `SIB.index/vidx` field (inverted).
    X: ZyanU8;
    // Extension of the `ModRM.rm` or `SIB.base` field (inverted).
    B: ZyanU8;
    // High-16 register specifier modifier (inverted).
    R2: ZyanU8;
    // Opcode-map specifier.
    mmmm: ZyanU8;
    // 64-bit operand-size promotion or opcode-extension.
    W: ZyanU8;
    // `NDS`/`NDD` (non-destructive-source/destination) register specifier (inverted).
    vvvv: ZyanU8;
    // Compressed legacy prefix.
    pp: ZyanU8;
    // Non-temporal/eviction hint.
    E: ZyanU8;
    // Swizzle/broadcast/up-convert/down-convert/static-rounding controls.
    SSS: ZyanU8;
    // High-16 `NDS`/`VIDX` register specifier.
    V2: ZyanU8;
    // Embedded opmask register specifier.
    kkk: ZyanU8;
    // The offset of the first mvex byte, relative to the beginning of the instruction, in bytes.
    offset: ZyanU8;
  end; // TZydisDecodedInstructionRawMvex
  PZydisDecodedInstructionRawMvex = ^TZydisDecodedInstructionRawMvex;


  // Detailed info about different instruction-parts like `ModRM`, `SIB`, or encoding-prefixes.
  TZydisDecodedInstructionRaw = record
    prefix_count: ZyanU8; // The number of legacy prefixes.
    prefixes: array [0..ZYDIS_MAX_INSTRUCTION_LENGTH - 1] of record
      type_: TZydisPrefixType; // The prefix type.
      Value: ZyanU8; // The prefix byte.
    end;

    encoding2: TZydisInstructionEncoding; // Copy of the `encoding` field.

    union : record
      case integer of
        0: (rex: TZydisDecodedInstructionRawRex);
        1: (xop: TZydisDecodedInstructionRawXop);
        2: (vex: TZydisDecodedInstructionRawVex);
        3: (evex: TZydisDecodedInstructionRawEvex);
        4: (mvex: TZydisDecodedInstructionRawMvex);
    end;

    // Detailed info about the `ModRM` byte.
    modrm: record
      mod_: ZyanU8; // The addressing mode.
      reg: ZyanU8; // Register specifier or opcode-extension.
      rm: ZyanU8; // Register specifier or opcode-extension.
      offset: ZyanU8; // The offset of the `ModRM` byte, relative to the beginning of the instruction, in bytes.
    end;
    // Detailed info about the `SIB` byte.
    sib: record
      scale: ZyanU8; // The scale factor.
      index: ZyanU8; // The index-register specifier.
      base: ZyanU8; // The base-register specifier.
      offset: ZyanU8; // The offset of the `SIB` byte, relative to the beginning of the instruction, in bytes.
    end;
    // Detailed info about displacement-bytes.
    disp: record
      Value: ZyanI64; // The displacement value
      size: ZyanU8; // The physical displacement size, in bits.
      offset: ZyanU8; // The offset of the displacement data, relative to the beginning of the instruction, in bytes.
    end;

    imm: array [0..1] of record
      is_signed: ZyanBool; // Signals if the immediate value is signed.
      is_relative: ZyanBool; // Signals if the immediate value contains a relative offset. You can use
      // `ZydisCalcAbsoluteAddress` to determine the absolute address value.
      value: record
        case Integer of
          0: (u: ZyanU64);
          1: (s: ZyanI64);
      end;
      size: ZyanU8; // The physical immediate size, in bits.
      offset: ZyanU8; // The offset of the immediate data, relative to the beginning of the instruction, in bytes.
    end;
    // Detailed info about immediate-bytes.
  end;
  PZydisDecodedInstructionRaw = ^TZydisDecodedInstructionRaw;


  //../zydis/include/Zydis/DecoderTypes.h
  // Information about a decoded instruction.
  TZydisDecodedInstruction = record
    // The machine mode used to decode this instruction.
    machine_mode: TZydisMachineMode;
    // The instruction-mnemonic.
    mnemonic: TZydisMnemonic;
    // The length of the decoded instruction.
    length: ZyanU8;
    // The instruction-encoding (`LEGACY`, `3DNOW`, `VEX`, `EVEX`, `XOP`).
    encoding: TZydisInstructionEncoding;
    // The opcode-map.
    opcode_map: TZydisOpcodeMap;
    // The instruction-opcode.
    opcode: ZyanU8;
    // The stack width.
    stack_width: ZyanU8;
    // The effective operand width.
    operand_width: ZyanU8;
    // The effective address width.
    address_width: ZyanU8;
    // The number of instruction-operands.
    operand_count: ZyanU8;
    // The number of explicit (visible) instruction-operands.
    operand_count_visible: ZyanU8;
    // See instruction_attributes.
    attributes: TZydisInstructionAttributes;
    // Information about CPU flags accessed by the instruction.
    cpu_flags: PZydisAccessedFlags;
    // Information about FPU flags accessed by the instruction.
    fpu_flags: PZydisAccessedFlags;
    // Extended info for `AVX` instructions.
    avx: TZydisDecodedInstructionAvx;
    // Meta info.
    meta: TZydisDecodedInstructionMeta;
    // Detailed info about different instruction-parts like `ModRM`, `SIB` or encoding-prefixes.
    raw: TZydisDecodedInstructionRaw;
  end; // TZydisDecodedInstruction
  PZydisDecodedInstruction = ^TZydisDecodedInstruction;

  // Extended info for register-operands.
  TZydisDecodedOperandReg = record
    value : TZydisRegister; // The register value.
  end; // TZydisDecodedOperandReg
  PZydisDecodedOperandReg = ^TZydisDecodedOperandReg;

  // Extended info for memory-operands.
  TZydisDecodedOperandMem = record
    type_ : TZydisMemoryOperandType; // The type of the memory operand.
    segment : TZydisRegister; // The segment register.
    base : TZydisRegister; // The base register.
    index : TZydisRegister; // The index register.
    scale : ZyanU8; // The scale factor.
    // Extended info for memory-operands with displacement.
    disp : record
      has_displacement : ZyanBool;
      value : ZyanI64;
    end;
  end; // TZydisDecodedOperandMem
  PZydisDecodedOperandMem = ^TZydisDecodedOperandMem;

  // Extended info for pointer-operands.
  TZydisDecodedOperandPtr = record
    segment : ZyanU16;
    offset : ZyanU32;
  end; // TZydisDecodedOperandPtr
  PZydisDecodedOperandPtr = ^TZydisDecodedOperandPtr;

  TZydisDecodedOperandImm = record
    is_signed: ZyanBool; // Signals if the immediate value is signed.
    is_relative: ZyanBool; // Signals if the immediate value contains a relative offset. You can use
    // ZydisCalcAbsoluteAddress to determine the absolute address value.
    value: record
      case Integer of
        0: (u: ZyanU64);
        1: (s: ZyanI64);
    end;
  end;
  PZydisDecodedOperandImm = ^TZydisDecodedOperandImm;

  // Defines the `ZydisDecodedOperand` struct.
  TZydisDecodedOperand = record
    id: ZyanU8; // The operand-id.
    visibility: TZydisOperandVisibility; // The visibility of the operand.
    actions: TZydisOperandActions; // The operand-actions.
    encoding: TZydisOperandEncoding; // The operand-encoding.
    size: ZyanU16; // The logical size of the operand (in bits).
    element_type: TZydisElementType; // The element-type.
    element_size: TZydisElementSize; // The size of a single element.
    element_count: ZyanU16; // The number of elements.
    attributes: TZydisOperandAttributes; // Additional operand attributes.
    type_: TZydisOperandType; // The type of the operand.

    // These will correspond to the union members
    union : record
      case integer of
        0: (reg: TZydisDecodedOperandReg);
        1: (mem: TZydisDecodedOperandMem);
        2: (ptr: TZydisDecodedOperandPtr);
        3: (imm: TZydisDecodedOperandImm);
    end;
  end;
  PZydisDecodedOperand = ^TZydisDecodedOperand;

implementation

initialization
  // testing sizes
  //WriteLn('TZydisDecodedInstruction = ', SizeOf(TZydisDecodedInstruction));
  //WriteLn('TZydisDecodedInstructionAvx = ', SizeOf(TZydisDecodedInstructionAvx));
  //WriteLn('TZydisDecodedInstructionMeta = ', SizeOf(TZydisDecodedInstructionMeta));




end.



