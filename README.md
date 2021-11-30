I ♥ Compute
===========

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

Examples
--------

### Productivity software

- Darktable, requires image support, works with Intel proprietary (verified) and open (supposedly) framework, Nvidia proprietary (verified) framework, AMD legacy proprietary (verified) and open ROCm (supposed) framework, but not on Clover/libCLC, see [#1](https://gitlab.com/illwieckz/i-love-compute/-/issues/1) (missing image support).
- Blender, verified support on AMDGPU-PRO legacy and non-legacy
- LuxRender, verified support via LuxMark on libCLC r600 and GCN, AMDGPU-PRO legacy and non-legacy
- GIMP
- LibreOffice Calc

Note that all those software are known to be affected by bug [#2](https://gitlab.com/illwieckz/i-love-compute/-/issues/2) (_having a GPU using the radeon driver alongside a GPU using the amdgpu driver makes OpenCL applications unable to run at all_).

It is known LuxRender an AMD R9 390X is almost twice faster on libcl-amdgcn than on AMD-APP Legacy (Orca) or ROCm when it worked (see [#10](https://gitlab.com/illwieckz/i-love-compute/-/issues/10)), so people rendering things using this raytracer may prefer to use libclc-amdgcn, but it's known libclc-amdgcn lacks image support so photographers may want to install AMD-APP Legacy instead to run Darktable with working OpenCL using that GPU.

### Frameworks

- ATI/AMD GPU
  - libclc r600  
  open, incomplete, TeraScale2+
  - libclc amdgcn  
  open, incomplete, GCN, RDNA
  - AMDGPU-PRO Orca (legacy)  
  closed, complete, GCN 1+
  - AMDGPU-PRO PAL  
  closed, complete, GCN 3+?, RDNA?
  - ROCm  
  open, complete, select of GCN3+, RDNA, CDNA
  - fglrx AMD APP  
  closed and requires old kernel, complete, old GPUs, only option for TeraScale 1  ,
  people are still [using it in 2020](https://gitlab.com/illwieckz/i-love-compute/-/issues/1#note_451460689)
  - pocl with HSA  
  open, early state
- AMD CPU
  - pocl  
  open, untested
  - older AMDGPU-PRO  
  closed, complete
- Intel GPU
  - Intel proprietary legacy SDK (SRB4, SRB4.1)  
  closed, complete
  - Intel proprietary classic SDK (SRB5)  
  closed, complete
  - Intel open (NEO)  
  open, complete
  - Intel open (Beignet)  
  open, complete
- Intel CPU
  - pocl  
  open, untested
  - older AMDGPU-PRO  
  closed, complete
  - Intel proprietary legacy SDK  
  closed, complete
- Nvidia GPU
  - libclc nouveau  
  open, early state
  - libclc ptx  
  open requiring closed component, incomplete
  - Nvidia  
  closed, complete
  - pocl with Nvidia  
  open requiring closed component, early-state

### Links

- libclc:
  - https://libclc.llvm.org/
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
- PoCL:
  - http://portablecl.org
  - https://github.com/pocl/pocl


### Scripts and packages

Script to install amdgpu-pro OpenCL on Ubuntu: [ubuntu-opencl-amdgpu](scripts/ubuntu-opencl-amdgpu)

Script to install amdgpu-pro OpenCL on unsupported Ubuntu using supported Ubuntu packages: https://github.com/RadeonOpenCompute/ROCm/issues/484#issuecomment-554738964

Script to install amdgpu-pro OpenCL on unsupported Mageia using supported Red-Hat packages: INCOMING

Arch linux AUR packages: https://wiki.archlinux.org/index.php/GPGPU

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

Having multiple OpenCL frameworks installed at the same time is useful because an implementation may be known to be faster for a given task but incomplete for another. It's also easier for testing.

This is very similar to what happens on gaming side where some apps would work well with `radv` but others would require `amdvlk`, both being installable at the same time.

Also, having multiple frameworks may help to improve compute performance by putting everyone's hand on the desk. For example on that laptop the best LuxMark score would be done running three OpenCL devices: the Nvidia GPU, the Intel GPU, and the Intel CPU ([example](http://luxmark.info/node/3425)), that can be done with only two frameworks but some other combinations involving three frameworks may give better score.

### Compatibility and performance matrix

See how that is done on another topic (graphical rendering) for graphical framework and hardware compatibility matrix: https://wiki.unvanquished.net/wiki/GPU_compatibility_matrix

A similar thing would be good to have for OpenCL, and also to know who may own which hardware to easily reproduce reported issues.
