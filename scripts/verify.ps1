# Compares every file under -Src with the same relative path under -Dst by SHA256.
# Writes a summary line plus any mismatched/unreadable files to -Report.
#
# Example:
#   .\verify.ps1 -Src "E:\3DS XL SD Backup" -Dst "K:\" -Report "E:\verify.txt"
param(
    [Parameter(Mandatory)] [string]$Src,
    [Parameter(Mandatory)] [string]$Dst,
    [Parameter(Mandatory)] [string]$Report
)

$files = Get-ChildItem $Src -Recurse -File -Force
$ok = 0; $bad = @()
foreach ($f in $files) {
    $rel = $f.FullName.Substring($Src.Length).TrimStart('\')
    $d = Join-Path $Dst $rel
    try {
        $h1 = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256 -ErrorAction Stop).Hash
        $h2 = (Get-FileHash -LiteralPath $d -Algorithm SHA256 -ErrorAction Stop).Hash
        if ($h1 -eq $h2) { $ok++ } else { $bad += "MISMATCH $rel" }
    } catch { $bad += "UNREADABLE $rel : $($_.Exception.Message)" }
}
$out = @("checked: $($files.Count)  identical: $ok  problems: $($bad.Count)") + $bad
$out | Out-File -FilePath $Report -Encoding utf8
$out | Select-Object -First 20
