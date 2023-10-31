unit Zycore.Allocator;

{$IFDEF FPC}
  {$mode Delphi}{$H+}{$J-}
  {$PackRecords C}
{$ENDIF}


interface

uses
  Zydis.Enums,
  Zydis.Types;

type
  // Pointer to TZyanAllocator
  PZyanAllocator = ^TZyanAllocator;

  { Defines the ZyanAllocatorAllocate function prototype. }
  ZyanAllocatorAllocate = function(allocator: PZyanAllocator; var p: Pointer;
    element_size, n: ZyanUSize): ZyanStatus; cdecl;

  { Defines the ZyanAllocatorDeallocate function prototype. }
  ZyanAllocatorDeallocate = function(allocator: PZyanAllocator; p: Pointer;
    element_size, n: ZyanUSize): ZyanStatus; cdecl;


  { Defines the ZyanAllocator struct. }
  TZyanAllocator = record
    { This is the base class for all custom allocator implementations. }
    { All fields in this struct should be considered as "private". Any changes may lead to unexpected behavior. }

    { The allocate function. }
    allocate: ZyanAllocatorAllocate;
    { The reallocate function. }
    reallocate: ZyanAllocatorAllocate;
    { The deallocate function. }
    deallocate: ZyanAllocatorDeallocate;
  end;



implementation

end.

