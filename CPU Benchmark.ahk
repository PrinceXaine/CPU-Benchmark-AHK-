;///----APPLICATION-----///;
#NoEnv
#SingleInstance ignore
Process, Priority,, High
SendMode Input
random, Generate, 100000000,
FileCreateDir %A_ScriptDir%\%Generate%
SetWorkingDir %A_ScriptDir%\%Generate%
SetBatchLines, -1
RunCount = 1
FinalResult = 0

;///----GET PROCESSOR THREADS, NAME, SPEED-----///;
EnvGet, ProcessorCount, NUMBER_OF_PROCESSORS
WMI := ComObjGet("winmgmts:\\.\root\cimv2")
colItems := WMI.ExecQuery("Select * from Win32_Processor")
For item in colItems
{
    if (item.Name <> "")
        ProcessorName := item.Name
    else
        ProcessorName := "Processor name not available"

    if (item.MaxClockSpeed <> "")
        ProcessorSpeed := item.MaxClockSpeed . " MHz"
    else
        ProcessorSpeed := "Processor speed not available"
}

;///----CREATE GUI-----///;
gui, color, 0
gui, font, cFFFFFF
gui, font, bold
Gui, Add, Text,, %ProcessorName%`n`nBase Clock: %ProcessorSpeed%
Gui, Add, Text,, Single-Thread Score
Gui, Add, Edit, vST w100 readonly,
Gui, Add, Text,, Multi-Thread Score
Gui, Add, Edit, vMT w100 readonly,
Gui, Add, Text,, CPU Ratio
Gui, Add, Edit, vRatio w100 readonly,
Gui, Add, Text,, # of Threads to use:
Gui, Add, Edit, vNoProcessors w100 Readonly,
Gui, Add, updown,range1-%ProcessorCount%
Guicontrol,, NoProcessors, %ProcessorCount%
Gui, Add, Button, vStart w100 gStart, Start Benchmark
Gui, Add, Button, vStress w100 gStress, Stress Test
Gui, Add, button, xm ys+266 vStopStress w100 gStopStress, Stop
gui, Add, Edit, x0 y0 w0 h0 vTrackOpened,
guicontrol, hide, TrackOpened
guicontrol, hide, StopStress
Gui, Show,, CPU Benchmark
Gui +ToolWindow
Return

;///----BENCHMARK-----///;
Start:
    ;--Alert User of restricted mouse movement (once per session)--;
    if (runonce != 1)
    {
    msgbox Mouse movement is blocked until the test completes. At times the program may appear unresponsive.`n`nPress "ESC" to free your mouse movement and exit the benchmark.
    runonce = 1
    }
   BlockInput, mousemove
    ;-----------------------;

    ;--Create Progress Bar--;   
    RunCount++ ;//Allows multiple Progressbars to be made. Gui 2: onwards. If need add second GUI, either give it a name or increase the RunCount Start at top.
    Gui %RunCount%:Add, Text, vBenchText, Running Single-Thread Test...
    Gui %RunCount%:Add, Progress, w300 cgreen vBenchbar range0-20
    Gui %RunCount%:Show,, Benchmarking...
    Gui %RunCount%:-SysMenu
    ;-----------------------;

    ;----Benchmark Setup----;   
    BenchStart = 1
    guicontrol,, ST,
    guicontrol,, MT,
    Guicontrol,, Ratio, 
    Count = 0
    guicontrol, disable, start
    ;-----------------------;
    

    ;---SingleThread Test---;
    SetTimer, BenchTimer, 1000 ;ProgressBar Timer
    SetTimer, SingleThreadTimer, 10000 ;Sets the 10 second Timer for Single-Thread Testing.
    While(BenchStart != 0)
        {
        Factorial(n) {
            result := 1
            Loop, %n%
            {
                result *= A_Index
            }
            return result
        }
        Loop 100
        {
            N := 9001 ; Over 9000
            BigFactorial := Factorial(N)
        }
        Count++
        }        
    SetTimer, SingleThreadTimer, off
    ;-----------------------;

    ;Go to Multi-Thread test;
    goto MTTest
    ;-----------------------;
