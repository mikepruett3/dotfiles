@ECHO OFF

GSUDO status IsElevated --no-output && GOTO :IsElevated

ECHO Admin rights needed. Elevating using gsudo.
GSUDO "%~f0" %*
IF ERRORLEVEL 999 (
    ECHO Failed to elevate!
)
EXIT /B %ERRORLEVEL%

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
ECHO Installing Go Package - %~1
START "Install Go Package - %~1" /I /WAIT /B go.exe install %~1
GOTO :IsElevated

:npm
ECHO.
ECHO Installing NPM Package - %~1
START "Install NPM Package - %~1" /I /WAIT /B npm install -g %~1
GOTO :IsElevated

:IsElevated

WHERE /Q "winget"
IF ERRORLEVEL 0 (
    WHERE /Q "age"
    IF ERRORLEVEL 1 (
        CALL :winget "FiloSottile.age"
    )

    WHERE /Q "bat"
    IF ERRORLEVEL 1 (
        CALL :winget "sharkdp.bat"
    )

    WHERE /Q "btop"
    IF ERRORLEVEL 1 (
        CALL :winget "aristocratos.btop4win"
    )

    WHERE /Q "curl"
    IF ERRORLEVEL 1 (
        CALL :winget "cURL.cURL"
    )

    WHERE /Q "dos2unix"
    IF ERRORLEVEL 1 (
        CALL :winget "waterlan.dos2unix"
    )

    WHERE /Q "eza"
    IF ERRORLEVEL 1 (
        CALL :winget "eza-community.eza"
    )

    WHERE /Q "fzf"
    IF ERRORLEVEL 1 (
        CALL :winget "junegunn.fzf"
    )

    WHERE /Q "git"
    IF ERRORLEVEL 1 (
        CALL :winget "Git.Git"
    )

    WHERE /Q "glow"
    IF ERRORLEVEL 1 (
        CALL :winget "charmbracelet.glow"
    )

    WHERE /Q "go"
    IF ERRORLEVEL 1 (
        CALL :winget "GoLang.Go"
    )

    WHERE /Q "gpg"
    IF ERRORLEVEL 1 (
        CALL :winget "GnuPG.GnuPG"
    )

    WHERE /Q "less"
    IF ERRORLEVEL 1 (
        CALL :winget "jftuga.less"
    )

    WHERE /Q "lf"
    IF ERRORLEVEL 1 (
        CALL :winget "gokcehan.lf"
    )

    WHERE /Q "mediainfo"
    IF ERRORLEVEL 1 (
        CALL :winget "MediaArea.MediaInfo"
    )

    WHERE /Q "mc"
    IF ERRORLEVEL 1 (
        CALL :winget "MinIO.Client"
    )

    WHERE /Q "mutool"
    IF ERRORLEVEL 1 (
        CALL :winget "ArtifexSoftware.mutool"
    )

    WHERE /Q "nano"
    IF ERRORLEVEL 1 (
        CALL :winget "GNU.Nano"
    )

    WHERE /Q "npm"
    IF ERRORLEVEL 1 (
        CALL :winget "OpenJS.NodeJS.LTS"
    )

    WHERE /Q "nvim"
    IF ERRORLEVEL 1 (
        CALL :winget "Neovim.Neovim"
        CALL :npm "neovim"
    )

    WHERE /Q "rg"
    IF ERRORLEVEL 1 (
        CALL :winget "BurntSushi.ripgrep.MSVC"
    )

    WHERE /Q "starship"
    IF ERRORLEVEL 1 (
        CALL :winget "Starship.Starship"
    )
)

WHERE /Q "scoop"
IF ERRORLEVEL 0 (
    WHERE /Q "file"
    IF ERRORLEVEL 1 (
        CALL :scoop "file"
    )

    REM WHERE /Q "mpv"
    REM IF ERRORLEVEL 1 (
    REM     CALL :scoop "mpv"
    REM )

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

    WHERE /Q "ascii-image-converter"
    IF ERRORLEVEL 1 (
        CALL :go "github.com/TheZoraiz/ascii-image-converter@latest"
    )

    WHERE /Q "go-launcher"
    IF ERRORLEVEL 1 (
        CALL :go "github.com/mikepruett3/go-launcher@latest"
    )

    WHERE /Q "imgconv"
    IF ERRORLEVEL 1 (
        CALL :go "github.com/mikepruett3/imgconv@latest"
    )
)

IF NOT EXIST .\Images\ MKDIR .\Images\
IF NOT EXIST .\Images\wallpapers\ mc cp --recursive minio .\Images\

REG IMPORT %USERPROFILE%\.bootstrap\windows\cmdhere.reg

RefreshEnv.cmd

EXIT /B
