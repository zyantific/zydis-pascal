unit Zycore.Strings;

{$IFDEF FPC}
  {$mode Delphi}{$H+}{$J-}
  {$PackRecords C}
{$ENDIF}

interface

uses
  Zydis.Enums,
  Zydis.Types,
  Zycore.Vector;

type

  TZyanString = record
    { String flags. }
    flags: TZyanStringFlags;
    { The vector that contains the actual string. }
    vector: TZyanVector;
  end;
  PZyanString = ^TZyanString;

  TZyanStringView = record
    // The string data.
    // The view internally re-uses the normal string struct to allow casts without any runtime
    // overhead.
    string_ : TZyanString;
  end;
  PZyanStringView = ^TZyanStringView;

implementation

end.

