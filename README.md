# BigTreeTech E3 RRF V1.1

> **USE THIS FIRMWARE AT YOUR OWN PERIL**
>
> Make sure to watch
> [this](https://www.youtube.com/watch?v=VK_K6fp4BIk) and
> [this](https://www.youtube.com/watch?v=ckQ9UWlmdVA).
>
> If you're having issues updating your E3 RRF V1.1 firmware, try reformatting your SD card.
>
> If you're seeing unexpected behavior, please try resetting the Configuration to defaults.

## Reference platform

- [Creality Ender 3 Pro](https://www.creality.com/creality-ender-3-pro-3d-printer-p00251p1.html)
- [BigTreeTech E3 RRF v1.1](https://github.com/bigtreetech/BTT-E3-RRF)
- [ANTCLABS BLTouch SMART 3.1 with the Creality metal mounting bracket](https://www.antclabs.com/bltouch-v3)
- [Micro Swiss All Metal Hotend](https://store.micro-swiss.com/products/all-metal-hotend-kit-for-cr-10)
- [Micro Swiss MK8 Plated Wear Resistant Nozzle](https://store.micro-swiss.com/collections/nozzles/products/mk8)
- [TriangleLab Dual Drive Extruder Mini BMG](https://nl.aliexpress.com/item/33029933418.html)
- [Ender 3 EZ Vent Remix (via Shapeways)](https://www.thingiverse.com/thing:3864519)
- [FlexPlate PEI Print Surface](https://primacreator.com/products/primacreator-flexplate-pei)
- [TR8x2 Z-axis leadscrew]()
- [Generic Translucent White PTFE ID2.0 Tubing]()

## BLTouch (__REQUIRED__)

**CRITICAL:** The BLTouch bed levelling sensor should be connected to the `PROBE` (and `SERVO`) headers,
and triple check the actual pinouts before powering on the board.

**CRITICAL:** The BLTouch trigger pins need to be connected to the `Z-STOP` header.

**INFO:** The precompiled firmware.bin presumes the use of Creality's official metal mounting bracket,
resulting in sensor-to-nozzle offsets of roughly -43mm, -5mm, -2mm (X, Y, Z).

**INFO:** High Speed mode is enabled, therefore a BLTouch SMART 3.0 or higher may be required, and
compatibility with clone sensors may be reduced.

**INFO:** During print relative Babystepping is now regular absolute Z-Offset, which should making
dialing in the Z-Offset much easier.

**TIP:** The precompiled firmware.bin was tested using a genuine BLTouch SMART 3.1, if you are
getting inconsistent behavior, try adjusting the magnet inside the BLTouch using the hexnut
located in device's top center. Turning the hexnut 90 degrees clockwise fixed it for me.

## Marlin Important Notes

**CRITICAL:** The main tested firmware build is now configured for a Mini BMG extruder,
which required reversing of the extruder direction and with
E-axis Microstepping has been increased to 32 (resulting in 280 steps/mm)

**CRITICAL:** X/Y-axis Microstepping has been increased to 32 (resulting in 160 steps/mm).

**CRITICAL:** Z-axis leadscrew has been upgraded to TR8x2 and
Z-axis Microstepping has been decreased to 8 (resulting in 800 steps/mm).

**CRITICAL:** Extended Y-axis range (12mm beyond bed) is used to increase automated bed levelling
coverage, and compatibility with third party hot-end shrouds may be reduced.

**WARNING:** `Z_MAX_POS` has been limited to 240.

The status screen update rate has been increased to make it slightly more responsive.

The status screen flow rate deadzone has been increased, so it's more difficult to
accidentally trigger flow rate changes from the status screen.

Linear Advance is enabled and active by default.

S-Curve acceleration is disabled.

Junction deviation has been reverted to traditional Jerk.

Supports remaining times, if enabled in your slicer software
([`M73`](http://marlinfw.org/docs/gcode/M073.html) G-code).

Nozzle Park is builtin
(you can use [`G27 P2`](http://marlinfw.org/docs/gcode/G027.html) in your print end G-code).

Load/Unload Filament is builtin.
([`M702`](http://marlinfw.org/docs/gcode/M702.html) G-code).

Advanced Pause Feature is builtin, but is as of yet _untested_.
([`M600`](http://marlinfw.org/docs/gcode/M600.html) G-code).

Filament Runout Sensor is builtin, but is as of yet _untested_ and _disabled by default_
([`M412 S1`](http://marlinfw.org/docs/gcode/M412.html) G-code).

Power Loss Recovery is builtin, but is as of yet _untested_ and _disabled by default_
([`M413 S1`](http://marlinfw.org/docs/gcode/M413.html) G-code).

Maximum hot-end temperature has been limited to 250C for increased safety.

Maximum heated-bed temperature has been limited to 100C for increased safety.

The heated-bed check interval has been lowered to 1000ms for a more consistent bed temperature.

Maximum filename length has been increased.

Hotend is listed as E0 (as opposed to E1) to match Marlin source configuration files.

PID tuning initiated via the menu does 9 cycles as opposed to merely 5, so it will take longer.

## ESP3D Important Notes

The included ESP3D build is intentionally minimal, it only supports serial-over-TCP
(somewhat erroneously called Telnet) and does not connect to WiFi by default.

It can be activated via WiFi Tools (in the Configuration menu), 

* SSID: `Ender-3`
* Pass: `31415926` (first eight digits of [Pi](https://en.wikipedia.org/wiki/Pi))

## Initial Setup

After flashing the appropriate compiled firmware.bin, if desired, you should (re-)calibrate 
your extruder (E-steps) first.

Then run Hotend PID tuning.

Next do a _bed level corners_, using a ~200gsm (~0.25mm) thick piece of paper.

Finally, attempt a trivial print, lowering the Z-Offset until you get good
bed adhesion, in my particular case I ended up somewhere around -2.00mm
(this is somewhat affected by nozzle wear).

## PrusaSlicer Printer Settings

* Select 'Ender-3 BLTouch' from the Configuration Wizard in PrusaSlicer 2.3+
* Change Max print height: 240
* Change Supports remaining times: ENABLE
* Change Pause Print G-code to: M125 P1

## Using The Build Scripts

The build script has been tested on Xubuntu 20.04 LTS, some examples:

```
sudo apt-get install git python3-venv
bash btt_e3_rrf_marlin_build.sh
bash btt_e3_rrf_esp3d_build.sh
```
