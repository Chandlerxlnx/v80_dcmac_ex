DCMAC_EX_PRJ=dcmac_0_ex/dcmac_0_ex.xpr
SCRIPT_OUT=./output/dcmac_0_exdes_support.tcl
XDC_OUT=dcmac_0_example_top.xdc

./output:
	mkdir -p ./output
cp_output: ./output/dcmac_ex.md
	
./output/dcmac_ex.md: ./dcmac_0_ex/imports/$(XDC_OUT) 
	cp -rf ./dcmac_0_ex/imports ./output
	#mv crt_dcmac_0_exdes_support.tcl ./output
	date|tee ./output/dcmac_ex.md

all:  ./output/dcmac_ex.md

v80_eco:dcmac_0_ex/imports/dcmac_0_example_top.xdc

dcmac_0_ex/imports/$(XDC_OUT): $(SCRIPT_OUT)
	sed -i '/gt_ref_clk1_/s/^/\/\//g' dcmac_0_ex/imports/*.sv
	sed -i '/gt_ref_clk1_/s/^/#/g' dcmac_0_ex/imports/*.xdc

${DCMAC_EX_PRJ}: ./output
	vivado -mode tcl -source ./scripts/create_dcmac_ex.tcl
$(SCRIPT_OUT):$(DCMAC_EX_PRJ)
	vivado -mode tcl -source ./scripts/eco_exdes_4v80.tcl
proj: ${DCMAC_EX_PRJ}

clean:
	@rm -rf vivado*
cleanall: clean
	@rm -rf proj_dcmac
	@rm -rf dcmac_0_ex
	@rm -rf ./output
.PHONY: clean cleanall
