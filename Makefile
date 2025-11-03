#SCRIPTS:=$(wildcard ./scripts/*.tcl)
#SCRIPTS:=$(shell find ./scripts/ -name '*.tcl')
SCRIPTS:=./scripts/dcmac_0_ex.tcl
SCRIPTS +=./scripts/dcmac_0_cips.tcl
SCRIPTS +=./scripts/dcmac_0_exdes_support.tcl
SCRIPTS +=./scripts/crt_ips.tcl


#SRC:=$(wildcard ./src/*/*)
SRC:=$(shell find ./src/ -name *.sv)
SRC+=$(shell find ./src/ -name *.xci)

PROJECT:=dcmac_0_ex/dcmac_0_ex.xpr
XSA=dcmac_0_ex_top.xsa
CLIB=dcmac_0_exdes_test_lib.h

all: $(XSA) $(CLIB)

project: $(PROJECT)

$(PROJECT): $(SCRIPTS) $(SRC)
	vivado -mode tcl -source ./scripts/dcmac_0_ex.tcl

$(XSA): $(PROJECT)
	vivado -mode tcl -source ./scripts/run.tcl
clib: $(CLIB)
migrate:
	cp -rf ./example/output/imports ./src
	cp -rf ./example/output/dcmac_0_exdes_support.tcl ./scripts
	
$(CLIB): $(XSA) $(SCRIPTS)
	./scripts/gen_sample_clib.sh
.PHONY: clean cleanall project test all
test:
	echo $(SCRIPTS)
	echo $(SRC)
clean:
	@rm -rf *.log *.jou
cleanall: clean
	@rm -rf $(CLIB) $(XSA)
	@rm -rf dcmac_0_ex
	@rm *.pdi *.xsa *.mmi