Return

;----Multi-Thread Testing----;
MTTest:
gui, submit, nohide
    if (NoProcessors != 1) ;--Check if Threads to Use equals Single-Thread Count--;
    {
    ProgressbarStatus = 1 ;pauses the progress bar

    ;-----Create Workers-----;
    Loop %NoProcessors%
        {
            CPUWorkers := "#NoEnv`n#NoTrayIcon`n#SingleInstance force`nSendMode Input`nSetWorkingDir %A_ScriptDir%`nSetBatchLines, -1`n`nLoop`n{`nsleep 50`nControlGetText, ProcessorCount, Edit4, CPU Benchmark`nControlGetText, Tracked, Edit5, CPU Benchmark`nIf (Tracked != ProcessorCount)`n{`n;wait for something to happen.`n}`nelse`n{`nbreak`n}`n}`n`nBenchStart = 1`nSetTimer, MultiThreadTimer, 10000`n`nLoop`n{`nFactorial(n)`n{`nresult := 1`nLoop, %n%`n{`nresult *= A_Index`n}`nreturn result`n}`nLoop 100`n{`nN := 9001`nBigFactorial := Factorial(N)`n}`nCount++`n}`nreturn`n`nMultiThreadTimer:`nScore := round(Count, 2)`nFileAppend, %score%, %A_ScriptDir%\Core" . A_Index . ".txt`nFileDelete, %A_ScriptDir%\Core" . A_Index . ".ahk`nexit"
            FileAppend, %CPUWorkers%, %A_WorkingDir%\Core%A_Index%.ahk
            Guicontrol, %RunCount%:, BenchText, Creating Workers: %A_Index%/%NoProcessors%
        }
    ;-----------------------;


    ;------Run Workers------;
    Loop %NoProcessors%
        {
            run %A_WorkingDir%\Core%A_Index%.ahk,,, PID
            Process, Priority, %PID%, H
            Guicontrol, %RunCount%:, BenchText, Starting Workers: %A_Index%/%NoProcessors%
            Guicontrol, 1:, TrackOpened, %A_Index%
        }
    ;-----------------------;  

    ;--Control Progress Bar-;
    ProgressbarStatus = 0 ;resumes the progress bar
    Guicontrol, %RunCount%:, BenchText, Running Multi-Thread Test...
    sleep 11000
    Loop %NoProcessors%
    {
    FileRead, Result, %A_WorkingDir%\Core%A_Index%.txt
    FinalResult := round(Result + FinalResult, 2)
    }
    }
    else ;--Check if Threads to Use equals Single-Thread Count--;
    {
        gui, submit, nohide
        Guicontrol, %RunCount%:, BenchText, Multi-Thread test disabled.
        sleep 1000
        Guicontrol, 1:, MT, %ST%
    }
    ;-----------------------;
;-----------------------;

;///----INPUT RESULTS-----///;
guicontrol,, MT, %FinalResult%

;///----SUBMIT ALL GUI-----///;
Gui, submit, nohide
Gui %RunCount%:Submit

;///----GET RATIO-----///;
Ratio := round(MT/ST, 2)
guicontrol,, Ratio, %Ratio%

;///----RESET PROGRAM-----///;
guicontrol, enable, start
SetTimer, BenchTimer, off
BlockInput, mousemoveoff

;///----RESET TEMP VAR-----///;
ProgressBarProgress = 0
ResumeTest = 0
FinalResult = 0

