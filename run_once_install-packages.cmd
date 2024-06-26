@ECHO OFF

WHERE /Q "winget"
IF ERRORLEVEL 0 (
    START "Install Package - age" /WAIT "sudo" "winget install GoLang.Go"
    START "Install Package - bat" /WAIT "sudo" "winget install sharkdp.bat"
    START "Install Package - less" /WAIT "sudo" "winget install jftuga.less"
    START "Install Package - lf" /WAIT "sudo" "winget install gokcehan.lf"
    START "Install Package - eza" /WAIT "sudo" "winget install eza-community.eza"
    START "Install Package - glow" /WAIT "sudo" "winget install charmbracelet.glow"
    REM START "Install Package - age" /WAIT "sudo" "winget install FiloSottile.age"
)

WHERE /Q "scoop"
IF ERRORLEVEL 0 (
    START "Install Package - file" /WAIT "sudo" "scoop install file"
    START "Install Package - mpv" /WAIT "sudo" "scoop install mpv"
)

WHERE /Q "go"
IF ERRORLEVEL 0 (
    START "Install Package - ansiart2utf8" /WAIT "go" "install github.com/BourgeoisBear/ansiart2utf8/ansiart2utf8@latest"
    REM START "Install Package - fil" /WAIT "go" "install github.com/joeky888/fil@latest"
    REM START "Install Package - chroma" /WAIT "go" "install github.com/alecthomas/chroma@latest"
)