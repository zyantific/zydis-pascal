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

unit Zydis.Enums;

{$IfDef FPC}
  {$mode delphi}
  {$PackRecords C}
  {$PACKENUM 4}
  {$WARN 3031 off : Values in enumeration types have to be ascending}
{$ELSE}
  {$MinEnumSize 4}
  {$Z4}
{$ENDIF}

interface
uses
  {$IfDef UNIX}
  BaseUnix
  {$Else}
  Windows
  {$EndIf};

{$I Generated/zydis_enums.inc}

{
  Defines the `TZyanMemoryPageProtection` enum.
}
type
  TZyanMemoryPageProtection = (
    {$IFDEF MSWINDOWS}
    ZYAN_PAGE_READONLY = PAGE_READONLY,
    ZYAN_PAGE_READWRITE = PAGE_READWRITE,
    ZYAN_PAGE_EXECUTE = PAGE_EXECUTE,
    ZYAN_PAGE_EXECUTE_READ = PAGE_EXECUTE_READ,
    ZYAN_PAGE_EXECUTE_READWRITE = PAGE_EXECUTE_READWRITE
    {$ENDIF}
    {$IFDEF UNIX}
    ZYAN_PAGE_READONLY = PROT_READ,
    ZYAN_PAGE_READWRITE = PROT_READ or PROT_WRITE,
    ZYAN_PAGE_EXECUTE = PROT_EXEC,
    ZYAN_PAGE_EXECUTE_READ = PROT_EXEC or PROT_READ,
    ZYAN_PAGE_EXECUTE_READWRITE = PROT_EXEC or PROT_READ or PROT_WRITE
    {$ENDIF}
  );

implementation
end.
