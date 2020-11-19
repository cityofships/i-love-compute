I ♥ compute
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

- Darktable, requires image support, works with Intel proprietary (verified) and open (supposedly) framework, Nvidia proprietary (verified) framework, AMD legacy proprietary (verified) and open ROCm (supposed) framework, but not on libCLC, see [freedesktop.org/mesa/mesa#130](https://gitlab.freedesktop.org/mesa/mesa/-/issues/130).
- Blender, verified support on AMDGPU-PRO legacy and non-legacy
- LuxRender, verified support via LuxMark on libCLC r600 and GCN, AMDGPU-PRO legacy and non-legacy
- GIMP
- LibreOffice Calc

Note that all those software are known to be affected by bug [freedesktop.org/drm/amd#1193](https://gitlab.freedesktop.org/drm/amd/-/issues/1193#note_555037).

It is known LuxRender an AMD R9 390X is twice faster on libcl-amdgcn ([proof](http://luxmark.info/node/8102)) than on AMD-APP Legacy (Orca) ([proof](http://luxmark.info/node/8103)) so people rendering things using this raytracer may prefer to use libclc-amdgcn, but it's known libclc-amdgcn lacks image support so photographers may want to install AMD-APP Legacy instead to run Darktable with working OpenCL using that GPU.

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
  closed and requires old kernel, complete, old GPUs, ony option for TeraScale 1
  - pocl with HSA  
  open, early state
- AMD CPU
  - pocl  
  open, untested
  - older AMDGPU-PRO  
  closed, complete
- Intel GPU
  - Intel proprietary legacy SDK  
  closed, complete
  - Intel proprietary SDK  
  closed, complete
  - Intel open (Beignet?)  
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

- libclc: https://libclc.llvm.org/
- ROCm:
  - https://github.com/RadeonOpenCompute/ROCm
- AMDGPU-PRO:
  - https://www.amd.com/en/support
- Legacy Intel OpenCL:
  - https://software.intel.com/content/www/us/en/develop/articles/legacy-opencl-drivers.html
- PoCL:
  - http://portablecl.org
  - https://github.com/pocl/pocl


### Scripts and packages

Script to install amdgpu-pro OpenCL on Ubuntu: [ubuntu-opencl-amdgpupro](scripts/ubuntu-opencl-amdgpupro)

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

See how that is done on another topic (gaming) for graphical framework and hardware compatibility matrix: https://wiki.unvanquished.net/wiki/GPU_compatibility_matrix

A similar thing would be good to have for OpenCL, and also to know who may own which hardware to easily reproduce reported issues.