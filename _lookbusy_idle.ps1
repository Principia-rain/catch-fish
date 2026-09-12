# LookBusy idle-detector v2
# Usage: powershell -File _lookbusy_idle.ps1 <pid-of-the-cmd-window>
# After ~2 min with NO mouse movement, it maximises/restores the given
# cmd window directly via its window handle. No global hotkeys => it can
# NEVER hit the wrong window / taskbar / start menu.

param([int]$TargetPid = 0)

Add-Type -AssemblyName System.Windows.Forms

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class W {
  public const uint SW_RESTORE = 9;
  public const uint SW_MAXIMIZE = 3;
  [DllImport("user32.dll")]
  public static extern bool IsWindow(IntPtr h);
  [DllImport("user32.dll")]
  public static extern bool ShowWindowAsync(IntPtr h, uint cmd);
  [DllImport("user32.dll")]
  public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")]
  public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")]
  public static extern int GetWindowThreadProcessId(IntPtr h, out int pid);
}
"@

function Get-TargetWindow {
    param([int]$Pid)
    # enumerate top-level windows and match by PID
    $sig = @'
using System;
using System.Runtime.InteropServices;
using System.Collections.Generic;
public class EnumWin {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")]
  public static extern bool EnumWindows(EnumProc cb, IntPtr l);
  [DllImport("user32.dll")]
  public static extern int GetWindowThreadProcessId(IntPtr h, out int pid);
  [DllImport("user32.dll")]
  public static extern bool IsWindowVisible(IntPtr h);
  public static IntPtr Find(IntPtr targetPid) {
    IntPtr found = IntPtr.Zero;
    EnumWindows((h, l) => {
      int pid; GetWindowThreadProcessId(h, out pid);
      if ((IntPtr)pid == targetPid && IsWindowVisible(h)) { found = h; return false; }
      return true;
    }, IntPtr.Zero);
    return found;
  }
}
'@
    Add-Type -TypeDefinition $sig -Language CSharp
    [EnumWin]::Find([IntPtr]$Pid)
}

$idleSecs = 120
$pollSecs = 5
$needed = [int]($idleSecs / $pollSecs)

$lastPos = [System.Windows.Forms.Cursor]::Position
$unchanged = 0

while ($true) {
    Start-Sleep -Seconds $pollSecs
    $p = [System.Windows.Forms.Cursor]::Position
    if ($p.X -eq $lastPos.X -and $p.Y -eq $lastPos.Y) {
        $unchanged += 1
    } else {
        $unchanged = 0
        $lastPos = $p
    }
    if ($unchanged -ge $needed -and $TargetPid -gt 0) {
        $h = Get-TargetWindow -Pid $TargetPid
        if ($h -ne [IntPtr]::Zero -and [W]::IsWindow($h)) {
            # restore from minimised if needed, then maximise, then focus
            [W]::ShowWindowAsync($h, [W]::SW_RESTORE)
            Start-Sleep -Milliseconds 300
            [W]::ShowWindowAsync($h, [W]::SW_MAXIMIZE)
            Start-Sleep -Milliseconds 200
            [W]::SetForegroundWindow($h)
        }
        Start-Sleep -Seconds 6
        $lastPos = [System.Windows.Forms.Cursor]::Position
        $unchanged = 0
    }
}
