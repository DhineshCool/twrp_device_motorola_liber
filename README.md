# TWRP Device configuration for Motorola One Fusion+

## Device specifications

Basic   | Spec Sheet
-------:|:-------------------------
CPU     | Octa-core (2x2.2 GHz Kryo 470 Gold & 6x1.8 GHz Kryo 470 Silver)
CHIPSET | Qualcomm SDM730 Snapdragon 730
GPU     | Adreno 618
Memory  | 4 / 6GB
Shipped Android Version | 10
Storage | 128GB
Battery | 5000 mAh
Dimensions | 162.9 x 76.4 x 9.6 mm
Display | 1080 x 2340 pixels, 6.5" IPS LCD
Rear Camera  | 64 MP (f/1.8, wide, PADF) + 8 MP (f/2.2, ultrawide) + 5MP (f/2.2, marcro) + 2MP (f/2.2, depth) HDR
Front Camera | 16 MP (f/2.0)

![Device Picture](https://fdn2.gsmarena.com/vv/pics/motorola/motorola-one-fusion-plus-1.jpg)

## Kernel Source

The prebuilt kernel, DTB and touch/fingerprint modules in `prebuilt/` and
`recovery/root/vendor/lib/modules/` are taken from the Cybertron v19 kernel
(`4.14.357-openela`, built for the current Android 17 LineageOS tree):

- Kernel source: https://github.com/cool585/android_kernel_motorola_sm6150 (branch `v19`)
- AnyKernel3 package: https://github.com/DhineshCool/AnyKernel3

When the installed ROM/firmware changes, regenerate these prebuilts from the
same kernel build. The old `4.14.190` kernel and its out-of-tree modules do not
boot on current firmware and must not be mixed with the v19 kernel.

## Compile

First repo init the twrp-12.1 tree (and necessary qcom dependencies):

```
mkdir ~/android/twrp-12.1
cd ~/android/twrp-12.1
repo init -u git://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
mkdir -p .repo/local_manifests
```

Then add to a local manifest (if you don't have .repo/local_manifest then make that directory and make a blank file and name it something like twrp.xml):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="osm0sis/twrp_abtemplate" path="bootable/recovery/installer" remote="github" revision="master"/>
  <project name="DhineshCool/twrp_device_motorola_liber" path="device/motorola/liber" remote="github" revision="android-12.1"/>
</manifest>
```

Now you can sync your source:

```
repo sync
```

To automatically make the TWRP installer zip, you need to import this commit in the build/make path: https://gerrit.twrp.me/c/android_build/+/5445

Finally execute these:

```sh
. build/envsetup.sh
export LC_ALL=C
lunch twrp_liber-eng
make -j4 recoveryimage
```