;///----SAVE RESULTS-----///;
gui, submit, nohide
BenchTime := A_Now
Year := SubStr(BenchTime, 1, 4)
Month := SubStr(BenchTime, 5, 2)
Day := SubStr(BenchTime, 7, 2)
Hour := SubStr(BenchTime, 9, 2)
Minute := SubStr(BenchTime, 11, 2)
Second := SubStr(BenchTime, 13, 2)
FileAppend, //===%Year%-%Month%-%Day% %Hour%:%Minute%:%Second%===//`n, %A_ScriptDir%\CPUBenchmarkResults.txt
FileAppend, Threads Tested: %NoProcessors%`n, %A_ScriptDir%\CPUBenchmarkResults.txt
FileAppend, Single-Thread: %ST%`n, %A_ScriptDir%\CPUBenchmarkResults.txt
FileAppend, Multi-Thread: %MT%`n, %A_ScriptDir%\CPUBenchmarkResults.txt
FileAppend, Ratio: %Ratio%`n`n, %A_ScriptDir%\CPUBenchmarkResults.txt
loop %NoProcessors%
    {
        FileDelete, %A_WorkingDir%\Core%A_Index%.txt
    }
msgbox Results saved in %A_ScriptDir%\CPUBenchmarkResults.txt
Return

;///-----STRESS TEST------///;
Stress:
gui, submit, nohide
Guicontrol, hide, Stress
Guicontrol, show, StopStress
 ;-----Create Workers-----;
    Loop %NoProcessors%
        {
            CPUWorkers := "#NoEnv`n#NoTrayIcon`n#SingleInstance force`nSendMode Input`nSetWorkingDir %A_ScriptDir%`nSetBatchLines, -1`n`nStartStress:`nLoop`n{`nsleep 50`nControlGetText, ProcessorCount, Edit4, CPU Benchmark`nControlGetText, Tracked, Edit5, CPU Benchmark`nIf (Tracked != ProcessorCount)`n{`n;wait for something to happen.`n}`nelse`n{`nbreak`n}`n}`n`nBenchStart = 1`nSetTimer, MultiThreadTimer, 10000`n`nLoop`n{`nFactorial(n)`n{`nresult := 1`nLoop, %n%`n{`nresult *= A_Index`n}`nreturn result`n}`nLoop 100`n{`nN := 9001`nBigFactorial := Factorial(N)`n}`nCount++`n}`nreturn`n`nMultiThreadTimer:`nScore := round(Count, 2)`nFileAppend, %score%, %A_ScriptDir%\Core" . A_Index . ".txt`nFileDelete, %A_ScriptDir%\Core" . A_Index . ".ahk`ngoto startstress"
            FileAppend, %CPUWorkers%, %A_WorkingDir%\Core%A_Index%.ahk
            Guicontrol, %RunCount%:, BenchText, Creating Workers: %A_Index%/%NoProcessors%
        }
    ;-----------------------;


    ;------Run Workers------;
    Loop %NoProcessors%
        {
            run %A_WorkingDir%\Core%A_Index%.ahk,,, PID
            Process, Priority, %PID%, H
            Guicontrol, %RunCount%:, BenchText, Starting Workers: %A_Index%/%NoProcessors%
            Guicontrol, 1:, TrackOpened, %A_Index%
            PID%A_Index% := PID
        }
return

StopStress:
gui, submit, nohide
    guicontrol, show, Stress
    guicontrol, hide, StopStress
    critical
    Loop %NoProcessors%
    {
    CloseProcess := % PID%A_Index%
    process, close, %CloseProcess%
    }
    critical off
    loop %NoProcessors%
    {
        FileDelete, %A_WorkingDir%\Core%A_Index%.ahk
        FileDelete, %A_WorkingDir%\Core%A_Index%.txt
    }
return

;///----TIMERS-----///;
BenchTimer:
    If (ProgressbarStatus != 1)
        {
        Guicontrol,%RunCount%:, Benchbar, +1
        }
return

SingleThreadTimer:
Score := round(Count, 2)
Guicontrol,, ST, %Score%
BenchStart = 0
return

;///----ESCAPE SCRIPT-----///;
Guiclose:
FileRemoveDir, %A_ScriptDir%\%Generate%, 1
exitapp

Esc::
BlockInput, mousemoveoff
FileRemoveDir, %A_ScriptDir%\%Generate%, 1
exitapp
