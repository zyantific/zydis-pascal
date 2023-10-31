unit zycore.formatterbuffer;

{$IFDEF FPC}
  {$mode Delphi}{$H+}{$J-}
  {$PackRecords C}
{$ENDIF}

interface

uses
  Zydis.enums,
  Zydis.types,
  Zycore.strings;

type
  { Defines the ZydisFormatterBuffer struct. }
  TZydisFormatterBuffer = record
    { ZYAN_TRUE, if the buffer contains a token stream or ZYAN_FALSE, if it contains a simple string. }
    is_token_list: ZyanBool;
    { The remaining capacity of the buffer. }
    capacity: ZyanUSize;
    { The ZyanString instance that refers to the literal value of the most recently added token. }
    string_: TZyanString;
  end;
  PZydisFormatterBuffer = ^TZydisFormatterBuffer;

implementation

end.

