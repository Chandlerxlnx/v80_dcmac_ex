#SCRIPTS:=$(wildcard ./scripts/*.tcl)
SCRIPTS:=$(shell find ./scripts/ -name '*.tcl')

#SRC:=$(wildcard ./src/*/*)
SRC:=$(shell find ./src/ -name *.sv)
SRC+=$(shell find ./src/ -name *.xci)

PROJECT:=dcmac_0_ex/dcmac_0_ex.xpr
XSA=dcmac_0_ex_impl_top.xsa

all: $(XSA)

project: $(PROJECT)

$(PROJECT): $(SCRIPTS) $(SRC)
	vivado -mode tcl -source ./scripts/dcmac_0_ex.tcl

$(XSA): $(PROJECT)
	vivado -mode tcl -source ./scripts/run.tcl
test:
	echo $(SCRIPTS)
	echo $(SRC)
clean:
	rm *.log *.jou
cleanall:clean
	rm -rf dcmac_0_ex
