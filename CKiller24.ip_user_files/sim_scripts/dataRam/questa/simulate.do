onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib dataRam_opt

do {wave.do}

view wave
view structure
view signals

do {dataRam.udo}

run -all

quit -force
