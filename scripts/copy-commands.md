# Commands used

Drive letters change depending on which card is plugged in. Check the label first
(`Get-Volume`): the New 3DS XL card is labeled `3DS`, the 2DS card `2DS`.

## Back up a card to the SSD
```powershell
robocopy K:\ "E:\3DS XL SD Backup" /E /COPY:DAT /DCOPY:T /R:2 /W:2 /XD "System Volume Information" /MT:8 /NP /NFL /NDL /LOG:"E:\3DS XL SD Backup.log"
```

## Copy GodMode9 CIA dumps off a card
```powershell
robocopy K:\gm9\out "E:\3DS XL CIA Dumps" /E /COPY:DAT /R:2 /W:2 /MT:8 /NP /NFL /NDL /LOG:"E:\3DS XL CIA Dumps.log"
```

## Format a card (Terminal as Admin, erases the card)
```
format K: /FS:FAT32 /Q /V:3DS /A:32K
```
The "volume exceeds 32 GB" warning is expected; the 3DS works with large FAT32 cards.

## Restore a backup onto a card
```powershell
robocopy "E:\3DS XL SD Backup" K:\ /E /COPY:DAT /DCOPY:T /R:2 /W:2 /MT:8 /NP /NFL /NDL /LOG:"E:\3DS XL SD Restore.log"
```

## Copy the dumps onto the 2DS card
```powershell
robocopy "E:\3DS XL CIA Dumps" "K:\cias\XL dumps" /E /COPY:DAT /R:2 /W:2 /MT:8 /NP /NFL /NDL
```

## Verify a copy
```powershell
.\scripts\verify.ps1 -Src "E:\3DS XL SD Backup" -Dst "K:\" -Report "E:\verify.txt"
```

## Robocopy exit codes
0-7 = success (1 = files copied, 2 = extra files at destination, 3 = both).
8 or higher = something failed; check the log.
