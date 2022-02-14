
.PHONY: test

RTL = $(shell find rtl -type f)
TB = $(shell find tb -type f)
SYNTH = $(shell find synth -type f)
CORE = top.core
SRC = ${RTL} ${CORE}

FST = build/ucsbieee_fpga_movie_top_1.0.0/tb-icarus/dump.fst
IMG = build/ucsbieee_fpga_movie_top_1.0.0/tb-icarus/image.png

run: ${FST}
img: ${IMG}

fusesoc.conf:
	fusesoc library add tests . --sync-type=local

${FST} ${IMG}: fusesoc.conf ${SRC} ${TB}
	fusesoc run --target tb ucsbieee:fpga_movie:top

view: fusesoc.conf ${FST}
	gtkwave ${FST} > /dev/null 2>&1 &

lint: fusesoc.conf ${SRC}
	fusesoc run --target lint ucsbieee:fpga_movie:top

synth: fusesoc.conf ${SRC} ${SYNTH}
	fusesoc run --target synth ucsbieee:fpga_movie:top

init: fusesoc.conf

clean:
	rm -rf build fusesoc.conf
