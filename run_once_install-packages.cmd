@ECHO OFF

WHERE /Q "winget"
IF ERRORLEVEL 0 (
    WHERE /Q "starship"
    IF ERRORLEVEL 1 (
        START "Install Package - Starship Prompt" /I /WAIT /B "sudo" "winget install Starship.Starship"
    )

    WHERE /Q "go"
    IF ERRORLEVEL 1 (
        START "Install Package - GoLang" /I /WAIT /B "sudo" "winget install GoLang.Go"
    )

    WHERE /Q "bat"
    IF ERRORLEVEL 1 (
        START "Install Package - bat" /I /WAIT /B "sudo" "winget install sharkdp.bat"
    )

    WHERE /Q "less"
    IF ERRORLEVEL 1 (
        START "Install Package - less" /I /WAIT /B "sudo" "winget install jftuga.less"
    )

    WHERE /Q "lf"
    IF ERRORLEVEL 1 (
        START "Install Package - lf" /I /WAIT /B "sudo" "winget install gokcehan.lf"
    )

    WHERE /Q "eza"
    IF ERRORLEVEL 1 (
        START "Install Package - eza" /I /WAIT /B "sudo" "winget install eza-community.eza"
    )

    WHERE /Q "glow"
    IF ERRORLEVEL 1 (
        START "Install Package - glow" /I /WAIT /B "sudo" "winget install charmbracelet.glow"
    )

    WHERE /Q "mediainfo"
    IF ERRORLEVEL 1 (
        START "Install Package - mediainfo" /I /WAIT /B "sudo" "winget install MediaArea.MediaInfo"
    )

    WHERE /Q "mutool"
    IF ERRORLEVEL 1 (
        START "Install Package - mutool" /I /WAIT /B "sudo" "winget install ArtifexSoftware.mutool"
    )

    WHERE /Q "age"
    IF ERRORLEVEL 1 (
        START "Install Package - age" /I /WAIT /B "sudo" "winget install FiloSottile.age"
    )
)

WHERE /Q "scoop"
IF ERRORLEVEL 0 (
    WHERE /Q "file"
    IF ERRORLEVEL 1 (
        START "Install Package - file" /I /WAIT /B "sudo" "scoop install file"
    )

    WHERE /Q "mpv"
    IF ERRORLEVEL 1 (
        START "Install Package - mpv" /I /WAIT /B "sudo" "scoop install mpv"
    )

    WHERE /Q "chroma"
    IF ERRORLEVEL 1 (
        START "Install Package - chroma" /I /WAIT /B "sudo" "scoop install chroma"
    )
)

WHERE /Q "go"
IF ERRORLEVEL 0 (
    WHERE /Q "ansiart2utf8"
    IF ERRORLEVEL 1 (
        START "Install Package - ansiart2utf8" /I /WAIT /B "sudo" "go install github.com/BourgeoisBear/ansiart2utf8/ansiart2utf8@latest"
    )

    REM WHERE /Q "fli"
    REM IF ERRORLEVEL 1 (
    REM     START "Install Package - fil" /I /WAIT /B "sudo" "go install github.com/joeky888/fil@latest"
    REM )
)