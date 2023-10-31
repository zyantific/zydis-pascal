unit Zycore.Vector;

{$IFDEF FPC}
  {$mode Delphi}{$H+}{$J-}
  {$PackRecords C}
{$ENDIF}

interface

uses
  Zydis.Enums,
  Zydis.Types,
  Zycore.Allocator;

type
  { Defines the ZyanMemberProcedure function prototype. }
  TZyanMemberProcedure = procedure(obj: Pointer); cdecl;

  { Defines the ZyanConstMemberProcedure function prototype. }
  TZyanConstMemberProcedure = procedure(obj: Pointer); cdecl;

  { Defines the ZyanMemberFunction function prototype. }
  TZyanMemberFunction = function(obj: Pointer): ZyanStatus; cdecl;

  { Defines the ZyanConstMemberFunction function prototype. }
  TZyanConstMemberFunction = function(obj: Pointer): ZyanStatus; cdecl;


type
  { ZyanVector_ }
  TZyanVector = record
    { The memory allocator. }
    allocator: PZyanAllocator;
    { The growth factor. }
    growth_factor: ZyanU8;
    { The shrink threshold. }
    shrink_threshold: ZyanU8;
    { The current number of elements in the vector. }
    size: ZyanUSize;
    { The maximum capacity (number of elements). }
    capacity: ZyanUSize;
    { The size of a single element in bytes. }
    element_size: ZyanUSize;
    { The element destructor callback. }
    destructor_: TZyanMemberProcedure;
    { The data pointer. }
    data: Pointer; // You can specify a more specific data type if needed
  end;


implementation

end.

