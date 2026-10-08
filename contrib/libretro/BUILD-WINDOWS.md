# Windows x86-64 core

Use an MSYS2 UCRT64 shell. Install these build dependencies:

```
pacman -S --needed git make diffutils mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-meson mingw-w64-ucrt-x86_64-ninja mingw-w64-ucrt-x86_64-pkgconf mingw-w64-ucrt-x86_64-glib2 mingw-w64-ucrt-x86_64-libepoxy mingw-w64-ucrt-x86_64-sdl3 mingw-w64-ucrt-x86_64-curl mingw-w64-ucrt-x86_64-libusb mingw-w64-ucrt-x86_64-glslang mingw-w64-ucrt-x86_64-spirv-tools mingw-w64-ucrt-x86_64-vulkan-headers mingw-w64-ucrt-x86_64-zlib mingw-w64-ucrt-x86_64-pixman mingw-w64-ucrt-x86_64-libsamplerate mingw-w64-ucrt-x86_64-python-yaml
bash contrib/libretro/build-windows.sh
```

The release source archive includes the modified core and downloaded Meson
subprojects. The package-version manifest records the release build environment.
MSYS2 dependency sources and packaging recipes are available through
https://github.com/msys2/MINGW-packages and https://packages.msys2.org/.
Preserve each component's license when redistributing.

The DLL retains debug symbols, with optimization level 2. It imports only Windows
system libraries. A compatible Libretro frontend, legal BIOS files and game
content are required; none of those files are included in the release.

Linux binaries need a Linux toolchain. This Windows script does not generate a
Linux shared object. No Linux runtime validation is claimed for this release.
