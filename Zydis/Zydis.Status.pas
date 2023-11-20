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

unit Zydis.Status;

{$IFDEF FPC}
  {$mode Delphi}
  {$PackRecords C}
{$ENDIF}

interface

uses
  Zydis.types;


const { Module IDs }
  // The zycore generic module id.
  ZYAN_MODULE_ZYCORE      = $001;
  // The zycore arg-parse submodule id.
  ZYAN_MODULE_ARGPARSE    = $003;
  // The base module id for user-defined status codes.
  ZYAN_MODULE_USER        = $3FF;


  function ZYAN_MAKE_STATUS(error, module, code : ZyanU32): ZyanStatus;
  function ZYAN_SUCCESS(status : ZyanStatus): Boolean;
  function ZYAN_FAILED(status: ZyanStatus): Boolean;
  function ZYAN_STATUS_MODULE(Status : ZyanStatus): ZyanStatus;
  function ZYAN_STATUS_CODE(Status : ZyanStatus): ZyanStatus;

implementation

{
 * Defines a zyan status code.
 *
 * @param   error   `1`, if the status code signals an error or `0`, if not.
 * @param   module  The module id.
 * @param   code    The actual code.
 *
 * @return  The zyan status code.
}
function ZYAN_MAKE_STATUS(error, module, code : ZyanU32): ZyanStatus;
begin
  Result := ZyanStatus((((error) and 01) shl 31) or (((module) and $7FF) shl 20) or
  ((code) and $FFFFF));
end;

{
 * Checks if a zyan operation was successful.
 *
 * @param   status  The zyan status-code to check.
 *
 * @return  `ZYAN_TRUE`, if the operation succeeded or `ZYAN_FALSE`, if not.
 *
}
function ZYAN_SUCCESS(status : ZyanStatus): Boolean;
begin
  Result := (status and $80000000) = 0;
end;

{
  Checks if a Zyan operation failed.

  @param status The Zyan status code to check.

  @return True if the operation failed, False if not.
}
function ZYAN_FAILED(status: ZyanStatus): Boolean;
begin
  Result := (status and $80000000) <> 0;
end;


{
* Returns the module id of a zyan status-code.
*
* @param   status  The zyan status-code.
*
* @return  The module id of the zyan status-code.
}
function ZYAN_STATUS_MODULE(Status : ZyanStatus): ZyanStatus;
begin
  Result := (status shr 20) and $7FF;
end;

{
* Returns the code of a zyan status-code.
*
* @param   status  The zyan status-code.
*
* @return  The code of the zyan status-code.
}
function ZYAN_STATUS_CODE(Status : ZyanStatus): ZyanStatus;
begin
  Result := status and $FFFFF;
end;

end.

