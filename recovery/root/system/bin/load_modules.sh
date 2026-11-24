#!/system/bin/sh

module_path=/vendor/lib/modules
firmware_path=/vendor/firmware
touch_class_path=/sys/class/touchscreen
firmware_file=focaltech-ft8756-0d-0000-liber.bin

wait_for_poweron()
{
	local wait_nomore=10
	local count=0
	while true; do
		readiness=$(cat "$touch_path/poweron" 2>/dev/null)
		if [ "$readiness" = "1" ]; then
			break
		fi
		count=$((count+1))
		[ $count -eq $wait_nomore ] && break
		sleep 1
	done
	if [ $count -eq $wait_nomore ]; then
		return 1
	fi
	return 0
}

# Load optional modules (most liber drivers are built into the kernel)
for module in fpc1020_mmi.ko fpsensor_spi_tee.ko; do
	[ -f "$module_path/$module" ] && insmod "$module_path/$module" 2>/dev/null
done

# Reflash the touch controller firmware when the driver exposes the sysfs nodes
if [ -d "$touch_class_path" ] && [ -d "$firmware_path" ]; then
	touch_product_string=$(ls "$touch_class_path" 2>/dev/null | head -n 1)
	if [ -n "$touch_product_string" ] && [ -f "$touch_class_path/$touch_product_string/path" ]; then
		touch_path=/sys$(cat "$touch_class_path/$touch_product_string/path" | awk '{print $1}')
		if [ -d "$touch_path" ] && [ -f "$firmware_path/$firmware_file" ]; then
			wait_for_poweron
			echo "$firmware_file" > "$touch_path/doreflash" 2>/dev/null
			echo 1 > "$touch_path/forcereflash" 2>/dev/null
			sleep 5
			echo 1 > "$touch_path/reset" 2>/dev/null
		fi
	fi
fi

exit 0
