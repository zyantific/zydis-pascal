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

