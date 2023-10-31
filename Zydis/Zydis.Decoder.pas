unit Zydis.Decoder;

{$mode ObjFPC}{$H+}

interface

uses
  Zydis.enums, Zydis.types;


Type
  // Defines the `ZydisDecoder` struct.
  TZydisDecoder = record
    machine_mode : TZydisMachineMode; // The machine mode.
    stack_width : TZydisStackWidth; // The stack width.
    decoder_mode : ZyanU32; // The decoder mode bitmap.
  end; // TZydisDecoder
  PZydisDecoder = ^TZydisDecoder;

implementation

end.

