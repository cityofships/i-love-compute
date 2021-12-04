I ♥ Compute
===========

![I ♥ Compute](doc/i-love-compute.256.png)

Task force to promote and make easy usage of OpenCL on Linux and beyond.

Targets:

- Identify all existing compute framework, starting with OpenCL and Linux
- Compatibility matrix for hardwares and OpenCL frameworks
- Compatibility matrix for softwares and OpenCL frameworks
- Performance matrix for softwares and OpenCL frameworks
- Installation instructions, possibly scripts, repository links or packages
- Track issues accross projects
- Help to make possible to install multiple OpenCL frameworks and multiple version of OpenCL frameworks when possible.

Knowledge about Vulkan compute or legacy Shader-based compute is welcome, same with other systems like BSD ones.


Funding
-------

[![Donate via Patreon](https://img.shields.io/badge/donate-patreon-red?style=for-the-badge&logo=patreon#inline)](https://www.patreon.com/bePatron?u=29259270) [![Donate via Liberapay](https://img.shields.io/badge/donate-liberapay-yellow?style=for-the-badge&logo=liberapay#inline)](https://liberapay.com/illwieckz/donate) [![Donate via PayPal](https://img.shields.io/badge/donate-paypal-blue?style=for-the-badge&logo=paypal#inline)](https://www.paypal.me/illwieckz)

If this project saved your life, you can make a donation on 
[Patreon](https://www.patreon.com/bePatron?u=29259270) ([profile](https://www.patreon.com/illwieckz)), [Liberapay](https://liberapay.com/illwieckz/donate) ([profile](https://liberapay.com/illwieckz/)) or [PayPal](https://www.paypal.me/illwieckz).

A lot of time is spent to test drivers and software, track regressions, implement solutions, benchmark and gather knowledge. Sometime hardware has to be sourced to reproduce issues and verify support.

Commercial support and consultancy can be obtained from [rebuild.sh](https://rebuild.sh/).


Hardware donation
-----------------

Already sourced: AMD TeraScale 1-3 (AGP, PCI, PCIe), GCN1,2,3,5 (PCIe). Nvidia Kepler (PCIe), Tesla 2.0 (PCIe), Tesla 1.0 (PCI). Intel Gen7.

Missing: AMD GCN4, RDNA1-2, CDNA1-2 hardware. ROCm supported hardware. Via Chrome. Most Nvidia and Intel hardware. For hardware donation, send mail to _Thomas Debesse_ `<dev (ad) illwieckz.net>`.


### Scripts and packages

Script to install amdgpu-pro OpenCL on Ubuntu: [ubuntu-opencl-amdgpu](scripts/ubuntu-opencl-amdgpu)

This was based on many scripts written through the yearn [like this one](https://github.com/RadeonOpenCompute/ROCm/issues/484#issuecomment-554738964).

Script to install amdgpu-pro OpenCL on unsupported Mageia using supported Red-Hat packages: INCOMING.

Arch linux AUR packages: https://wiki.archlinux.org/index.php/GPGPU


Knowledge
---------

### Productivity software

- Darktable, requires image support, works with Intel proprietary (verified) and open (supposedly) framework, Nvidia proprietary (verified) framework, AMD legacy proprietary (verified) and open ROCm (supposed) framework, but not on Clover/libCLC, see [#1](https://gitlab.com/illwieckz/i-love-compute/-/issues/1) (missing image support),
- Blender, verified support on AMDGPU-PRO legacy and non-legacy,
- LuxRender, verified support via LuxMark on Mesa TeraScale and GCN, AMDGPU-PRO legacy and non-legacy,
- GIMP,
- LibreOffice Calc.

Note that all those software are known to be affected by bug [#2](https://gitlab.com/illwieckz/i-love-compute/-/issues/2) (_having a GPU using the radeon driver alongside a GPU using the amdgpu driver makes OpenCL applications unable to run at all_).

It is known LuxRender an AMD R9 390X is almost twice faster on Clover with GCN hardware than on AMD-APP Legacy (Orca) or ROCm when it worked (see [#10](https://gitlab.com/illwieckz/i-love-compute/-/issues/10)), so people rendering things using this raytracer may prefer to use Clover, but it's known Clover lacks image support so photographers may want to install AMD-APP Legacy instead to run Darktable with working OpenCL using that GPU.


### Frameworks

- ATI/AMD GPU,
  - Mesa Clover, libclc r600,  
  open, incomplete, TeraScale2-3 (verified).
    * Last known working version: Mesa 20.0.4, LLVM 9.0.1 (verified).
  - Mesa Clover, libclc amdgcn,  
  open, incomplete, GCN1-5 (verified), RDNA (not verified).
    * Last known working version: Mesa 20.0.4, LLVM 9.0.1 (verified).
  - AMDGPU-PRO Orca (legacy),  
  closed, complete, GCN1-3 (verified), probably GCN4 (not verified).
    * Last working version for Orca (`2021-06-21`, discontinued?): [AMDGPU-PRO 21.20-1271047](https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-21-20) (verified).
  - AMDGPU-PRO PAL,  
  closed, complete, GCN5 (verified), probably RDNA (not verified).
    * Last version for PAL (`2021-09-29`, discontinued): [AMDGPU-PRO 20.40-1147286](https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-20-40) (verified).
  - ROCm,  
  open, incomplete (not for GUI applications, not verified), few GCN, RDNA, CDNA (not verified), may break the whole system with some hardware (verified).
  - fglrx AMD APP,  
  closed and requires old kernel, complete, old GPUs, the only option for TeraScale,  
  people are still [using it in 2020](https://gitlab.com/illwieckz/i-love-compute/-/issues/1#note_451460689).  
    * Last version for GCN (`2015-12-18`, discontinued): [AMD Radeon Software Crimson 15.12-15.302-151217a-297685e](https://www.amd.com/fr/support/graphics/amd-radeon-r9-series/amd-radeon-r9-300-series/amd-radeon-r9-390x) (fglrx, see _Linux x86_64_), requires Ubuntu 14.04 and 3.19 kernel (verified).
    * Last version for TeraScale2 to 3 (`2015-09-15`discontinued): [AMD Catalyst 15.9-15.201.1151](https://www.amd.com/fr/support/graphics/amd-radeon-hd/ati-radeon-hd-5000-series/ati-radeon-hd-5970) (fglrx, see _Linux x86_64_), requires Ubuntu 14.04 and 3.19 kernel (verified).
    * Last version for TeraScale1 (`2013-01-21`, discontinued): [AMD Catalyst 13.1](https://www.amd.com/fr/support/graphics/amd-radeon-hd/ati-radeon-hd-4000-series/ati-radeon-hd-4890), requires Ubuntu 12.04 (not verified), only option for TeraScale 1 like Radeon HD 4890 PCIe and Radeon HD 4670 AGP (not verified).
  - pocl with HSA,  
  open, early state, not tested.
- AMD CPU,
  - pocl,  
  open, not verified.
  - older AMDGPU-PRO,  
  closed, complete, verified.
- Intel GPU,
  - Intel proprietary legacy SDK (SRB4, SRB4.1),  
  closed, complete, verified.
  - Intel proprietary classic SDK (SRB5),  
  closed, complete, verified.
  - Intel open (NEO),  
  open, complete, verified.
  - Intel open (Beignet),  
  open, complete, verified.
  - Intel OneAPI OpenCL,  
  not tested.
- Intel CPU,
  - pocl, not verified,  
  open, untested.
  - older AMDGPU-PRO,  
  closed, complete, verified.
  - Intel proprietary legacy SDK,  
  closed, complete, verified.
  - Intel OneAPI OpenCL,  
  open components, full openness unknown, not tested.
- Nvidia GPU,
  - Mesa Clover, libclc nouveau.  
  open, early state, not tested,
  - libclc ptx,  
  open requirinh closed component, incomplete, noy tested.
  - Nvidia,  
  closed, complete, verified.
  - pocl with Nvidia,  
  open requiring closed component, early-state, not tested.
- FPGAs,
  - Intel OneAPI OpenCL,  
  not tested.


### Links

- Mesa/Clover, LLVM libclc:
  - https://gitlab.freedesktop.org/mesa/mesa
  - https://libclc.llvm.org
  - https://github.com/llvm/llvm-project/tree/main/libclc
  - https://www.x.org/wiki/RadeonFeature
- ROCm:
  - https://github.com/RadeonOpenCompute/ROCm
- AMDGPU-PRO:
  - https://www.amd.com/en/support
- Various Intel OpenCL:
  - https://software.intel.com/content/www/cn/zh/develop/articles/intel-sdk-for-opencl-applications-release-notes.html
- Intel NEO OpenCL:
  - https://github.com/intel/compute-runtime
  - https://01.org/compute-runtime
  - https://community.intel.com/t5/OpenCL/OpenCL-GPU-driver-NEO-is-now-available-in-open-source/td-p/1145461
- Intel Beignet OpenCL:
  - https://www.freedesktop.org/wiki/Software/Beignet/
  - https://github.com/intel/beignet
- Legacy Intel OpenCL:
  - https://software.intel.com/content/www/us/en/develop/articles/legacy-opencl-drivers.html
- Intel OneAPI:
  - https://www.intel.com/content/www/us/en/developer/tools/oneapi/toolkits.html
- PoCL:
  - http://portablecl.org
  - https://github.com/pocl/pocl


### Multiple frameworks

Example of what can be achieved with a `Lenovo W541` laptop featuring an `Nvidia Quadro K1100M` GPU and an `Intel i7-4810MQ` CPU with `Intel HD 4600` integrated GPU:

```
OpenCL 1.2 GPU: nvidia/cuda 390.138
OpenCL 1.2 GPU: intel/cl r3.1.58620
OpenCL 1.2 GPU: intel/beignet 1.3

OpenCL 1.2 CPU: pocl 1.4
OpenCL 1.2 CPU: intel/cl 1.2.0.330
OpenCL 1.2 CPU: amd/app 2236.5
```

Example of what can be achieved with an `Asus Sabertooth 990FX R2.0` motherboard featuring an `AMD Radeon HD 5450 (Cedar)` GPU, an `AMD Radeon HD 6970 (Cayman XT)` GPU, an `AMD Radeon HD 5870 Eyefinity⁶ Edition (Cypress XT)` GPU, an `AMD FirePro V4800 (Redwood XT GL)` GPU and an `AMD FX-9590 (Piledriver)` CPU:

```
OpenCL 1.1 GPU: mesa/clover 20.0.4, llvm/libclc 9.0.1
OpenCL 1.1 GPU: mesa/clover 20.0.4, llvm/libclc 9.0.1
OpenCL 1.1 GPU: mesa/clover 20.0.4, llvm/libclc 9.0.1
OpenCL 1.1 GPU: mesa/clover 20.0.4, llvm/libclc 9.0.1

OpenCL 1.2 CPU: amd/app 1912.5
```

Example of what can be achived with a `Gigabyte WRX80-SU8-IPMI R1.0` motherboard featuring an `AMD R9 390X (Grenada)` GPU, an `AMD R7 (Oland)` GPU and an `AMD Ryzen Threadripper PRO 3955WX (Zen 2)` CPU:

```
OpenCL 1.1 GPU: mesa/clover 20.0.4, llvm/libclc 9.0.1
OpenCL 1.1 GPU: mesa/clover 20.0.4, llvm/libclc 9.0.1

OpenCL 1.2 GPU: amd/orca 3224.4
OpenCL 1.2 GPU: amd/orca 3224.4

OpenCL 1.2 CPU: amd/app 1912.5
```

Having multiple OpenCL frameworks installed at the same time is useful because an implementation may be known to be faster for a given task but incomplete for another. It's also easier for testing.

This is very similar to what happens on gaming side where some apps would work well with `radv` but others would require `amdvlk`, both being installable at the same time.

Also, having multiple frameworks may help to improve compute performance by putting everyone's hand on the desk. For example on that laptop the best LuxMark score would be done running three OpenCL devices: the Nvidia GPU, the Intel GPU, and the Intel CPU ([example](http://luxmark.info/node/3425)), that can be done with only two frameworks but some other combinations involving three frameworks may give better score.


### Compatibility and performance matrix

See how that is done on another topic (graphical rendering) for graphical framework and hardware compatibility matrix: https://wiki.unvanquished.net/wiki/GPU_compatibility_matrix

A similar thing would be good to have for OpenCL, and also to know who may own which hardware to easily reproduce reported issues.


Contibute
---------

Create issues, make pull requests, contact _Thomas Debesse_ `<dev (ad) illwieckz.net>` for more details.

Submitted content must be under MIT or CC 0 1.0 license.