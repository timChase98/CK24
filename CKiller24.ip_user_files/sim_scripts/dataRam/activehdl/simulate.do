onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+dataRam -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.dataRam xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {dataRam.udo}

run -all

endsim

quit -force
