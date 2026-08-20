# Raptus AG — Claude Code Statusline (Windows)
#
# PowerShell port of statusline.sh. Keep both in sync when the layout changes.
#
# This file must stay UTF-8 WITH BOM. PowerShell 5.1 reads a BOM-less .ps1 as ANSI,
# which mangles the emoji and the bar characters.

# Emoji and box drawing need a UTF-8 console encoding (PS 5.1 defaults to the OEM page).
try { [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false) } catch { }

$INV = [System.Globalization.CultureInfo]::InvariantCulture
$E   = [char]27

$RESET  = "$E[0m";  $BOLD   = "$E[1m"
$CYAN   = "$E[96m"; $GREEN  = "$E[92m"
$YELLOW = "$E[93m"; $RED    = "$E[91m"
$WHITE  = "$E[97m"; $GRAY   = "$E[90m"
$SEP    = "${GRAY}  │  ${RESET}"

# The status line is rendered in an area narrower than the terminal; without this
# reserve the tail gets truncated with an ellipsis.
$RIGHT_MARGIN = 4

# BMP code points that occupy two columns. Astral characters (emoji above U+FFFF)
# are detected via their surrogate pair and always count as two.
$WIDE_BMP = @(0x26A1)   # ⚡  — extend when adding BMP emoji to line 1

# ---------------------------------------------------------------- helpers

# Percentages: at most one decimal, trailing ".0" dropped. Invariant culture, so a
# German Windows does not render 5.5 as "5,5".
function Format-Pct($value) {
  $s = ([double]$value).ToString('F1', $INV)
  if ($s.EndsWith('.0')) { $s = $s.Substring(0, $s.Length - 2) }
  return $s
}

# Compact countdown to a Unix timestamp: 5d4h, 2h13m, 47m, now.
function Format-Until($target, $now) {
  $t = [int64][double]$target
  if ($t -le 0) { return '—' }
  $rem = $t - $now
  if ($rem -le 0) { return 'now' }
  $d = [int64][Math]::Floor($rem / 86400)
  $h = [int64][Math]::Floor(($rem % 86400) / 3600)
  $m = [int64][Math]::Floor(($rem % 3600) / 60)
  if ($d -gt 0) { return "${d}d${h}h" }
  if ($h -gt 0) { return "${h}h${m}m" }
  return "${m}m"
}

function Get-PctColor($value) {
  $v = [double]$value
  if ($v -lt 60) { return $GREEN }
  if ($v -lt 80) { return $YELLOW }
  return $RED
}

# Visible width in terminal columns: ANSI escapes ignored, wide glyphs count as two.
function Get-VisibleWidth([string]$text) {
  if (-not $text) { return 0 }
  $plain = $text -replace "$E\[[0-9;]*m", ''
  $w = 0
  for ($i = 0; $i -lt $plain.Length; $i++) {
    $c = $plain[$i]
    if ([char]::IsHighSurrogate($c)) { $w += 2; $i++; continue }
    $cat = [char]::GetUnicodeCategory($c)
    if ($cat -eq 'NonSpacingMark' -or $cat -eq 'Format') { continue }
    if ($WIDE_BMP -contains [int]$c) { $w += 2; continue }
    $w += 1
  }
  return $w
}

# Spaces that push $right to the right edge behind $left.
function Get-RightGap($left, $right, $cols) {
  $gap = $cols - (Get-VisibleWidth $left) - (Get-VisibleWidth $right) - $RIGHT_MARGIN
  if ($gap -ge 2) { return ' ' * $gap }
  return '  '
}

# ------------------------------------------------------------------ input

$raw = ''
try { $raw = [Console]::In.ReadToEnd() } catch { }
if (-not $raw) { try { $raw = ($input | Out-String) } catch { } }

$data = $null
try { if ($raw) { $data = $raw | ConvertFrom-Json } } catch { }
if (-not $data) { $data = New-Object psobject }

$model    = if ($data.model.display_name)               { $data.model.display_name }    else { '?' }
$effort   = if ($data.effort.level)                     { $data.effort.level }          else { '' }
$cwd      = if ($data.workspace.current_dir) { $data.workspace.current_dir } elseif ($data.cwd) { $data.cwd } else { '' }
$usedPct  = if ($null -ne $data.context_window.used_percentage) { $data.context_window.used_percentage } else { 0 }
$cost     = if ($null -ne $data.cost.total_cost_usd)    { $data.cost.total_cost_usd }    else { 0 }
$durMs    = if ($null -ne $data.cost.total_duration_ms) { $data.cost.total_duration_ms } else { 0 }

