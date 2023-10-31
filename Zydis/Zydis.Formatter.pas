unit Zydis.Formatter;

{$IFDEF FPC}
  {$MODE DELPHI}
  {$PackRecords C}
{$ENDIF}

interface

uses
  Zydis.Enums,
  Zydis.Types,
  Zycore.Strings,
  Zycore.FormatterBuffer,
  Zydis.Decoder.Types;

type
  PZydisFormatter = ^TZydisFormatter;


  { Defines the ZydisFormatterContext struct. }
  TZydisFormatterContext = record
    { A pointer to the ZydisDecodedInstruction struct. }
    instruction: PZydisDecodedInstruction;
    { A pointer to the first ZydisDecodedOperand struct of the instruction. }
    operands: PZydisDecodedOperand;
    { A pointer to the ZydisDecodedOperand struct. }
    operand: PZydisDecodedOperand;
    { The runtime address of the instruction. }
    runtime_address: ZyanU64;
    { A pointer to user-defined data.

      This is the value that was previously passed as the user_data argument to
      ZydisFormatterFormatInstruction or ZydisFormatterTokenizeOperand.
    }
    user_data: Pointer;
  end;
  PZydisFormatterContext = ^TZydisFormatterContext;

  { Defines the ZydisFormatterFunc function prototype.

    @param formatter  A pointer to the ZydisFormatter instance.
    @param buffer     A pointer to the ZydisFormatterBuffer struct.
    @param context    A pointer to the ZydisFormatterContext struct.

    @return  A zyan status code.

    Returning a status code other than ZYAN_STATUS_SUCCESS will immediately cause the formatting
    process to fail (see exceptions below).

    Returning ZYDIS_STATUS_SKIP_TOKEN is valid for functions of the following types and will
    instruct the formatter to omit the whole operand:
    - ZYDIS_FORMATTER_FUNC_PRE_OPERAND
    - ZYDIS_FORMATTER_FUNC_POST_OPERAND
    - ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_REG
    - ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_MEM
    - ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_PTR
    - ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_IMM

    This function prototype is used by functions of the following types:
    - ZYDIS_FORMATTER_FUNC_PRE_INSTRUCTION
    - ZYDIS_FORMATTER_FUNC_POST_INSTRUCTION
    - ZYDIS_FORMATTER_FUNC_PRE_OPERAND
    - ZYDIS_FORMATTER_FUNC_POST_OPERAND
    - ZYDIS_FORMATTER_FUNC_FORMAT_INSTRUCTION
    - ZYDIS_FORMATTER_FUNC_PRINT_MNEMONIC
    - ZYDIS_FORMATTER_FUNC_PRINT_PREFIXES
    - ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_REG
    - ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_MEM
    - ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_PTR
    - ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_IMM
    - ZYDIS_FORMATTER_FUNC_PRINT_ADDRESS_ABS
    - ZYDIS_FORMATTER_FUNC_PRINT_ADDRESS_REL
    - ZYDIS_FORMATTER_FUNC_PRINT_DISP
    - ZYDIS_FORMATTER_FUNC_PRINT_IMM
    - ZYDIS_FORMATTER_FUNC_PRINT_TYPECAST
    - ZYDIS_FORMATTER_FUNC_PRINT_SEGMENT
  }
  TZydisFormatterFunc = function(const formatter: PZydisFormatter; buffer: PZydisFormatterBuffer;
    context: PZydisFormatterContext): ZyanStatus; cdecl;

  { Defines the ZydisFormatterRegisterFunc function prototype.

    @param formatter  A pointer to the ZydisFormatter instance.
    @param buffer     A pointer to the ZydisFormatterBuffer struct.
    @param context    A pointer to the ZydisFormatterContext struct.
    @param reg        The register.

    @return  Returning a status code other than ZYAN_STATUS_SUCCESS will immediately cause the
             formatting process to fail.
  }
  TZydisFormatterRegisterFunc = function(const formatter: PZydisFormatter; buffer: PZydisFormatterBuffer;
    context: PZydisFormatterContext; reg: TZydisRegister): ZyanStatus; cdecl;

  { Defines the ZydisFormatterDecoratorFunc function prototype.

    @param formatter  A pointer to the ZydisFormatter instance.
    @param buffer     A pointer to the ZydisFormatterBuffer struct.
    @param context    A pointer to the ZydisFormatterContext struct.
    @param decorator  The decorator type.

    @return  Returning a status code other than ZYAN_STATUS_SUCCESS will immediately cause the
             formatting process to fail.

    This function type is used for:
    - ZYDIS_FORMATTER_FUNC_PRINT_DECORATOR
  }
  TZydisFormatterDecoratorFunc = function(const formatter: PZydisFormatter; buffer: PZydisFormatterBuffer;
    context: PZydisFormatterContext; decorator: TZydisDecorator): ZyanStatus; cdecl;


  { Context structure keeping track of internal state of the formatter. }
  TZydisFormatter = record
    { The formatter style. }
    style: TZydisFormatterStyle;
    { The ZYDIS_FORMATTER_PROP_FORCE_SIZE property. }
    force_memory_size: ZyanBool;
    { The ZYDIS_FORMATTER_PROP_FORCE_SEGMENT property. }
    force_memory_segment: ZyanBool;
    { The ZYDIS_FORMATTER_PROP_FORCE_SCALE_ONE property. }
    force_memory_scale: ZyanBool;
    { The ZYDIS_FORMATTER_PROP_FORCE_RELATIVE_BRANCHES property. }
    force_relative_branches: ZyanBool;
    { The ZYDIS_FORMATTER_PROP_FORCE_RELATIVE_RIPREL property. }
    force_relative_riprel: ZyanBool;
    { The ZYDIS_FORMATTER_PROP_PRINT_BRANCH_SIZE property. }
    print_branch_size: ZyanBool;
    { The ZYDIS_FORMATTER_PROP_DETAILED_PREFIXES property. }
    detailed_prefixes: ZyanBool;
    { The ZYDIS_FORMATTER_PROP_ADDR_BASE property. }
    addr_base: TZydisNumericBase;
    { The ZYDIS_FORMATTER_PROP_ADDR_SIGNEDNESS property. }
    addr_signedness: TZydisSignedness;
    { The ZYDIS_FORMATTER_PROP_ADDR_PADDING_ABSOLUTE property. }
    addr_padding_absolute: TZydisPadding;
    { The ZYDIS_FORMATTER_PROP_ADDR_PADDING_RELATIVE property. }
    addr_padding_relative: TZydisPadding;
    { The ZYDIS_FORMATTER_PROP_DISP_BASE property. }
    disp_base: TZydisNumericBase;
    { The ZYDIS_FORMATTER_PROP_DISP_SIGNEDNESS property. }
    disp_signedness: TZydisSignedness;
    { The ZYDIS_FORMATTER_PROP_DISP_PADDING property. }
    disp_padding: TZydisPadding;
    { The ZYDIS_FORMATTER_PROP_IMM_BASE property. }
    imm_base: TZydisNumericBase;
    { The ZYDIS_FORMATTER_PROP_IMM_SIGNEDNESS property. }
    imm_signedness: TZydisSignedness;
    { The ZYDIS_FORMATTER_PROP_IMM_PADDING property. }
    imm_padding: TZydisPadding;
    { The ZYDIS_FORMATTER_PROP_UPPERCASE_PREFIXES property. }
    case_prefixes: ZyanI32;
    { The ZYDIS_FORMATTER_PROP_UPPERCASE_MNEMONIC property. }
    case_mnemonic: ZyanI32;
    { The ZYDIS_FORMATTER_PROP_UPPERCASE_REGISTERS property. }
    case_registers: ZyanI32;
    { The ZYDIS_FORMATTER_PROP_UPPERCASE_TYPECASTS property. }
    case_typecasts: ZyanI32;
    { The ZYDIS_FORMATTER_PROP_UPPERCASE_DECORATORS property. }
    case_decorators: ZyanI32;
    { The ZYDIS_FORMATTER_PROP_HEX_UPPERCASE property. }
    hex_uppercase: ZyanBool;
    { The ZYDIS_FORMATTER_PROP_HEX_FORCE_LEADING_NUMBER property. }
    hex_force_leading_number: ZyanBool;

    { The number formats for all numeric bases. }
    { Index 0 = prefix }
    { Index 1 = suffix }
    number_format: array[0..ZYDIS_NUMERIC_BASE_MAX_VALUE + 1, 0..1] of record
      { A pointer to the ZyanStringView to use as prefix/suffix. }
      string_: PZyanStringView;
      { The ZyanStringView to use as prefix/suffix. }
      string_data: TZyanStringView;
      { The actual string data. }
      buffer: array[0..10] of Char;
    end;

    { The ZYDIS_FORMATTER_FUNC_PRE_INSTRUCTION function. }
    func_pre_instruction: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_POST_INSTRUCTION function. }
    func_post_instruction: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_FORMAT_INSTRUCTION function. }
    func_format_instruction: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRE_OPERAND function. }
    func_pre_operand: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_POST_OPERAND function. }
    func_post_operand: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_REG function. }
    func_format_operand_reg: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_MEM function. }
    func_format_operand_mem: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_PTR function. }
    func_format_operand_ptr: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_FORMAT_OPERAND_IMM function. }
    func_format_operand_imm: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_MNEMONIC function. }
    func_print_mnemonic: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_REGISTER function. }
    func_print_register: TZydisFormatterRegisterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_ADDRESS_ABS function. }
    func_print_address_abs: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_ADDRESS_REL function. }
    func_print_address_rel: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_DISP function. }
    func_print_disp: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_IMM function. }
    func_print_imm: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_TYPECAST function. }
    func_print_typecast: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_SEGMENT function. }
    func_print_segment: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_PREFIXES function. }
    func_print_prefixes: TZydisFormatterFunc;
    { The ZYDIS_FORMATTER_FUNC_PRINT_DECORATOR function. }
    func_print_decorator: TZydisFormatterDecoratorFunc;
  end;


implementation

end.

