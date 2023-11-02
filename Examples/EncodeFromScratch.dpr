program EncodeFromScratch;

{$IfDef MSWINDOWS}
  {$APPTYPE CONSOLE}
{$EndIf}


uses
  {$IfDef UNIX}
  BaseUnix,
  {$Else}
  Windows,
  {$EndIf}
  SysUtils,
  Zydis.Apis,
  Zydis.Enums,
  Zydis.Types,
  Zydis.Status,
  Zydis.Encoder.Types;

const
  EXIT_FAILURE = 1;

  procedure ExpectSuccess(status: ZyanStatus);
  begin
    if ZYAN_FAILED(status) then
    begin
      WriteLn('Something failed: 0x', IntToHex(status, 8));
      Halt(EXIT_FAILURE);
    end;
  end;

  procedure AppendInstruction(req: PZydisEncoderRequest; var buffer: PZyanU8;
  var buffer_length: ZyanUSize);
  var
    instr_length: ZyanUSize;
  begin
    instr_length := buffer_length;
    ExpectSuccess(ZydisEncoderEncodeInstruction(req, buffer, @instr_length));
    Inc(buffer, instr_length);
    Dec(buffer_length, instr_length);
  end;

  function AssembleCode(buffer: PZyanU8; buffer_length: ZyanUSize): ZyanUSize;
  var
    write_ptr: PZyanU8;
    remaining_length: ZyanUSize;
    req: TZydisEncoderRequest;
  begin
    write_ptr := buffer;
    remaining_length := buffer_length;

    // Assemble `mov rax, $1337`.
    FillChar(req, SizeOf(TZydisEncoderRequest), 0);

    req.mnemonic := ZYDIS_MNEMONIC_MOV;
    req.machine_mode := ZYDIS_MACHINE_MODE_LONG_64;
    req.operand_count := 2;
    req.operands[0].type_ := ZYDIS_OPERAND_TYPE_REGISTER;
    req.operands[0].reg.Value := ZYDIS_REGISTER_RAX;
    req.operands[1].type_ := ZYDIS_OPERAND_TYPE_IMMEDIATE;
    req.operands[1].imm.u := $1337;
    AppendInstruction(@req, write_ptr, remaining_length);

    // Assemble `ret`.
    FillChar(req, SizeOf(TZydisEncoderRequest), 0);
    req.mnemonic := ZYDIS_MNEMONIC_RET;
    req.machine_mode := ZYDIS_MACHINE_MODE_LONG_64;
    AppendInstruction(@req, write_ptr, remaining_length);

    Result := buffer_length - remaining_length;
  end;

type
  TRetFunc = function: ZyanU64;

var
  page_size, alloc_size: ZyanUSize;
  buffer, aligned: PZyanU8;
  length: ZyanUSize;
  func_ptr: TRetFunc;
  Result: ZyanU64;
  {$IfDef MSWINDOWS}OldProtection: DWORD;{$EndIf}
  i: integer;
begin
  // Allocate 2 pages of memory. We won't need nearly as much, but it simplifies
  // re-protecting the memory to RWX later.
  page_size := $1000;
  alloc_size := page_size * 2;
  buffer := AllocMem(alloc_size);

  // Assemble our function.
  length := AssembleCode(buffer, alloc_size);

  // Print a hex-dump of the assembled code.
  WriteLn('Created byte-code:');
  for i := 0 to length - 1 do
    Write(Format('%.2X ', [TBytes(buffer)[i]]));
  WriteLn;

  {$IFDEF CPUX64}
  // Align pointer to typical page size.
  aligned := PZyanU8(NativeUInt(buffer) and not (page_size - 1));

  { Only Enable for Dynamic linked Zydis library cuz it needs libc }
  //ExpectSuccess(ZyanMemoryVirtualProtect(aligned, alloc_size, ZYAN_PAGE_EXECUTE_READWRITE));

  // Re-protect the heap region as RWX. Don't do this at home, kids!
  {$IfDef UNIX}
  if Fpmprotect(aligned, alloc_size, PROT_EXEC or PROT_READ or PROT_WRITE) = 0 then
  {$ELSE}
  if VirtualProtect(aligned, alloc_size, PAGE_EXECUTE_READWRITE, OldProtection) then
  {$EndIf}
  begin
    // Create a function pointer for our buffer.
    func_ptr := TRetFunc(buffer);

    // Call the function!
    result := func_ptr();
    WriteLn('Return value of JITed code: 0x', IntToHex(result, 16));
  end;
  {$ENDIF}
  Freemem(buffer);
  ReadLn;
end.
