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
