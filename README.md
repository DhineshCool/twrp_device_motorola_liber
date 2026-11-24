# OrangeFox Recovery Device Tree for Motorola One Fusion+ (liber)

## Device specifications

Basic   | Spec Sheet
-------:|:-------------------------
CPU     | Octa-core (2x2.2 GHz Kryo 470 Gold & 6x1.8 GHz Kryo 470 Silver)
CHIPSET | Qualcomm SDM730 Snapdragon 730
GPU     | Adreno 618
Memory  | 4 / 6 GB
Shipped Android Version | 10
Storage | 128 GB
Battery | 5000 mAh
Dimensions | 162.9 x 76.4 x 9.6 mm
Display | 1080 x 2340 pixels, 6.5" IPS LCD (Pop-up selfie camera, notchless)
Rear Camera  | 64 MP (f/1.8, wide, PDAF) + 8 MP (f/2.2, ultrawide) + 5 MP (f/2.2, macro) + 2 MP (f/2.2, depth)
Front Camera | 16 MP (f/2.0) Pop-up motorized

![Device Picture](https://fdn2.gsmarena.com/vv/pics/motorola/motorola-one-fusion-plus-1.jpg)

## Kernel & Decryption Notes

- **Kernel:** Prebuilt Cybertron v20.5 kernel (`4.14.357-openela`) with matching DTB and DTBO, built from:
  - Source: https://github.com/cool585/android_kernel_motorola_sm6150 (branch `v20.5`)
  - In-tree drivers: Touch, display, and sensors are compiled directly into the kernel image.
- **Decryption:** Supports File-Based Encryption (FBE v2) metadata encryption with `wrappedkey_v0` on Android 12 through Android 17.
- **Keymaster:** Uses Qualcomm Keymaster 4.1 HAL service (`android.hardware.keymaster@4.1-service-qti`) with required `libspl.so` and `libspcom.so` libraries.

## Compilation (OrangeFox 12.1)

### 1. Initialize Sync Environment

```bash
mkdir ~/OrangeFox-12.1
cd ~/OrangeFox-12.1
git clone https://gitlab.com/OrangeFox/sync.git
./sync/orangefox_sync.sh --branch 12.1 --path ~/OrangeFox-12.1
```

Or initialize via minimal manifest:

```bash
repo init --depth=1 -u https://gitlab.com/OrangeFox/manifest.git -b fox_12.1
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune -j$(nproc)
```

### 2. Clone Device Tree

Clone the device tree to `device/motorola/liber`:

```bash
git clone https://github.com/DhineshCool/twrp_device_motorola_liber -b fox_12.1 device/motorola/liber
```

### 3. Build Recovery Image

```bash
source build/envsetup.sh
export FOX_BUILD_DEVICE="liber"
lunch fox_liber-eng # or: lunch twrp_liber-eng
mka recoveryimage -j$(nproc)
```

The compiled OrangeFox recovery image and flashable zip package will be available in `out/target/product/liber/`.

## Flashing Instructions

### Fastboot Boot (Temporary)
```bash
fastboot boot OrangeFox-R12.1-Unofficial-liber.img
```

### Fastboot Flash (Permanent)
Liber is an A/B device with a dedicated physical recovery partition:
```bash
fastboot flash recovery OrangeFox-R12.1-Unofficial-liber.img
fastboot reboot recovery
```