$fhResets = if ($null -ne $data.rate_limits.five_hour.resets_at)       { $data.rate_limits.five_hour.resets_at }       else { 0 }
$fhPct    = if ($null -ne $data.rate_limits.five_hour.used_percentage) { $data.rate_limits.five_hour.used_percentage } else { 0 }
$wkResets = if ($null -ne $data.rate_limits.seven_day.resets_at)       { $data.rate_limits.seven_day.resets_at }       else { 0 }
$wkPct    = if ($null -ne $data.rate_limits.seven_day.used_percentage) { $data.rate_limits.seven_day.used_percentage } else { 0 }

$folder = ''
if ($cwd) { try { $folder = Split-Path -Leaf $cwd } catch { $folder = $cwd } }

# Signed-in Claude account, local part only. Deliberately no Windows-user fallback:
# the point of this segment is to show WHICH Claude account is active, and an OS name
# would look exactly like one. Unreadable account -> a yellow "?".
$profileDir = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
$user = ''
try {
  $cfg = Join-Path $profileDir '.claude.json'
  if (Test-Path -LiteralPath $cfg) {
    $acct = (Get-Content -LiteralPath $cfg -Raw -Encoding UTF8 | ConvertFrom-Json).oauthAccount
    if ($acct.emailAddress) {
      $user = $acct.emailAddress
    } elseif ($acct.displayName) {
      $user = $acct.displayName
    }
  }
} catch { }
if ($user) { $user = ($user -split '@')[0] }
if ($user) {
  $userColor = $GRAY
} else {
  $user = '?'
  $userColor = $YELLOW
}

$branch = ''
if ($cwd) {
  try {
    $env:GIT_OPTIONAL_LOCKS = '0'
    $branch = (& git -C $cwd rev-parse --abbrev-ref HEAD 2>$null | Select-Object -First 1)
    if ($branch) { $branch = $branch.ToString().Trim() }
  } catch { $branch = '' }
}

# --------------------------------------------------------------- assemble

$durSec = [int64][Math]::Floor([double]$durMs / 1000)
if ($durSec -ge 3600) {
  $durFmt = "$([int64][Math]::Floor($durSec / 3600))h $([int64][Math]::Floor(($durSec % 3600) / 60))m"
} elseif ($durSec -ge 60) {
  $durFmt = "$([int64][Math]::Floor($durSec / 60))m $($durSec % 60)s"
} else {
  $durFmt = "${durSec}s"
}

$costFmt = '$' + ([double]$cost).ToString('F2', $INV)

# Truncate like awk's "%d" does, so 10 % gives one block, not two.
$filled = [int][Math]::Floor(([double]$usedPct / 100) * 10 + 0.5)
if ($filled -lt 0)  { $filled = 0 }
if ($filled -gt 10) { $filled = 10 }
$bar = ('█' * $filled) + ('░' * (10 - $filled))

# Context usage as a whole number; Format-Pct stays for the rate limits.
$pctFmt  = ([int64][Math]::Floor([double]$usedPct + 0.5)).ToString($INV)
$barColor = Get-PctColor $usedPct

$now     = [int64]([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())
$fhFmt   = Format-Until $fhResets $now
$wkFmt   = Format-Until $wkResets $now
$fhColor = Get-PctColor $fhPct
$wkColor = Get-PctColor $wkPct
$fhPctF  = Format-Pct $fhPct
$wkPctF  = Format-Pct $wkPct

$cols = 0
try { if ($env:COLUMNS) { $cols = [int]$env:COLUMNS } } catch { $cols = 0 }
if ($cols -le 0) { try { $cols = [Console]::WindowWidth } catch { $cols = 0 } }
if ($cols -le 0) { try { $cols = $Host.UI.RawUI.WindowSize.Width } catch { $cols = 0 } }
if ($cols -le 0) { $cols = 80 }

$line1 = "${CYAN}${BOLD}[${model}]${RESET}"
if ($effort) { $line1 += "${GRAY} ${RESET}${WHITE}${BOLD}⚡ ${effort}${RESET}" }
$line1 += "${GRAY}  ${RESET}${WHITE}📁 ${folder}${RESET}"
if ($branch -and $branch -ne 'HEAD') { $line1 += "${SEP}${GREEN}🌿 ${branch}${RESET}" }
if ($user) {
  $right = "${userColor}👤 ${user}${RESET}"
  $line1 += (Get-RightGap $line1 $right $cols) + $right
}

$line2  = "${barColor}${bar}${RESET} ${WHITE}${pctFmt}%${RESET}"
$line2 += "${SEP}${YELLOW}${costFmt}${RESET}"
$line2 += "${SEP}${GRAY}⏱ ${durFmt}${RESET}"
$line2 += "${SEP}${fhColor}🔄 5h ${fhPctF}% → ${fhFmt}${RESET}"
$line2 += "${SEP}${wkColor}📅 7d ${wkPctF}% → ${wkFmt}${RESET}"

# Console writer, not Write-Output: the PowerShell formatter would wrap the long
# second line at the buffer width.
[Console]::Out.Write($line1 + "`n" + $line2 + "`n")
