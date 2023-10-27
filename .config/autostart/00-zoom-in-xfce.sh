# 00-scriptname

# Applying the main xrandr suited changes (scaling at x1.15)

DISPLAY=$(xrandr | grep connected | grep -v disconnected | awk '{print $1}')

if [ "$DISPLAY" = "DP-0" ]; then
  # reference:
  # https://unix.stackexchange.com/questions/596887/how-to-scale-the-resolution-display-of-the-desktop-and-or-applications
  xrandr --output "$DISPLAY" --scale 0.8x0.8

fi
