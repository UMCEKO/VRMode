#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
if Not FileExist("LastDevice.ini")
{
    IniWrite, 1, LastDevice.ini, 1, Device
}
UrlDownloadWithBar(Url,Name)
{
WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
WebRequest.Open("HEAD", Url)
WebRequest.Send()
FinalSize := WebRequest.GetResponseHeader("Content-Length")
CurrSize=0
Run, powershell (New-Object Net.WebClient).DownloadFile('%Url%'`, '%A_ScriptDir%\%Name%'),, HIDE
Progress, On H70
__UpdateProgressBar:
While(FinalSize!=CurrSize){
    FileGetSize, CurrSize, %Name%
    Percentage := (CurrSize/FinalSize)*100
    ProgressFinalSize:=Round((FinalSize)/1024)
    ProgressCurrSize:=Round((CurrSize)/1024)
    Progress, %Percentage%,%Speed%KB/s %ProgressCurrSize%KB/%ProgressFinalSize%KB `n %Name% indiriliyor
    Sleep, 100
    FileGetSize, FutureSize, %Name%
    Speed:=Round(((FutureSize-CurrSize)*10)/1024)
}
Progress, Off
}
if Not FileExist("nircmd.exe"){
    UrlDownloadWithBar("http://www.nirsoft.net/utils/nircmd-x64.zip", "nircmd.zip")
    UrlDownloadWithBar("http://stahlworks.com/dev/unzip.exe", "unzip.exe")
    RunWait, cmd.exe /c unzip nircmd.zip, , HIDE
    FileDelete, nircmdc.exe
    FileDelete, unzip.exe
    FileDelete, nircmd.zip
    FileDelete, NirCmd.chm
}
IniRead, x, LastDevice.ini, 1, Device
if(x==1){
    Run, nircmd setdefaultsounddevice "VR Speaker" 1
    Run, nircmd setdefaultsounddevice "VR Mic" 1
    Run, nircmd setdefaultsounddevice "VR Speaker" 2
    Run, nircmd setdefaultsounddevice "VR Mic" 2
    IniWrite, 0, LastDevice.ini, 1, Device
    MsgBox, Vr Modu Aktif!
}
else if(x==0){
    Run, nircmd setdefaultsounddevice "Ana Mic" 1
    Run, nircmd setdefaultsounddevice "Ana Speaker" 1
    Run, nircmd setdefaultsounddevice "Ana Mic" 2
    Run, nircmd setdefaultsounddevice "Ana Speaker" 2
    IniWrite, 1, LastDevice.ini, 1, Device
    MsgBox, Vr Modu Devre Dışı!
}
else{
    MsgBox, Error!
    Exit
}