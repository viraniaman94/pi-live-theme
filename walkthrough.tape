# walkthrough.tape — generates a GIF of the /theme live preview extension
# Usage: vhs walkthrough.tape
# Output: walkthrough.gif

Output walkthrough.gif

# Terminal appearance
Set FontSize 16
Set Width 1200
Set Height 640
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 50ms

# Launch pi
Type "pi"
Enter
Sleep 3s

# Open the theme switcher
Type "/theme"
Sleep 100ms
Enter
Sleep 1s

# Scroll down through themes — live preview kicks in on each
Down
Sleep 700ms
Down
Sleep 700ms
Down
Sleep 700ms
Down
Sleep 700ms

# Scroll back up
Up
Sleep 700ms
Up
Sleep 700ms

# Commit the highlighted theme
Enter
Sleep 1s

# Open again to show revert
Type "/theme"
Sleep 100ms
Enter
Sleep 1s

# Scroll to a different theme
Down
Sleep 700ms

# Escape to revert
Escape
Sleep 1s

# Quit
Ctrl+C
Sleep 500ms