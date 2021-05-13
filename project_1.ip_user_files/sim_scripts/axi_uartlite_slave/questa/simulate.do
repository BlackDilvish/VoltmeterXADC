onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib axi_uartlite_slave_opt

do {wave.do}

view wave
view structure
view signals

do {axi_uartlite_slave.udo}

run -all

quit -force
