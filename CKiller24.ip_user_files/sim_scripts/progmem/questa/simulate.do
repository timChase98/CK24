onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib progmem_opt

do {wave.do}

view wave
view structure
view signals

do {progmem.udo}

run -all

quit -force
