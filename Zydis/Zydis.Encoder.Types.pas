unit Zydis.Encoder.Types;

{$IFDEF FPC}
  {$mode Delphi}
  {$PackRecords C}
{$ENDIF}

interface

uses
  Zydis.Enums,
  Zydis.Types,
  Zydis.Status;

const
  // Maximum number of encodable (explicit and implicit) operands
  ZYDIS_ENCODER_MAX_OPERANDS = 5;

  // Describes explicit or implicit instruction operand.
type
  TZydisEncoderOperand = record
    // The type of the operand.
    type_: TZydisOperandType;
    // Extended info for register-operands.
    reg: record
      // The register value.
      Value: TZydisRegister;
      // Is this the 4th operand (`VEX`/`XOP`). Despite its name, `is4` encoding can sometimes be
      // applied to the 3rd operand instead of the 4th. This field is used to resolve such ambiguities.
      // For all other operands, it should be set to `ZYAN_FALSE`.
      is4: ZyanBool;
    end;
    // Extended info for memory-operands.
    mem: record
      // The base register.
      base: TZydisRegister;
      // The index register.
      index: TZydisRegister;
      // The scale factor.
      scale: ZyanU8;
      // The displacement value.
      displacement: ZyanI64;
      // Size of this operand in bytes.
      size: ZyanU16;
    end;
    // Extended info for pointer-operands.
    ptr: record
      // The segment value.
      segment: ZyanU16;
      // The offset value.
      offset: ZyanU32;
    end;
    // Extended info for immediate-operands.
    imm: record
      case Integer of
        0: (u: ZyanU64);
        1: (s: ZyanI64);
    end;
  end;
  PZydisEncoderOperand = ^TZydisEncoderOperand;

  // Main structure consumed by the encoder. It represents full semantics of an instruction.
type
  TZydisEncoderRequest = record
    // The machine mode used to encode this instruction.
    machine_mode: TZydisMachineMode;
    // This optional field can be used to restrict allowed physical encodings for desired
    // instruction. Some mnemonics can be supported by more than one encoding, so this field can
    // resolve ambiguities, e.g., you can disable `AVX-512` extensions by prohibiting the usage of `EVEX`
    // prefix and allow only `VEX` variants.
    allowed_encodings: TZydisEncodableEncoding;
    // The instruction-mnemonic.
    mnemonic: TZydisMnemonic;
    // A combination of requested encodable prefixes (`ZYDIS_ATTRIB_HAS_*` flags) for desired
    // instruction. See `ZYDIS_ENCODABLE_PREFIXES` for a list of available prefixes.
    prefixes: TZydisInstructionAttributes;
    // Branch type (required for branching instructions only). Use `ZYDIS_BRANCH_TYPE_NONE` to let
    // encoder pick size-optimal branch type automatically (`short` and `near` are prioritized over
    // `far`).
    branch_type: TZydisBranchType;
    // Specifies physical size for relative immediate operands. Use `ZYDIS_BRANCH_WIDTH_NONE` to
    // let encoder pick size-optimal branch width automatically. For segment:offset `far` branches,
    // this field applies to the physical size of the offset part. For branching instructions without
    // relative operands, this field affects the effective operand size attribute.
    branch_width: TZydisBranchWidth;
    // Optional address size hint used to resolve ambiguities for some instructions. Generally,
    // encoder deduces the address size from `TZydisEncoderOperand` structures that represent
    // explicit and implicit operands. This hint resolves conflicts when the instruction's hidden
    // operands scale with the address size attribute.
    address_size_hint: TZydisAddressSizeHint;
    // Optional operand size hint used to resolve ambiguities for some instructions. Generally,
    // encoder deduces operand size from `TZydisEncoderOperand` structures that represent
    // explicit and implicit operands. This hint resolves conflicts when the instruction's hidden
    // operands scale with operand size attribute.
    operand_size_hint: TZydisOperandSizeHint;
    // The number of visible (explicit) instruction operands.

    // The encoder does not care about hidden (implicit) operands.
    operand_count: ZyanU8;
    // Detailed info for all explicit and implicit instruction operands.
    operands: array[0..ZYDIS_ENCODER_MAX_OPERANDS - 1] of TZydisEncoderOperand;
    // Extended info for `EVEX` instructions.
    evex: record
      // The broadcast-mode. Specify `ZYDIS_BROADCAST_MODE_INVALID` for instructions with
      // static broadcast functionality.
      broadcast: TZydisBroadcastMode;
      // The rounding-mode.
      rounding: TZydisRoundingMode;
      // Signals, if the `SAE` (suppress-all-exceptions) functionality should be enabled for
      // the instruction.
      sae: ZyanBool;
      // Signals, if the zeroing-mask functionality should be enabled for the instruction.
      // Specify `ZYAN_TRUE` for instructions with a forced zeroing mask.
      zeroing_mask: ZyanBool;
      end;
    // Extended info for `MVEX` instructions.
    mvex: record
      // The broadcast-mode.
      broadcast: TZydisBroadcastMode;
      // The data-conversion mode.
      conversion: TZydisConversionMode;
      // The rounding-mode.
      rounding: TZydisRoundingMode;
      // The `AVX` register-swizzle mode.
      swizzle: TZydisSwizzleMode;
      // Signals, if the `SAE` (suppress-all-exceptions) functionality is enabled for
      // the instruction.
      sae: ZyanBool;
      // Signals, if the instruction has a memory-eviction-hint (`KNC` only).
      eviction_hint: ZyanBool;
      end;
  end;
  PZydisEncoderRequest = ^TZydisEncoderRequest;


implementation

end.
