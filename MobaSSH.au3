; #INDEX# ======================================================================
; Title .........: MobaSSH.au3
; Version  ......: 1.1
; Language ......: English
; Author(s) .....: jalbersdorfer
; Link ..........: https://github.com/jalbersdorfer/MobaSSH
; Description ...: Start (multiple) SSH Sessions in MobaXterm from Commandline and optionally run an initial command.
;                  IP-Adresses can be provided using Commandline or Clipboard (one each line, separated by @CRLF).
;                  An initial Command can be supplied as behind the IP-Adressen in Commandline.
; Remarks .......: PREQUESITS:
;                  + MobaXterm on PATH
;                  + a .ssh/mobassh.key File holding the private key to use for SSH login.
;                  + a .ssh/mobassh.user File holding the username to use for SSH login.
;                  TODO:
;                  + Add Option to provide a Password instead of Key-File.
;                  * More documentation in the source.
;                  CHANGELOG:
;                  Version 1.1:
;                  + Added option to provide IP-Adresses from Commandline instead of Clipboard.
;                  * Changed from hard coded default initial Command to no initial Command by default.
;                  * Initial public release.
; ==============================================================================

#pragma compile(Out, MobaSSH.exe)
; Uncomment to use the following icon. Make sure the file path is correct and matches the installation of your AutoIt install path.
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(FileDescription, MobaSSH - Start (multiple) SSH Sessions in MobaXterm from Commandline and optionally run an initial command)
#pragma compile(ProductName, MobaSSH)
#pragma compile(ProductVersion, 1.1)
#pragma compile(FileVersion, 1.1.0)
#pragma compile(LegalCopyright, jalbersdorfer 2019)
#pragma compile(CompanyName, 'jalbersdorfer')

#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <Array.au3>

If @error <> 0 Then Exit

Const $IPv4 = "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"

Local $cmd = Default
Local $eoips = False
Local $ipstring = Default
For $i = 1 To $CmdLine[0]
	Local $arg = $CmdLine[$i]
	If Not $eoips And StringRegExp($arg, $IPv4) Then
		If $ipstring = Default Then
			$ipstring = $arg
		Else
			$ipstring = $ipstring & @CRLF & $arg
		EndIf
	Else
		$eoips = True
		If $cmd = Default Then
			$cmd = $arg
		Else
			$cmd = $cmd & " " & $arg
		EndIf
	EndIf
Next

If $ipstring = Default Then
	$ipstring = ClipGet()
EndIf

Local $ips = StringSplit ( $ipstring, @CRLF, $STR_ENTIRESPLIT + $STR_NOCOUNT )
For $ip In $ips
	$ip = StringStripWS($ip, $STR_STRIPALL)
	ShellExecute("MobaXterm.exe", "-newtab ""ssh -i .ssh/mobassh.key $(cat .ssh/mobassh.user)@" & StringStripWS($ip, $STR_STRIPALL) & """")
	WinActivate("MobaXterm")
	WinWaitActive("MobaXterm", "", 3)
	Local $win = WinWaitActive($ip, "", 3)
	If $win <> 0 Then
		Local $to = 0
		While StringInStr(WinGetTitle($win), $ip) > 0
			$to = $to + 250
			If $to > 3000 Then ExitLoop
			Sleep(250)
		WEnd
	EndIf
	If $cmd <> Default Then
		Sleep(250)
		Send($cmd & "{ENTER}")
	EndIf
	Sleep(1000)
Next
