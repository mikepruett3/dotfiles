@ECHO OFF

REM SETLOCAL ENABLEDELAYEDEXPANSION

REM Set Variables
SET _filename=%~f1
SET _extension=%~x1
SET _lfdir=%LOCALAPPDATA%\lf
REM SET _magicfile=%_lfdir%\magic.mgc
REM SET _fileprg=file.exe

REM Collect the Mime Type of the file into a variable
REM FOR /f "tokens=3 delims=:" %%A IN ('call file -m "%_magicfile%" --mime-type "%_filename%"') DO (
FOR /f "tokens=3 delims=:" %%A IN ('call file --mime-type "%_filename%"') DO (
    SET "mimetype=%%A"
)

REM Derive Type and Subtype variables from Mime Type variable
FOR /f "tokens=1,2 delims=/" %%A IN ("%mimetype%") DO (
    SET "type=%%A"
    SET "subtype=%%B"
)

REM Remove spaces from Type variable
SET type=%type: =%

REM Media File(s) identification
IF "%type%"=="video" mediainfo "%_filename%" & GOTO :EOF
IF "%type%"=="audio" mediainfo "%_filename%" & GOTO :EOF

REM Image File(s) identification
IF "%type%"=="image" mediainfo "%_filename%" & GOTO :EOF

REM Document File(s) identification
IF "%subtype%"=="pdf" mutool draw -F txt "%_filename%" 1 & GOTO :EOF

REM Text File(s) identification
IF "%_extension%"==".md" glow -s dark "%_filename%" & GOTO :EOF
IF "%subtype%"=="x-wine-extension-ini" bat "%_filename%" & GOTO :EOF
IF "%subtype%"=="json" bat "%_filename%" & GOTO :EOF
REM IF "%type%"=="text" less -R chroma "%_filename%" | less -R & GOTO :EOF
IF "%type%"=="text" bat "%_filename%" & GOTO :EOF

REM Archive File(s) identification
REM IF "%subtype%"=="zip" 7z l "%_filename%" | less -R & GOTO :EOF
IF "%subtype%"=="zip" 7z l "%_filename%" & GOTO :EOF
IF "%subtype%"=="x-tar" 7z l "%_filename%" | less -R & GOTO :EOF
IF "%subtype%"=="gzip" 7z l "%_filename%" | less -R & GOTO :EOF
REM IF "%subtype%"=="octet-stream" 7z l "%_filename%" | less -R || GOTO :EOF
IF "%subtype%"=="rar" "%ProgramFiles%\WinRAR\rar.exe" lb "%_filename%" | less -R & GOTO :EOF

REM Catch-all
REM ECHO %type%/%subtype% & EXIT /B 1
ECHO %mimetype% & EXIT /B 1