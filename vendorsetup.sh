#!/bin/bash
#
# Copyright (C) 2026 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

FDEVICE="liber"

fox_get_target_device() {
    local chkdev=$(echo "$BASH_SOURCE" | grep -w "$FDEVICE")
    if [ -n "$chkdev" ]; then
        FOX_BUILD_DEVICE="$FDEVICE"
    else
        chkdev=$(set | grep BASH_ARGV | grep -w "$FDEVICE")
        [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
    fi
    if [ -z "$FOX_BUILD_DEVICE" ] && echo "$PWD" | grep -q "$FDEVICE"; then
        FOX_BUILD_DEVICE="$FDEVICE"
    fi
}

if [ -z "$1" ] && [ -z "$FOX_BUILD_DEVICE" ]; then
    fox_get_target_device
fi

if [ "$1" = "$FDEVICE" ] || [ "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
    export FOX_BUILD_DEVICE="liber"
    export OF_MAINTAINER="DhineshCool"
    export FOX_VERSION="R12.1_0"
    export FOX_BUILD_TYPE="Unofficial"

    # Target device aliases
    export FOX_TARGET_DEVICES="liber,liber_retail"
    export OF_TARGET_DEVICES="liber,liber_retail"
    export TARGET_DEVICE_ALT="liber_retail"

    # Screen & Display (1080x2340, 19.5:9, full pop-up screen without notch)
    export OF_SCREEN_H=2340
    export OF_STATUS_H=80
    export OF_STATUS_INDENT_LEFT=48
    export OF_STATUS_INDENT_RIGHT=48
    export OF_CLOCK_POS=1
    export OF_ALLOW_DISABLE_NAVBAR=1

    # Flashlight & LEDs
    export OF_FLASHLIGHT_ENABLE=1
    export OF_FL_PATH1="/sys/class/leds/led:torch_0"
    export OF_USE_GREEN_LED=0

    # A/B & Recovery partition configuration
    export FOX_AB_DEVICE=1
    export OF_AB_DEVICE=1
    export OF_AB_DEVICE_WITH_RECOVERY_PARTITION=1
    export FOX_RECOVERY_INSTALL_PARTITION="/dev/block/bootdevice/by-name/recovery"

    # Dynamic Partitions (super partition size = 9729736704 bytes)
    export FOX_USE_DYNAMIC_PARTITIONS=1
    export OF_DYNAMIC_FULL_SIZE=9729736704

    # Magisk & Decryption
    export OF_USE_MAGISKBOOT=1
    export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
    export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
    export OF_DEFAULT_KEYMASTER_VERSION="4.1"
    export OF_KEEP_DM_VERITY=1

    # Binaries & Shell
    export FOX_USE_BASH_SHELL=1
    export FOX_ASH_IS_BASH=1
    export FOX_USE_NANO_EDITOR=1
    export FOX_USE_TAR_BINARY=1
    export FOX_USE_SED_BINARY=1
    export FOX_USE_XZ_UTILS=1

    # Features & Addons
    export FOX_ENABLE_APP_MANAGER=1
    export FOX_DELETE_AROMAFM=1

    # Quick backup list
    export OF_QUICK_BACKUP_LIST="/boot;/data;"

    # Build flags
    export ALLOW_MISSING_DEPENDENCIES=true
    export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1

    # Register lunch combos if supported
    if type add_lunch_combo >/dev/null 2>&1; then
        add_lunch_combo twrp_liber-eng
        add_lunch_combo fox_liber-eng
    fi
fi
