text="to login:
username: io

to use the pc:
- the first time you do anything it will take longer (old pc)
- command+D opens a launch dialogue (type e.g. firefox)
- command+<0-9> opens a separate workspace
- command+shift+<0-9> moves current window to workspace <0-9>
- command+shift+Q closes a window
- command+enter opens a terminal"

magick -size 3840x2160 xc:#120012 -fill white -font "DejaVu-Sans-Mono" -pointsize 32 -gravity center -annotate +0+0 "$text" background.png
