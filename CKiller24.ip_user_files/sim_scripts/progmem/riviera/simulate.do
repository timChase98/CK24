onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+progmem -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.progmem xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {progmem.udo}

run -all

endsim

quit -force
