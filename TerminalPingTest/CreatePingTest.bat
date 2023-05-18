@echo off

mkdir "C:\RITE\TerminalPingTest\PingLogs"

for /f "tokens=3" %%G in ('route print ^| findstr "\<0.0.0.0\>"') do set GATEWAY=%%G
for /f "usebackq tokens=1* delims==" %%a in ("config.txt") do (
    if /i "%%a"=="TERMINALIP" set TERMINALIP=%%b
)

for /f "tokens=1-4 delims=:/ " %%A in ("%DATE% %TIME%") do (
    set TIMESTAMP=%%D_%%B-%%C
)

for /f "tokens=1-2 delims=: " %%E in ('time /t') do (
    set TIMESTAMP=%TIMESTAMP%_%%E-%%F
)

set LOGFILE=C:\RITE\TerminalPingTest\PingLogs\pinglog_%TIMESTAMP%.txt

echo Starting ping test to %GATEWAY% at %TIME% on %DATE% >> %LOGFILE%
echo Starting ping test to %TERMINALIP% at %TIME% on %DATE% >> %LOGFILE%

:LOOP
ping %GATEWAY% -n 1 -w 1000 | find "TTL=" > nul
if errorlevel 1 (
  echo Ping to %GATEWAY% failed at %TIME% on %DATE% >> %LOGFILE%
)
ping -n 5 127.0.0.1 > nul

ping %TERMINALIP% -n 1 -w 1000 | find "TTL=" > nul
if errorlevel 1 (
  echo Ping to %TERMINALIP% failed at %TIME% on %DATE% >> %LOGFILE%
)
ping -n 5 127.0.0.1 > nul
goto LOOP
