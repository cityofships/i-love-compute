I ♥ Compute!
============

![I ♥ Compute!](doc/i-love-compute.256.png)

Task force to promote and make easy usage of OpenCL on Linux and beyond.

Tasks being worked on:

- Identify existing compute frameworks, focusing on OpenCL on Linux to begin with,
- Track issues accross projects,
- Provide installation instructions, scripts, repository links or packages,
- Help to make possible to install multiple OpenCL frameworks and multiple version of OpenCL frameworks when possible,
- Gather generic knowldege about compute solutions.

Postponed tasks:

- Provide compatibility matrix for pieces of software and OpenCL frameworks,
- Provide compatibility matrix for pieces of hardware and OpenCL frameworks,
- Provide performance matrix for pieces of software and OpenCL frameworks.

Knowledge about HIP, HSA, SyCL, Level Zero, oneAPI, Vulkan compute or OpenGL compute shaders is welcome, same for knowledge about other operating systems like BSD ones, Haiku and others.


Funding
-------

[![Donate on Patreon](https://img.shields.io/badge/donate-patreon-red?style=for-the-badge&logo=patreon)](https://www.patreon.com/bePatron?u=29259270) [![Donate on LiberaPay](https://img.shields.io/badge/donate-liberapay-yellow?style=for-the-badge&logo=liberapay)](https://liberapay.com/illwieckz/donate) [![Donate on Tipeee](https://img.shields.io/badge/donate-tipeee-e5555a?style=for-the-badge&logo=githubsponsors)](https://fr.tipeee.com/illwieckz/) [![Donate on Paypal](https://img.shields.io/badge/donate-paypal-blue?style=for-the-badge&logo=paypal)](https://www.paypal.me/illwieckz)

If this project helped you or saved your life, you can make a donation on
[Patreon](https://www.patreon.com/bePatron?u=29259270) ([profile](https://www.patreon.com/illwieckz)), [Liberapay](https://liberapay.com/illwieckz/donate) ([profile](https://liberapay.com/illwieckz/)), [Tipeee](https://fr.tipeee.com/illwieckz/) or [PayPal](https://www.paypal.me/illwieckz).

A lot of time is spent to test drivers and software, track regressions, implement solutions, benchmark and gather knowledge. Sometime hardware has to be sourced to reproduce issues and verify support.

Commercial support and consultancy can be obtained from [rebatir.fr](https://rebatir.fr).


Hardware donation
-----------------

For hardware donation, send mail to _Thomas Debesse_ `<dev (ad) illwieckz.net>` to know more about the operation. Hardware has to be shipped to France.

Looking for:

- AMD CDNA 3 (Aqua Vanjaram),
- AMD discrete RDNA2.0 (Navi 21, 22, 23, 24),
- AMD CDNA 2.0 (Aldebaran),
- AMD RDNA 1.0 (Navii 10, 14),
- AMD CDNA 1.0 (Arcturus),
- AMD GCN 5.1 (Vega 20),
- Via hardware (Chrome 520 and later),
- Nvidia hardware with GSP,
- Nvidia hardware using nvc0,
- Intel Arc,
- Intel Xe.

Already sourced:

- AMD RDNA 3.0 (radeonsi; discrete: PCIe),
- AMD RDNA 2.0 (radeonsi; integrated),
- AMD GCN 5.0 (radeonsi; discrete: PCIe),
- AMD GCN 5.0 (radeonsi; integrated),
- AMD GCN 4.0 (radeonsi; discrete: PCIe),
- AMD GCN 3.0 (radeonsi; discrete: PCIe),
- AMD GCN 3.0 (radeonsi; integrated),
- AMD GCN 2.0 (radeonsi; discrete: PCIe),
- AMD GCN 1.0 (radeonsi; discrete: PCIe),
- AMD TeraScale 3 (r600; discrete: PCIe),
- AMD TeraScale 2 (r600; discrete: PCIe, PCI),
- AMD TeraScale 1 (r600; discrete: PCIe, AGP, PCI),
- Intel Gen9 GT2 (iris; integrated);
- Intel Gen7 GT2 (crocus; integrated),
- Nvidia Kepler (nv50; discrete: PCIe; onboard),
- Nvidia Tesla 2.0 (nv50; discrete: PCIe),
- Nvidia Tesla 1.0 (nv50; discrete: PCI).


Scripts
-------

The scripts provide a built-in help accessible with `-h` or `--help` option.

The user can do combinations: `./user-mesa run ./user-clvk run clinfo --list` to run clinfo with built clvk over built Mesa Vulkan, or `./user-mesa run ./user-luxmark3 run luxmark --mode=PAUSE` to run LuxMark 3.1 over Mesa Clover.

The scripts do some download, build and other operations in a `workspace` folder next to where the script file is stored.

The `user-` scripts are no longer standalone and now share common parts externalized as a library, they must be executed from within this repository to load the library and be working.


### [`ubuntu-amdgpu`](scripts/ubuntu-amdgpu)

A script to install amdgpu-pro OpenCL on Ubuntu. This was based on many scripts [like this one](https://github.com/RadeonOpenCompute/ROCr/issues/484#issuecomment-554738964) written on various places through the years to make possible to use OpenCL with AMD GPUs.

It makes possible to install Orca (GCN 2.0 to 4.0), PAL (GCN 5.0), ROCr and Clover (TeraScale 2 and 3, GCN 1 and later).

- The user can downloads and install all OpenCL drivers by doing `sudo ./ubuntu-amdgpu install all`, or only a select of them. For example the user can only install AMD APP for CPUs from Radeon Crimson (fglrx) and AMD APP for GPUs from Orca (AMDGPU-PRO) by doing `sudo ./ubuntu-amdgpu install fglrx orca`.
- The installation is done as root and system-wide, provided software is made available to default environment.

This script is known to work on Ubuntu 22.04 LTS.

Note: This script installs older Clover packages that are known to work both with radeonsi and r600 but may not support newer cards. Newer versions are known to not work with r600. Official Ubuntu Clover package `mesa-opencl-icd` may be installed by hand instead. See [llvm/llvm-project#54947](https://github.com/llvm/llvm-project/issues/54947). Official Ubuntu Clover packages may not be usable with r600. See [llvm/llvm-project#54942](https://github.com/llvm/llvm-project/issues/54942).


### [`user-mesa`](scripts/user-mesa)

A script to download, build Mesa (and its dependencies including LLVM) and run software using OpenCL or Vulkan.

- The user can download, build and install Mesa by doing `./user-mesa build`.
- The installation is done as user in `workspace/user-mesa` and provided software is not made available in default environment.
- The user can run `COMMAND` with Mesa by doing `./user-mesa run [COMMAND]`.
- The `LP_CL=1` environment variable can be set to run OpenCL on llvmpipe virtual device and the `RUSTICL_DEVICE_TYPE=gpu` environment variable can be set to make make it appeaing as a GPU devices to softwares.
- Beware that linking LLVM may consumes hundreds of gigabytes of RAM! By default the script reduces the amount of jobs when building LLVM : 1 job per 8GB of available RAM, as it was observed some files need 8GB of RAM to be linked.


### [`user-nvk`](scripts/user-nvk)

A script to download, build Mesa NVK and run software using Vulkan.

This is a variant of the `user-mesa` script building the experimental out-of-tree nvk vulkan driver.

- The user can download, build and install NVK by doing `./user-nvk build`.
- The installation is done in user workspace and provided software is not made available in default environment.
- The user can run `COMMAND` with built NVK by doing `./user-nvk run [COMMAND]`.


### [`user-clvk`](scripts/user-clvk)

A script to download, build clvk and run software using clvk.

- The user can download, build and install clvk by doing `./user-clvk build`.
- The installation is done as user in `workspace/user-clvk` and provided software is not made available in default environment.
- The user can run `COMMAND` with built clvk by doing `./user-clvk run [COMMAND]`.


### [`user-pocl`](scripts/user-pocl)

A script to download, build and run PoCL (Portable Computing Language) and run software using it. Vulkan support is enabled using clspv.

- The user can download build and install PoCL by doing `./user-pocl build`.
- The installation is done as user in `workspace/user-pocl` and provided software is not made available in default environment.
- The user can run `COMMAND` with built PoCL by doing `./user-pocl run [COMMAND]`.
- By default `POCL_DEVICES` is set to `pthread vulkan`, the user can only run an OpenCL application with PoCL on pthread or vulkan by doing `POCL_DEVICES=pthread ./user-pocl run [COMMAND]` or `POCL_DEVICES=vulkan ./user-pocl run [COMMAND]`.


### [`user-chipstar`](scripts/user-chipstar)

A script to download, build and run chipStar (a platform to run HIP over OpenCL) and run software using it.

chipStar (previously named CHIP-SPV) is an integration of HIPCL and HIPLZ supporting OpenCL and Level Zero backends.

- The user can download build and instal chipStar by doing `./user-chipstar build`.
- The installation is done as user in `workspace/user-chipstar` and provided software is not made available in default environment.
- The user can run `COMMAND` with built chipStar by doing `./user-chipstar run [COMMAND]`.


### [`user-amdoclfix`](scripts/user-amdoclfix)

A script to download, build amdocl-fix and run software using it, for example DaVinci Resolve.

- The user can download build and install amdocl-fix by doing `./user-amdoclfix build`.
- The installation is done as user in `workspace/user-amdoclfix` and provided software is not made available in default environment.
- The user can run `COMMAND` with built PoCL by doing `./user-pocl run [COMMAND]`, for example `./user-pocl run resolve`.

This may be needed to workaround some bugs in AMD APP when running DaVinci Resolve.


### [`user-piglit`](scripts/user-piglit)

A script to download, build and run piglit.

- The user can download build and install piglit by doing `./user-piglit build`.
- The installation is done as user in `workspace/user-piglit` and provided software is not made available in default environment.
- The user can run piglit by doing something like `./user-piglit run piglit run quick_cl /tmp/results/cl`, it can be run with platforms built with other scripts, for example: `./user-mesa run ./user-piglit run piglit run quick_cl gpu /tmp/results/cl-gpu`.


### [`user-luxmark3`](scripts/user-luxmark3)

A script to download, build and run LuxMark 3.1.

- The user can download build and install LuxMark 3.1 by doing `./user-luxmark3 build`.
- The installation is done as user in `workspace/user-luxmark3` and provided software is not made available in default environment.
- The user can run LuxMark 3.1 by doing `./user-luxmark3 run` or more complex commands like `./user-luxmark3 run luxmark --help` or like `./user-luxmark3 run gdb -args luxmark --mode=PAUSE`.

A lot of patches are applied to both LuxCore, LuxMark and SLG4 to make them more robust and more useful for OpenCL platform developers and make them good tools to debug in-development OpenCL platforms:

- Make LuxCore, LuxMark and SLG buildable again on modern Linux systems.
- Make Embree, LuxCore, LuxMark and SLG run on aarch64 platform.
- Port LuxMark 3 to Qt5.
- Fix crashes on missing OpenCL platform.
- Fix crashes on platform missing OpenCL devices.
- Fix crashes on OpenCL compilation errors.
- Fix for a division by zero that breaks ROCm and Clover when using `-cl-fast-relaxed-math`.
- Fix urls to [luxcorerender.org](https://luxcorerender.org).
- Print log to `stderr`, not only within the application.
  * This way the log can survive a crash.
  * The `stderr` log doesn't have timestamps.
- Always decode and print the OpenCL errors with their names in log.
- Also decode the `CL_PLATFORM_NOT_FOUND_KHR` error name.
- Add a bunch of environment variables to tweak the behaviour of LuxCore and LuxMark:
  * `LUXMARK_USERNAME`, `LUXMARK_PASSWORD` and `LUXMARK_NOTE` can be used to pre-fill the LuxMark submission.
  * `LUXMARK_DEVICE_TYPE_ENABLE` can be set to `gpu` to select all GPUs by default (default behaviour), `cpu` to select all CPUs by default, `all` to select everything by default, or `none` to unselect everything by default.
  * `LUXMARK_OCL_OPTIONS` allows to pass extra OpenCL compiler options to be used by LuxMark when building OpenCL kernels.  
  For example one can set `LUXMARK_OCL_OPTIONS=-cl-strict-aliasing` to enable that option that is disabled by default. The menu will not reflect the options set from the environment, but the build log will print all the used options including those set from the environment.
  * `LUXCORE_OCL_BUILD_LOG=y` enables the printing of the OpenCL build log.
  * `LUXCORE_PREFER_BVH=y` forces the usage of the BVH renderer instead of the QBVH one even if the platform provides the features required by QBVH.
  * `LUXCORE_DISABLE_IMAGE=y` forces the disablement of image support to use the non-image code path in QBVH renderer even if the platform implements image support.


### [`user-viennaclbench`](scripts/user-viennaclbench)

A script to download, build and run ViennaCLBench.

- The user can download build and install ViennaCLBench by doing `./user-viennaclbench build`.
- The installation is done as user in `workspace/user-viennaclbench` and provided software is not made available in default environment.
- The user can run LuxMark by doing `./user-viennaclbench run` or `./user-viennaclbench run ViennaCLBench`.


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
- *[Natron](https://natrongithub.github.io/)* has some OpenCL plugins, see also *[openfx-arena](https://github.com/NatronGitHub/openfx-arena)*,
- *[OBS Studio](https://obsproject.com/)*,
- *[DaVinci Resolve](https://www.blackmagicdesign.com/fr/products/davinciresolve/)*.

It is known LuxRender on an AMD Radeon R9 390X is almost twice faster on Clover with GCN hardware than on AMD-APP Legacy (Orca) or PAL or ROCr when it worked (see [#10](https://gitlab.com/illwieckz/i-love-compute/-/issues/10)), so people rendering things using this raytracer may prefer to use Clover, but it's known Clover lacks image support so photographers may want to install AMD-APP Legacy instead to run Darktable with working OpenCL using that GPU.

Software formerly providing OpenCL support:

- *[Blender](https://www.blender.org)* (old versions), verified support on AMDGPU-PRO legacy and non-legacy, OpenCL has been [deprecated](https://code.blender.org/2021/04/cycles-x/) and then removed in newer versions. Anyway, [Blender 2.83 LTS](https://www.blender.org/download/lts/2-83/) is supported until June 2022 and [Blender 2.93 LTS](https://www.blender.org/download/lts/2-93/) is supported until June 2023.


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
- *[OpenCL Toys](http://davibu.interfree.it/index.html)*, including *MandelGPU*, *MandelbulbGPU*, *SmallptGPU*, *SmallptGPU2*, *JuliaGPU*, and *SmallLuxGPU* (prefer LuxMark instead of SmallLuxGPU).

The Phoronix Test Suite also provides multiple ready-to-use [OpenCL Benchmarks](https://openbenchmarking.org/suite/pts/opencl) including LuxMark, JuliaGPU, MandelGPU, SmallptGPU, SHOC, Parboil, Rodinia, etc.


### AMD quirks

The `GPU_DEVICE_ORDINAL` environment variable can be used to whitelist some GPUs with AMD ROCr, Orca and PAL. Unfortunately, it whitelists the card (and blacklists all others) for every AMD OpenCL Driver so one cannot blacklist a GPU in ROCr to prevent a kernel breakage and get it working with another driver like Orca, so it's not possible to keep ROCr on one GPU while blacklisting another GPU on ROCr to use it with something else like Orca. See [ROCr#1624](https://github.com/RadeonOpenCompute/ROCr/issues/1624).

No one GPU driven by the `radeon` kernel driver must be present in the system to be able to use AMD Orca or PAL with others GPU driven by the `amdgpu` kernel driver. See [#2](https://gitlab.com/illwieckz/i-love-compute/-/issues/2). Unfortunately, attempts to blacklist them using `GPU_DEVICE_ORDINAL` does not work.

Orca requires an X11 server being up and running.


### Interesting projects to look at

- [CLara](https://gitlab.com/illwieckz/clara) is a project by Björn König for a framework to access OpenCL devices over the network. The project is unfortunately stalled since year 2010 and is still in alpha state. If you're an OpenCL wizard and can see the interest of such project, you're welcome to improve it!

- [compute-runtime/clgl-fork](https://github.com/kallaballa/compute-runtime/tree/clgl-fork), a fork adding `cl_khr_gl_sharing` to Intel Compute Runtime, as upstream [has not implemented it yet](https://github.com/intel/compute-runtime/issues/166).


### Frameworks

- Vulkan compatible GPU,
  - clvk, based on Google clspv  
  open, incomplete (verified).
  - PoCL, based on Google clspv
  open, incomplete (verified).
- ATI/AMD GPU,
  - Mesa Clover, LLVM libclc amdgcn,  
  open, incomplete, GCN 1.0 to 4.0 (verified), does not work with GCN 5.0 and RDNA (verified).
    * LuxRender is twice faster on Clover than on Orca, PAL and ROCr.
  - Mesa Clover, LLVM libclc r600,  
  open, incomplete, TeraScale2-3 (verified).
    * Known working version: Mesa 20.0.4, LLVM 9.0.1 (`20190827`, verified), more recent build may not work with both TeraScale 2 and 3, see [llvm/llvm-project#55679](https://github.com/llvm/llvm-project/issues/55679), upstream Clover with upstream LLVM may not be usable with TeraScale 3, see [llvm/llvm-project#54942](https://github.com/llvm/llvm-project/issues/54942).  
  - Mesa rusticl on radeonsi,  
  open, work-in-progress, GCN 1.0 to GCN 5.0 (verified), RDNA 1.0 to RDNA 2.0 (2.0 verified, 1.0 not verified).
  - AMDGPU-PRO Orca (legacy),  
  closed, complete, GCN 2.0 to 4.0 (verified). GCN 1.0 is listed but doesn't work (verified).
    * Last working version for Orca for GCN 2.0 and 3.0 (`2021-06-21`, discontinued?): [AMDGPU-PRO 21.20-1271047](https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-21-20) (verified).
  - AMDGPU-PRO PAL,  
  closed, complete, GCN5 (verified), probably RDNA (not verified).
    * Last version for PAL (`2020-09-29`, discontinued): [AMDGPU-PRO 20.40-1147286](https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-20-40) (verified), removed in favor of ROCr in Radeon Software AMDGPU-PRO without ROCr being actually an alternative.
  - ROCr,  
  open, assumed to be complete, few GCN, RDNA, CDNA, may break the whole system with some hardware (verified), replaced PAL in Radeon Software AMDGPU-PRO without being an alternative, neither in purpose, neither in hardware support, neither in implementation, neither in fullfilment.
  - fglrx AMD APP,  
  closed and requires old kernel, complete, old GPUs, the only option for TeraScale,  
  people are still [using it in 2020](https://gitlab.com/illwieckz/i-love-compute/-/issues/1#note_451460689).  
    * Last version for GCN (`2015-12-18`, discontinued): [AMD Radeon Software Crimson 15.12-15.302-151217a-297685e](https://www.amd.com/fr/support/graphics/amd-radeon-r9-series/amd-radeon-r9-300-series/amd-radeon-r9-390x) (fglrx, see _Linux x86_64_), requires Ubuntu 14.04 and 3.19 kernel (verified for GCN 1.0 and GCN 2.0).
    * Last version for TeraScale 2 to 3 (`2015-09-15`discontinued): [AMD Catalyst 15.9-15.201.1151](https://www.amd.com/fr/support/graphics/amd-radeon-hd/ati-radeon-hd-5000-series/ati-radeon-hd-5970) (fglrx, see _Linux x86_64_), requires Ubuntu 14.04 and 3.19 kernel (verified).
    * Last version for TeraScale 1 (`2013-01-21`, discontinued): [AMD Catalyst 13.1](https://www.amd.com/fr/support/graphics/amd-radeon-hd/ati-radeon-hd-4000-series/ati-radeon-hd-4890), requires Ubuntu 12.04 (not verified), only option for TeraScale 1 like Radeon HD 4890 PCIe and Radeon HD 4670 AGP (not verified).
  - mesa3d-comp-bridge,  
    open on closed code, unmaintained, was meant to run Mesa Clover over Mesa APP OpenCL compiler.
  - pocl with HSA,  
  open, early state, not tested.
- AMD CPU,
  - pocl,  
  open, verified.
  - Mesa rusticl on llvmpipe,
  early state, tested.
  - older AMDGPU-PRO or fglrx,  
  closed, complete, verified.
- Intel GPU,
  - Mesa Clover on iris.  
  open, early state, not tested,
  - Mesa rusticl on iris,  
  open, early state, work-in-progress, not tested.
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
  - Mesa rusticl on llvmpipe,
  early state, untested.
  - older AMDGPU-PRO,  
  closed, complete, verified.
  - Intel proprietary legacy SDK,  
  closed, complete, verified.
  - Intel OneAPI OpenCL,  
  open components, full openness unknown, not tested.
- Nvidia GPU,
  - Mesa Clover on nouveau.  
  open, early state, not tested,
  - Mesa rusticl on nouveau,  
  open, early state, work-in-progress, not tested.
  - libclc ptx,  
  open requiring closed component, requires an unknown frontend, incomplete, not tested.
  - Nvidia,  
  closed, complete, verified.
  - pocl with Nvidia,  
  open requiring closed component (maybe libclc ptx?), early-state, not tested.
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
- Mesa/rusticl radeonsi tracker:
  - https://gitlab.freedesktop.org/mesa/mesa/-/issues/7366
- Mesa/rusticl r600 tracker:
  - https://gitlab.freedesktop.org/mesa/mesa/-/issues/7420
- Mesa/rusticl iris tracker:
  - https://gitlab.freedesktop.org/mesa/mesa/-/issues/6311
- chipStar
  - https://github.com/CHIP-SPV/chipStar
- AMD ROCr:
  - https://github.com/RadeonOpenCompute/ROCm
- AMDGPU-PRO:
  - https://www.amd.com/en/support
- mesa3d-comp-bridge:
  - https://github.com/matszpk/mesa3d-comp-bridge
- Various Intel OpenCL:
  - https://www.intel.com/content/www/us/en/developer/articles/release-notes/intel-sdk-for-opencl-applications-release-notes.html
- Intel NEO OpenCL:
  - https://github.com/intel/compute-runtime
  - https://01.org/compute-runtime
  - https://community.intel.com/t5/OpenCL/OpenCL-GPU-driver-NEO-is-now-available-in-open-source/td-p/1145461
- Intel Beignet OpenCL:
  - https://www.freedesktop.org/wiki/Software/Beignet/
  - https://github.com/intel/beignet
- Legacy Intel OpenCL (SRB):
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

Also, having multiple frameworks may help to improve compute performance by putting everyone's hand on the desk. For example on an Haswell/Nvidia optimus laptop the best LuxMark score would be done running three OpenCL devices: the Nvidia GPU, the Intel GPU, and the Intel CPU ([example](http://luxmark.info/node/3425)), that can be done with only two frameworks but some other combinations involving three frameworks may give better score, for example if another CPU-based OpenCL implementation is faster than the Intel one.


### Compatibility and performance matrix

This is still to be done.

See how that is done on another topic (graphical rendering) for graphical framework and hardware compatibility matrix: https://wiki.unvanquished.net/wiki/GPU_compatibility_matrix

A similar thing would be good to have for OpenCL, and also to know who may own which hardware to easily reproduce reported issues.


Contribute
----------

Create issues, make pull requests, contact _Thomas Debesse_ `<dev (ad) illwieckz.net>` for more details.

You can also donate hardware, see [Hardware donations](#hardware-donations).

Contributions must be submitted under MIT or CC 0 1.0 license.
