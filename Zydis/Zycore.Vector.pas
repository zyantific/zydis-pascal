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

