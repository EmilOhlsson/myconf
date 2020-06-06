Enable touch tapping
```
xinput list
```
And find touchpad
```
xinput list-props <device id>
```
Check `Tapping Enabled`
```
xinput set-prop <device id> <prop id> 1
```

Set display order
```
xrandr --output DP-1 --left-of DVI-D-1
```
