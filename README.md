# zenoclashfov - Zeno Clash FOV changing powershell script

Put Fix-WeaponZenoFOV.ps1 in your steam game folder. (ala C:\Program Files (x86)\Steam\steamapps\common\ZenoClash)

Load a powershell window there and run it. Might need admin or if not admin first run:
```
Set-ExecutionPolicy RemoteSigned
```
(Due to a Microsoft security policy.)

Run:
```
./Fix-WeaponZenoFOV.ps1
```

It'll ask what FOV you want for normal, and zoom. Or press enter to use the defaults of 100 FOV normal, and 90 for "zoom".

```
PS C:\Program Files (x86)\Steam\steamapps\common\zenoclash> .\Fix-WeaponZenoFOV.ps1
Default FOV     : 90
Default zoom_FOV: 80

Enter desired FOV (or press Enter for 90):
Enter desired zoom_FOV (or press Enter for 80):
```
