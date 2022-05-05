I ♥ Compute!
============

![I ♥ Compute!](doc/i-love-compute.256.png)

Task force to promote and make easy usage of OpenCL on Linux and beyond.

Targets:

- Identify all existing compute frameworks, focusing with OpenCL on Linux to begin with,
- Track issues accross projects,
- Provide installation instructions, scripts, repository links or packages
- Help to make possible to install multiple OpenCL frameworks and multiple version of OpenCL frameworks when possible,
- Provide compatibility matrix for softwares and OpenCL frameworks,
- Provide compatibility matrix for hardwares and OpenCL frameworks,
- Provide performance matrix for softwares and OpenCL frameworks,
- Gather generic knowldege about compute solutions.

Knowledge about Vulkan compute or legacy Shader-based compute is welcome, same for knowledge about other operating systems like BSD ones, Haiku and others.


Funding
-------

[![Donate on Patreon](https://img.shields.io/badge/donate-patreon-red?style=for-the-badge&logo=patreon)](https://www.patreon.com/bePatron?u=29259270) [![Donate on LiberaPay](https://img.shields.io/badge/donate-liberapay-yellow?style=for-the-badge&logo=liberapay)](https://liberapay.com/illwieckz/donate) [![Donate on Tipeee](https://img.shields.io/badge/donate-tipeee-e5555a?style=for-the-badge&logo=githubsponsors)](https://fr.tipeee.com/illwieckz/) [![Donate on Paypal](https://img.shields.io/badge/donate-paypal-blue?style=for-the-badge&logo=paypal)](https://www.paypal.me/illwieckz)

If this project helped you or saved your life, you can make a donation on
[Patreon](https://www.patreon.com/bePatron?u=29259270) ([profile](https://www.patreon.com/illwieckz)), [Liberapay](https://liberapay.com/illwieckz/donate) ([profile](https://liberapay.com/illwieckz/)), [Tipeee](https://fr.tipeee.com/illwieckz/) or [PayPal](https://www.paypal.me/illwieckz).

A lot of time is spent to test drivers and software, track regressions, implement solutions, benchmark and gather knowledge. Sometime hardware has to be sourced to reproduce issues and verify support.

Commercial support and consultancy can be obtained from [rebatir.fr](https://rebatir.fr).


Hardware donation
-----------------

Already sourced:

- AMD TeraScale 1 (PCIe, PCI, AGP),
- AMD TeraScale 2 (PCIe, PCI),
- AMD TeraScale 3 (PCIe),
- AMD GCN1 (PCIe),
- AMD GCN2 (PCIe),
- AMD GCN3 (integrated),
- AMD GCN5 (integrated),
- Nvidia Tesla 1.0 (PCI),
- Nvidia Tesla 2.0 (PCIe),
- Nvidia Kepler (PCIe),
- Intel Gen7 (integrated).

Missing:

- AMD GCN4 (Polaris),
- AMD RDNA1 (Navi), CDNA1,
- AMD RDNA2 (Big Navi), CDNA2,
- AMD hardware supported by ROCr,
- Via hardware (Chrome 520 and later),
- Nvidia hardware that is not Tesla or Kepler,
- Intel hardware that is not Gen7 (Haswell),
- Non-integrated Intel hardware like Intel Xe.

For hardware donation, send mail to _Thomas Debesse_ `<dev (ad) illwieckz.net>` to know more about the operation. Hardware has to be shipped to France.


Scripts
-------

The scripts provide a builtin help accessible with `-h` or `--help` option.

The user can do combinations: `./user-mesa run ./user-clvk run clinfo --list` to run clinfo with built clvk over built Mesa Vulkan, or `./user-mesa run ./user-luxmark3 run luxmark --mode=PAUSE` to run LuxMark 3.1 over Mesa Clover.

The scripts do some download, build and other operations in a `workspace` folder next to where the script file is stored.

### [`ubuntu-amdgpu`](scripts/ubuntu-amdgpu)

A script to install amdgpu-pro OpenCL on Ubuntu. This was based on many scripts [like this one](https://github.com/RadeonOpenCompute/ROCr/issues/484#issuecomment-554738964) written on various places through the years to make possible to use OpenCL with AMD GPUs.

It makes possible to install Orca (GCN1 to 4), PAL (GCN 5), ROCr and Clover (TeraScale, GCN+).

- The user can downloads and install all OpenCL drivers by doing `sudo ./ubuntu-amdgpu install all`, or only a select of them. For example the user can only install AMD APP for CPUs from Radeon Crimson (fglrx) and AMD APP for GPUs from Orca (AMDGPU-PRO) by doing `sudo ./ubuntu-amdgpu install stream orca`.
- The installation is done system-wide (requires `root` permission), and provided software is made available in default environment.

### [`user-clvk`](scripts/user-clvk)
A script to download, build clvk and run software using clvk.

- The user can download, build and install clvk by doing `./user-clvk build`.
- The installation is done in user workspace and provided software is not made available in default environment.
- The user can run `COMMAND` with built clvk by doing `./user-clvk run [COMMAND]`.

### [`user-mesa`](scripts/user-mesa)

A script to download, build Mesa (and its dependencies including LLVM) and run software using Clover OpenCL or Vulkan.

- The user can download, build and install Mesa Clover and Vulkan by doing `./user-mesa build`.
- The installation is done in user workspace and provided software is not made available in default environment.
- The user can run `COMMAND` with built Mesa Clover or Vulkan by doing `./user-mesa run [COMMAND]`.
- Beware that linking LLVM may consumes hundreds of gigabytes of RAM! By default the script reduces the amount of jobs when building LLVM : 1 job per 8GB of available RAM, as it was observed some files need 8GB of RAM to be linked.

### [`user-rusticl`](scripts/user-rusticl)

A script to download, build Mesa work-in-progress rusticl (and its dependencies including LLVM) and run software using it.

- The user can download, build and install Mesa work-in-progress rusticl by doing `./user-rusticl build`.
- The installation is done in user workspace and provided software is not made available in default environment.
- The user can run `COMMAND` with built Mesa Clover or Vulkan by doing `./user-rusticl run [COMMAND]`.
- The `LP_CL=1` environment variable can be set to run OpenCL on llvmpipe virtual device and the `RUSTICL_DEVICE_TYPE=gpu` environment variable can be set to make make it appeaing as a GPU devices to softwares.
- Beware that linking LLVM may consumes hundreds of gigabytes of RAM! By default the script reduces the amount of jobs when building LLVM : 1 job per 8GB of available RAM, as it was observed some files need 8GB of RAM to be linked.
- The rusticl platform is built from the [work-in-progress merge request at Mesa](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/15439), this script will be removed once rusticl is merged to the Mesa `main` branch (then the `user-mesa` script will be used to build rusticl).

### [`user-luxmark3`](scripts/user-luxmark3)

A script to download, build and run LuxMark 3.1.

- The user can download build and install LuxMark 3.1 by doing `./user-luxmark3 build`.
- The installation is done in user workspace and provided software is not made available in default environment.
- The user can run LuxMark by doing `./user-luxmark3 run` or more complicated commands like `./user-luxmark3 run luxmark --mode=PAUSE`.
- Beware that the scripts compiles old GCC 7 and old Qt 4. You need GCC 10 to build GCC 7.


Knowledge
---------

### Issue reporting

The [issue tracker](https://gitlab.com/illwieckz/i-love-compute/-/issues) is used to keep track of issues accross projects, to track them when no official issue tracker is identified, or to track the upstream efforts in a way it can be easily linked to other issues.


### Productivity software

See also [wikipedia.org:List of OpenCL applications](https://en.wikipedia.org/wiki/List_of_OpenCL_applications).

Note that all those software are known to be affected by bug [#2](https://gitlab.com/illwieckz/i-love-compute/-/issues/2) (_having a GPU using the radeon driver alongside a GPU using the amdgpu driver makes OpenCL applications unable to run at all_).

Software currently providing OpenCL support:

- *[Darktable](https://www.darktable.org/)*, requires image support, works with Intel proprietary (verified) and open (supposedly) framework, Nvidia proprietary (verified) framework, AMD legacy proprietary (verified) and open ROCr (supposed) framework, but not on Clover/libCLC, see [#1](https://gitlab.com/illwieckz/i-love-compute/-/issues/1) (missing image support),
- *[LuxCoreRender](https://luxcorerender.org/)*, verified support via *[LuxMark](http://luxmark.info)* on AMDGPU-PRO legacy and non-legacy, old LuxRender (the one used by LuxMark 3.1) worked on Mesa Clover with both TeraScale and GCN.
- *[GIMP](https://www.gimp.org/)*, some list of OpenCL-enabled effects are listed [there](https://opencl.org/projects/gegl-opencl-in-gimp/),
- *[LibreOffice Calc](https://www.libreoffice.org/) (`localc`)*, see [this page about how to enable it](https://help.libreoffice.org/7.3/en-US/text/shared/optionen/opencl.html),
- *[Natron](https://natrongithub.github.io/)*,
- *[OBS Studio](https://obsproject.com/)*,
- *[DaVinci Resolve](https://www.blackmagicdesign.com/fr/products/davinciresolve/)*.


It is known LuxRender on an AMD R9 390X is almost twice faster on Clover with GCN hardware than on AMD-APP Legacy (Orca) or PAL or ROCr when it worked (see [#10](https://gitlab.com/illwieckz/i-love-compute/-/issues/10)), so people rendering things using this raytracer may prefer to use Clover, but it's known Clover lacks image support so photographers may want to install AMD-APP Legacy instead to run Darktable with working OpenCL using that GPU.

Software formerly providing OpenCL support:

- *[Blender](https://www.blender.org)* (old versions), verified support on AMDGPU-PRO legacy and non-legacy, OpenCL has been [deprecated](https://code.blender.org/2021/04/cycles-x/) and then removed in newer versions,


### Benchmarks

See also [wikipedia.org:List of OpenCL applications](https://en.wikipedia.org/wiki/List_of_OpenCL_applications).

Benchmarks currently providing OpenCL support:

- *[LuxMark](http://luxmark.info)*, see [`user-luxmark3`](scripts/user-luxmark3) for a script to rebuild the version 3.1,
- *[GeekBench](https://www.geekbench.com)*,
- *[ViennaCLBench](http://viennaclbench.sourceforge.net)*,
- *[clpeak](https://github.com/krrishnarraj/clpeak/network)*,
- *[cl-mem](https://github.com/nerdralph/cl-mem)*, see [viennaclbench-dev#14](https://github.com/viennacl/viennaclbench-dev/pull/14) for compilations fixes,
- *[uCLbench](https://opencl.org/coding/tools/uclbench/)*,
- *[Scalable HeterOgeneous Computing (SHOC)](https://github.com/vetter/shoc)*,
- *[Parboil benchmarks](http://impact.crhc.illinois.edu/Parboil/parboil.aspx)*,
- *[OpenCL Toys](http://davibu.interfree.it/index.html)*, including *MandelGPU*, *MandelbulbGPU*, *SmallptGPU*, *SmallptGPU2*, *JuliaGPU*, and *SmallLuxGPU*.

The Phoronix Test Suite also provides multiple ready-to-use [OpenCL Benchmarks](https://openbenchmarking.org/suite/pts/opencl) including LuxMark, JuliaGPU, MandelGPU, SmallptGPU, SHOC, Paroboil, Rodinia, etc.


### AMD quirks

The `GPU_DEVICE_ORDINAL` environment variable can be used to whitelist some GPUs with AMD ROCr, Orca and PAL. Unfortunately, it whitelits the card (and blacklists all others) for every AMD OpenCL Driver so one cannot blacklist a GPU in ROCr to prevent a kernel breakage and get it working with another driver like Orca, so it's not possible to keep ROCr on one GPU while blacklisting another GPU on ROCr to use it with something else like Orca. See [ROCr#1624](https://github.com/RadeonOpenCompute/ROCr/issues/1624).

No one GPU driven by the `radeon` kernel driver must be present in the system to be able to use AMD Orca or PAL with others GPU driven by the `amdgpu` kernel driver. See [#2](https://gitlab.com/illwieckz/i-love-compute/-/issues/2). Unfortunately, attempts to blacklist them using `GPU_DEVICE_ORDINAL` does not work.

Orca requires an X11 server being up and running.


### Interesting projects to look at

- [rusticl](https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/15439) is a work-in-progress Mesa project by Karol Herbst for a new OpenCL implementation.

- [CLara](https://gitlab.com/illwieckz/clara) is a project by Björn König for a framework to access OpenCL devies over the network. The project is unfortunately stalled since year 2010 and is still in alpha state. If you're an OpenCL wizard and can see the interest of such project, you're welcome to improve it!


### Frameworks

- Vulkan compatible GPU,
  - clvk, based on Google clspv  
  open, incomplete (verified).
- ATI/AMD GPU,
  - Mesa Clover, LLVM libclc r600,  
  open, incomplete, TeraScale2-3 (verified).
    * Last known working version: Mesa 20.0.4, LLVM 9.0.1 (`20190827`, verified).
  - Mesa Clover, LLVM libclc amdgcn,  
  open, incomplete, GCN1-5 (verified), RDNA (not verified).
    * Last known working version: Mesa 20.0.4, LLVM 9.0.1 (`20190827`, verified), LuxRender is twice faster on Clover than on Orca, PAL and ROCr.
  - AMDGPU-PRO Orca (legacy),  
  closed, complete, GCN1-3 (verified), probably GCN4 (not verified).
    * Last working version for Orca (`2021-06-21`, discontinued?): [AMDGPU-PRO 21.20-1271047](https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-21-20) (verified).
  - AMDGPU-PRO PAL,  
  closed, complete, GCN5 (verified), probably RDNA (not verified).
    * Last version for PAL (`2020-09-29`, discontinued): [AMDGPU-PRO 20.40-1147286](https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-20-40) (verified), removed in favor of ROCr in Radeon Software AMDGPU-PRO without ROCr being actually an alternative.
  - ROCr,  
  open, incomplete (not for GUI applications, not verified), few GCN, RDNA, CDNA (not verified), may break the whole system with some hardware (verified), replaced PAL in Radeon Software AMDGPU-PRO without being an alternative, neither in purpose, neither in hardware support, neither in implementation, neither in fulfilment.
  - fglrx AMD APP,  
  closed and requires old kernel, complete, old GPUs, the only option for TeraScale,  
  people are still [using it in 2020](https://gitlab.com/illwieckz/i-love-compute/-/issues/1#note_451460689).  
    * Last version for GCN (`2015-12-18`, discontinued): [AMD Radeon Software Crimson 15.12-15.302-151217a-297685e](https://www.amd.com/fr/support/graphics/amd-radeon-r9-series/amd-radeon-r9-300-series/amd-radeon-r9-390x) (fglrx, see _Linux x86_64_), requires Ubuntu 14.04 and 3.19 kernel (verified).
    * Last version for TeraScale2 to 3 (`2015-09-15`discontinued): [AMD Catalyst 15.9-15.201.1151](https://www.amd.com/fr/support/graphics/amd-radeon-hd/ati-radeon-hd-5000-series/ati-radeon-hd-5970) (fglrx, see _Linux x86_64_), requires Ubuntu 14.04 and 3.19 kernel (verified).
    * Last version for TeraScale1 (`2013-01-21`, discontinued): [AMD Catalyst 13.1](https://www.amd.com/fr/support/graphics/amd-radeon-hd/ati-radeon-hd-4000-series/ati-radeon-hd-4890), requires Ubuntu 12.04 (not verified), only option for TeraScale 1 like Radeon HD 4890 PCIe and Radeon HD 4670 AGP (not verified).
  - mesa3d-comp-bridge,  
    open on closed code, unmaintained, was meant to run Mesa Clover over Mesa APP OpenCL compiler.
  - pocl with HSA,  
  open, early state, not tested.
- AMD CPU,
  - pocl,  
  open, not verified.
  - older AMDGPU-PRO or fglrx,  
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
  open requiring closed component, incomplete, noy tested.
  - Nvidia,  
  closed, complete, verified.
  - pocl with Nvidia,  
  open requiring closed component, early-state, not tested.
- FPGAs,
  - Intel OneAPI OpenCL,  
  not tested.


### Links

- clvk, Google clspv  
  - https://github.com/kpet/clvk
  - https://github.com/google/clspv
- Mesa/Clover, LLVM libclc:
  - https://gitlab.freedesktop.org/mesa/mesa
  - https://libclc.llvm.org
  - https://github.com/llvm/llvm-project/tree/main/libclc
  - https://www.x.org/wiki/RadeonFeature
- Mesa/rusticl:
  - https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/15439
- AMD ROCr:
  - https://github.com/RadeonOpenCompute/ROCm
- AMDGPU-PRO:
  - https://www.amd.com/en/support
- mesa3d-comp-bridge:
  - https://github.com/matszpk/mesa3d-comp-bridge
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


### Other scripts

It may be useful to look at some AUR packages to improve or extend existing scripts: https://wiki.archlinux.org/index.php/GPGPU


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

Content must be submitted under MIT or CC 0 1.0 license.
