@ECHO OFF

REM SETLOCAL ENABLEDELAYEDEXPANSION

REM Set Variables
SET _filename=%~f1
SET _extension=%~x1
SET _lfdir=%LOCALAPPDATA%\lf

REM Grab the latest release of the file utility from here:
REM   https://github.com/julian-r/file-windows
REM and extract the three files to the _lfdir directory.
SET _magicfile=%_lfdir%\magic.mgc
SET _file=%_lfdir%\file.exe

REM Grab the latest release of the ansiart2utf8 utility from here:
REM   https://github.com/BourgeoisBear/ansiart2utf8
REM and extract the three files to the _lfdir\ansi directory.
SET _ansiart2utf8=%_lfdir%\ansiart2utf8.exe

SET _ansicat=_lfdir%\Ansi-Cat.exe

REM Collect the Mime Type of the file into a variable
FOR /f "tokens=3 delims=:" %%A IN ('call "%_file%" -m "%_magicfile%" --mime-type "%_filename%"') DO (
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
IF "%type%"=="video" mpv.com "%_filename%" & GOTO :END
IF "%type%"=="audio" mpv.com --no-video "%_filename%" & GOTO :END
IF "%_extension%"==".m3u" mpv.com --no-video "%_filename%" & GOTO :END

REM Image File(s) identification
REM IF "%type%"=="image" exiftool.exe "%_filename%" & GOTO :EOF
IF "%_extension%"==".ans" "%_ansiart2utf8%" "%_filename%" & PAUSE & GOTO :END
IF "%_extension%"==".ANS" "%_ansiart2utf8%" "%_filename%" & PAUSE & GOTO :END
IF "%_extension%"==".asc" "%_ansiart2utf8%" "%_filename%" & PAUSE & GOTO :END
IF "%_extension%"==".ASC" "%_ansiart2utf8%" "%_filename%" & PAUSE & GOTO :END

REM Document File(s) identification
REM Grab the latest release of the glow app from here:
REM   https://www.mankier.com/1/mutool
REM OR
REM   winget install ArtifexSoftware.mutool
REM and extract chroma.exe, and place somewhere in your %PATH%
REM IF "%subtype%"=="pdf" mutool draw -F txt "%_filename%" 1 & GOTO :END

REM Text File(s) identification
IF "%_extension%"==".diz" "%_ansiart2utf8%" "%_filename%" & GOTO :EOF

REM Grab the latest release of the glow app from here:
REM   https://github.com/charmbracelet/glow
REM OR
REM   scoop install glow
REM and extract glow.exe, and place somewhere in your %PATH%
IF "%_extension%"==".md" glow -s dark "%_filename%" & GOTO :END

REM Grab the latest release of the chroma app from here:
REM   https://github.com/alecthomas/chroma
REM and extract chroma.exe, and place somewhere in your %PATH%
REM IF "%subtype%"=="x-wine-extension-ini" chroma "%_filename%" | less -R & GOTO :EOF

REM IF "%subtype%"=="json" chroma "%_filename%" | less -R & GOTO :EOF
REM IF "%type%"=="text" less -R chroma "%_filename%" | less -R & GOTO :EOF
REM IF "%type%"=="text" chroma "%_filename%" | less -R & GOTO :EOF

REM Archive File(s) identification
REM IF "%subtype%"=="zip" 7z l "%_filename%" | less -R & GOTO :EOF
REM IF "%subtype%"=="zip" 7z l "%_filename%" | less -R & GOTO :EOF
REM IF "%subtype%"=="x-tar" 7z l "%_filename%" | less -R & GOTO :EOF
REM IF "%subtype%"=="gzip" 7z l "%_filename%" | less -R & GOTO :EOF
REM IF "%subtype%"=="octet-stream" 7z l "%_filename%" | less -R || GOTO :EOF
REM IF "%subtype%"=="rar" "%ProgramFiles%\WinRAR\rar.exe" lb "%_filename%" | less -R & GOTO :EOF

REM Catch-all
REM ECHO %type%/%subtype% & EXIT /B 1
START " " "%_filename%"

:END
