@ECHO OFF

GSUDO status IsElevated --no-output && GOTO :IsElevated

ECHO Admin rights needed. Elevating using gsudo.
GSUDO "%~f0" %*
IF ERRORLEVEL 999 (
    ECHO Failed to elevate!
)
EXIT /b %ERRORLEVEL%

:winget
ECHO.
ECHO Installing Package - %~1
START "Install Package - %~1" /I /WAIT /B winget.exe install %~1
GOTO :IsElevated

:scoop
ECHO.
ECHO Installing Package - %~1
START "Install Package - %~1" /I /WAIT /B scoop install %~1
GOTO :IsElevated

:go
ECHO.
ECHO Installing Package - %~1
START "Install Package - %~1" /I /WAIT /B go.exe install %~1
GOTO :IsElevated

:IsElevated

WHERE /Q "winget"
IF ERRORLEVEL 0 (
    WHERE /Q "starship"
    IF ERRORLEVEL 1 (
        CALL :winget "Starship.Starship"
    )

    WHERE /Q "go"
    IF ERRORLEVEL 1 (
        CALL :winget "GoLang.Go"
    )

    WHERE /Q "bat"
    IF ERRORLEVEL 1 (
        CALL :winget "sharkdp.bat"
    )

    WHERE /Q "less"
    IF ERRORLEVEL 1 (
        CALL :winget "jftuga.less"
    )

    WHERE /Q "lf"
    IF ERRORLEVEL 1 (
        CALL :winget "gokcehan.lf"
    )

    WHERE /Q "eza"
    IF ERRORLEVEL 1 (
        CALL :winget "eza-community.eza"
    )

    WHERE /Q "glow"
    IF ERRORLEVEL 1 (
        CALL :winget "charmbracelet.glow"
    )

    WHERE /Q "mediainfo"
    IF ERRORLEVEL 1 (
        CALL :winget "MediaArea.MediaInfo"
    )

    WHERE /Q "mutool"
    IF ERRORLEVEL 1 (
        CALL :winget "ArtifexSoftware.mutool"
    )

    WHERE /Q "fzf"
    IF ERRORLEVEL 1 (
        CALL :winget "junegunn.fzf"
    )

    WHERE /Q "age"
    IF ERRORLEVEL 1 (
        CALL :winget "FiloSottile.age"
    )
)

WHERE /Q "scoop"
IF ERRORLEVEL 0 (
    WHERE /Q "file"
    IF ERRORLEVEL 1 (
        CALL :scoop "file"
    )

    WHERE /Q "mpv"
    IF ERRORLEVEL 1 (
        CALL :scoop "mpv"
    )

    WHERE /Q "chroma"
    IF ERRORLEVEL 1 (
        CALL :scoop "chroma"
    )
)

WHERE /Q "go"
IF ERRORLEVEL 0 (
    WHERE /Q "ansiart2utf8"
    IF ERRORLEVEL 1 (
        CALL :go "github.com/BourgeoisBear/ansiart2utf8/ansiart2utf8@latest"
    )
)