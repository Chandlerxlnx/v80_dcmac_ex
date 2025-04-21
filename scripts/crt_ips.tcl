#create 
set clk_wiz dcmac_0_clk_wiz_0
create_ip -name clk_wizard -vendor xilinx.com -library ip -module_name $clk_wiz
set_property -dict [list \
  CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
  CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
  CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
  CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
  CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
  CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
  CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {390.625,195.3125,300.000,100.000,100.000,100.000,100.000} \
  CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
  CONFIG.CLKOUT_USED {true,true,true,false,false,false,false} \
  CONFIG.OVERRIDE_PRIMITIVE {true} \
  CONFIG.PRIM_IN_FREQ {322.265625} \
  CONFIG.USE_LOCKED {true} \
  CONFIG.USE_RESET {true} \
] [get_ips $clk_wiz]


