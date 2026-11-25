# 3DS system sync: handoff

Goal: back up the modded New 3DS XL's SD card to an SSD, then get the same setup
(custom firmware, homebrew, games, saves) onto an original Nintendo 2DS, keeping
both consoles working.

Status as of 2026-11-25.

## Consoles

| | New 3DS XL | Original 2DS |
|---|---|---|
| CFW | boot9strap + Luma3DS | boot9strap + Luma3DS 13.4 (was already installed) |
| SD card | 256 GB, FAT32, label `3DS` | 128 GB, FAT32, label `2DS` |
| Firmware | - | 11.17 |
| Full NAND backup | **missing** | **missing** |

Note: the 2DS turned out to be modded already. Evidence: with the 2DS card
inserted, it booted straight into the Luma3DS configuration menu, and the
console-unique files Luma dumped belong to a different console than the XL.
The MSET9 steps that were started on the 2DS card were rolled back (hacked
ID1 removed, original ID1 folder restored, MSET9 files deleted). Do not run
MSET9 on it.

## Where things are on the PC

| Path | What | Size |
|---|---|---|
| `E:\3DS XL SD Backup` | Full copy of the XL's SD card (taken before the corruption, see below) | 60.45 GB, 3,839 files |
| `E:\3DS XL CIA Dumps` | GodMode9 CIA dumps of everything installed on the XL: 109 games, 8 updates, 5 DLC, plus `essential.exefs` | 49.23 GB, 123 files |
| `E:\2DS Essential Backup` | 2DS console-unique files dumped by Luma (otp, SecureInfo, HWCAL, etc.) | small |
| `E:\3DS SD Temp` | Pre-existing folder, not touched | 0.18 GB |

E: (128 GB SSD) has only ~1.8 GB free. Planned location for NAND backups:
`C:\3DS\NAND backups` (C: is an SSD with plenty of free space). D: (4 TB HDD)
also has ~2 TB free.

Console-unique files (`otp.bin`, `boot9.bin`, `SecureInfo_A`,
`essential.exefs`, NAND backups) must never be committed to this repo or
shared.

## What happened

1. XL card backed up to `E:\3DS XL SD Backup`: 3,839 files, 0 failures
   (`logs/01-xl-card-backup.log`).
2. On the XL, GodMode9 was used to dump all installed titles as CIAs into
   `gm9\out` (~12 hours, 123 files).
3. Afterwards the XL card's filesystem was found corrupted: folders under
   `Nintendo 3DS\<id0>\<id1>\` (`title`, `Nintendo DSiWare`, parts of
   `extdata`) were unreadable on Windows ("The file or directory is corrupted
   and unreadable"). Exact cause unknown. The CIA dumps themselves read fine.
4. Dumps copied to `E:\3DS XL CIA Dumps`: 123 files, 0 failures
   (`logs/02-xl-dumps-to-ssd.log`).
5. XL card formatted (FAT32, 32K clusters) and restored from the backup:
   3,839 files, 0 failures (`logs/03-xl-card-restore.log`). Every file then
   checksum-compared with the backup: 3,839 identical, 0 problems
   (`logs/04-xl-card-restore-verify.txt`).
6. 2DS card: homebrew from the XL card copied over (3ds, gm9, fbi, Themes,
   roms, _nds, vb, emulators). Two XL-only files removed from it
   (`gm9\out\essential.exefs`, `gm9\backups\<XL serial>_essential_00.exefs`,
   both identical to the copies in the XL backup).
7. All 123 dumps copied to `2DS card:\cias\XL dumps` and checksum-verified:
   123 identical, 0 problems. Card safely ejected.

## Open steps

1. **2DS: install the games.** FBI → SD → cias → XL dumps → select
   `<current directory>` at the top of the list → "Install all CIAs" (or
   "Install and delete all CIAs" if offered). Charger plugged in; it takes a
   while. Note any titles that fail; only those need re-dumping. Last status:
   the user could not find "Install and delete all CIAs"; waiting to hear
   which options the menu shows.
2. **2DS: make a NAND backup.** Hold Start on boot → GodMode9 →
   `[S:] SYSNAND VIRTUAL` → `nand.bin` → A → "Copy to 0:/gm9/out".
3. **XL: make a NAND backup.** Same steps on the XL.
4. **XL: fresh save backups.** Checkpoint → back up each game. Existing
   Checkpoint backups in `3ds\Checkpoint\saves` are mostly from 2023-09-21,
   a few from 2026-10-15, and about 20 games have none.
5. Copy both NAND backups and the new Checkpoint saves to the PC
   (`C:\3DS\NAND backups` for the NAND files).
6. Copy the Checkpoint saves onto the 2DS card and restore them with
   Checkpoint on the 2DS.
7. After everything is installed: delete `cias\XL dumps` from the 2DS card to
   free space (copies remain on E:).

## Notes

- The `Nintendo 3DS` folder is encrypted per console (via `movable.sed`), so
  it cannot be copied from one console to another. Games move as CIAs,
  saves move via Checkpoint.
- None of the dumped titles is New-3DS-only (no `KTR-` product codes), so all
  should run on the original 2DS.
- Always power off from the menu before removing a card from a console, and
  eject in Windows before removing it from the PC.
- See `scripts/copy-commands.md` for every command used and
  `scripts/verify.ps1` for the checksum comparison.
