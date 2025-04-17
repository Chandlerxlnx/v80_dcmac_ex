
################################################################
# This is a generated script based on design: dcmac_0_cips
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_gid_msg -ssname BD::TCL -id 2040 -severity "CRITICAL WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been changes to the IP between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the functionality and configuration of the design."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source dcmac_0_cips_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcv80-lsva4737-2MHP-e-S
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name dcmac_0_cips

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_apb_bridge:*\
xilinx.com:ip:proc_sys_reset:*\
xilinx.com:ip:smartconnect:*\
xilinx.com:ip:axi_gpio:*\
xilinx.com:ip:xlslice:*\
xilinx.com:ip:versal_cips:*\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set APB_M2_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:apb_rtl:1.0 APB_M2_0 ]

  set APB_M3_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:apb_rtl:1.0 APB_M3_0 ]

  set APB_M_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:apb_rtl:1.0 APB_M_0 ]

  set M00_AXI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_0

  set M00_AXI_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_1

  set M00_AXI_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_2 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_2

  set M00_AXI_3 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_3 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_3

  set M00_AXI_4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_4 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_4

  set M00_AXI_5 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_5 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_5

  set M00_AXI_6 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI_6 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {32} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_BURST {0} \
   CONFIG.HAS_CACHE {0} \
   CONFIG.HAS_LOCK {0} \
   CONFIG.HAS_QOS {0} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.PROTOCOL {AXI4LITE} \
   ] $M00_AXI_6


  # Create ports
  set gt_reset_all_in [ create_bd_port -dir O -from 0 -to 0 -type rst gt_reset_all_in ]
  set gt_line_rate [ create_bd_port -dir O -from 7 -to 0 -type data gt_line_rate ]
  set gt_loopback [ create_bd_port -dir O -from 2 -to 0 -type data gt_loopback ]
  set gt_txprecursor [ create_bd_port -dir O -from 5 -to 0 -type data gt_txprecursor ]
  set gt_txpostcursor [ create_bd_port -dir O -from 5 -to 0 -type data gt_txpostcursor ]
  set gt_txmaincursor [ create_bd_port -dir O -from 6 -to 0 -type data gt_txmaincursor ]
  set gt_reset_rx_datapath_in [ create_bd_port -dir O -from 23 -to 0 gt_reset_rx_datapath_in ]
  set gt_reset_tx_datapath_in [ create_bd_port -dir O -from 23 -to 0 gt_reset_tx_datapath_in ]
  set tx_serdes_reset [ create_bd_port -dir O -from 5 -to 0 tx_serdes_reset ]
  set rx_serdes_reset [ create_bd_port -dir O -from 5 -to 0 rx_serdes_reset ]
  set tx_core_reset [ create_bd_port -dir O -from 0 -to 0 tx_core_reset ]
  set rx_core_reset [ create_bd_port -dir O -from 0 -to 0 rx_core_reset ]
  set gt_tx_reset_done [ create_bd_port -dir I -from 23 -to 0 gt_tx_reset_done ]
  set gt_rx_reset_done [ create_bd_port -dir I -from 23 -to 0 gt_rx_reset_done ]
  set gt_rxcdrhold [ create_bd_port -dir O -from 0 -to 0 -type data gt_rxcdrhold ]
  set pl0_ref_clk_0 [ create_bd_port -dir O -type clk pl0_ref_clk_0 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI_0:M00_AXI_1:M00_AXI_2:M00_AXI_3:M00_AXI_4:M00_AXI_5:M00_AXI_6} \
   CONFIG.ASSOCIATED_RESET {pl0_resetn_0} \
 ] $pl0_ref_clk_0
  set pl0_resetn_0 [ create_bd_port -dir O -from 0 -to 0 -type rst pl0_resetn_0 ]

  # Create instance: axi_apb_bridge_0, and set properties
  set axi_apb_bridge_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_apb_bridge axi_apb_bridge_0 ]
  set_property CONFIG.C_APB_NUM_SLAVES {3} $axi_apb_bridge_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_MI {13} \
    CONFIG.NUM_SI {1} \
  ] $smartconnect_0


  # Create instance: axi_gpio_tx_datapath, and set properties
  set axi_gpio_tx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_tx_datapath ]
  set_property CONFIG.C_ALL_OUTPUTS {1} $axi_gpio_tx_datapath


  # Create instance: axi_gpio_rx_datapath, and set properties
  set axi_gpio_rx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_rx_datapath ]
  set_property CONFIG.C_ALL_OUTPUTS {1} $axi_gpio_rx_datapath


  # Create instance: axi_resets_dyn, and set properties
  set axi_resets_dyn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_resets_dyn ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {14} \
  ] $axi_resets_dyn


  # Create instance: axi_reset_done_dyn, and set properties
  set axi_reset_done_dyn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_reset_done_dyn ]
  set_property -dict [list \
    CONFIG.C_ALL_INPUTS {1} \
    CONFIG.C_ALL_INPUTS_2 {1} \
    CONFIG.C_GPIO2_WIDTH {24} \
    CONFIG.C_GPIO_WIDTH {24} \
    CONFIG.C_IS_DUAL {1} \
  ] $axi_reset_done_dyn


  # Create instance: axi_gpio_gt_ctl, and set properties
  set axi_gpio_gt_ctl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio axi_gpio_gt_ctl ]
  set_property CONFIG.C_ALL_OUTPUTS {1} $axi_gpio_gt_ctl


  # Create instance: xlslice_gt_reset, and set properties
  set xlslice_gt_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_reset ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_reset


  # Create instance: xlslice_gt_line_rate, and set properties
  set xlslice_gt_line_rate [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_line_rate ]
  set_property -dict [list \
    CONFIG.DIN_FROM {8} \
    CONFIG.DIN_TO {1} \
    CONFIG.DOUT_WIDTH {8} \
  ] $xlslice_gt_line_rate


  # Create instance: xlslice_gt_loopback, and set properties
  set xlslice_gt_loopback [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_loopback ]
  set_property -dict [list \
    CONFIG.DIN_FROM {11} \
    CONFIG.DIN_TO {9} \
    CONFIG.DOUT_WIDTH {3} \
  ] $xlslice_gt_loopback


  # Create instance: xlslice_gt_txprecursor, and set properties
  set xlslice_gt_txprecursor [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_txprecursor ]
  set_property -dict [list \
    CONFIG.DIN_FROM {17} \
    CONFIG.DIN_TO {12} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_gt_txprecursor


  # Create instance: xlslice_gt_txpostcursor, and set properties
  set xlslice_gt_txpostcursor [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_txpostcursor ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DIN_TO {18} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_gt_txpostcursor


  # Create instance: xlslice_gt_txmaincursor, and set properties
  set xlslice_gt_txmaincursor [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_txmaincursor ]
  set_property -dict [list \
    CONFIG.DIN_FROM {30} \
    CONFIG.DIN_TO {24} \
    CONFIG.DOUT_WIDTH {7} \
  ] $xlslice_gt_txmaincursor


  # Create instance: xlslice_gt_rxcdrhold, and set properties
  set xlslice_gt_rxcdrhold [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_gt_rxcdrhold ]
  set_property -dict [list \
    CONFIG.DIN_FROM {31} \
    CONFIG.DIN_TO {31} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_gt_rxcdrhold


  # Create instance: xlslice_tx_serdes_rst, and set properties
  set xlslice_tx_serdes_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_serdes_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {7} \
    CONFIG.DIN_TO {2} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_tx_serdes_rst


  # Create instance: xlslice_rx_serdes_rst, and set properties
  set xlslice_rx_serdes_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_rx_serdes_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {13} \
    CONFIG.DIN_TO {8} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {6} \
  ] $xlslice_rx_serdes_rst


  # Create instance: xlslice_tx_core_rst, and set properties
  set xlslice_tx_core_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_core_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {0} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_tx_core_rst


  # Create instance: xlslice_rx_core_rst, and set properties
  set xlslice_rx_core_rst [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_rx_core_rst ]
  set_property -dict [list \
    CONFIG.DIN_FROM {1} \
    CONFIG.DIN_TO {1} \
    CONFIG.DIN_WIDTH {14} \
    CONFIG.DOUT_WIDTH {1} \
  ] $xlslice_rx_core_rst


  # Create instance: xlslice_tx_datapath, and set properties
  set xlslice_tx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_tx_datapath ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DOUT_WIDTH {24} \
  ] $xlslice_tx_datapath


  # Create instance: xlslice_rx_datapath, and set properties
  set xlslice_rx_datapath [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_rx_datapath ]
  set_property -dict [list \
    CONFIG.DIN_FROM {23} \
    CONFIG.DOUT_WIDTH {24} \
  ] $xlslice_rx_datapath


  # Create instance: cips, and set properties
  set cips [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips cips ]
  set_property -dict [list \
    CONFIG.PS_PMC_CONFIG { \
      BOOT_MODE {Custom} \
      CLOCK_MODE {Custom} \
      DDR_MEMORY_MODE {Custom} \
      DESIGN_MODE {1} \
      DEVICE_INTEGRITY_MODE {Custom} \
      IO_CONFIG_MODE {Custom} \
      PCIE_APERTURES_DUAL_ENABLE {0} \
      PCIE_APERTURES_SINGLE_ENABLE {1} \
      PMC_BANK_1_IO_STANDARD {LVCMOS3.3} \
      PMC_CRP_OSPI_REF_CTRL_FREQMHZ {200} \
      PMC_CRP_PL0_REF_CTRL_FREQMHZ {100} \
      PMC_CRP_PL1_REF_CTRL_FREQMHZ {33.3333333} \
      PMC_CRP_PL2_REF_CTRL_FREQMHZ {250} \
      PMC_GLITCH_CONFIG {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE CUSTOM} {VCC_PMC_VALUE 0.88}} \
      PMC_GLITCH_CONFIG_1 {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE CUSTOM} {VCC_PMC_VALUE 0.88}} \
      PMC_GLITCH_CONFIG_2 {{DEPTH_SENSITIVITY 1} {MIN_PULSE_WIDTH 0.5} {TYPE CUSTOM} {VCC_PMC_VALUE 0.88}} \
      PMC_GPIO_EMIO_PERIPHERAL_ENABLE {0} \
      PMC_MIO11 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO12 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO13 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PMC_MIO17 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO26 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO27 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO28 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO29 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO30 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO31 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO32 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO33 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO34 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO35 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO36 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO37 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO38 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO39 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO40 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO41 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO42 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO43 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO44 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO48 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO49 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO50 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO51 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PMC_MIO_EN_FOR_PL_PCIE {0} \
      PMC_OSPI_PERIPHERAL {{ENABLE 1} {IO {PMC_MIO 0 .. 11}} {MODE Single}} \
      PMC_REF_CLK_FREQMHZ {33.333333} \
      PMC_SD0_DATA_TRANSFER_MODE {8Bit} \
      PMC_SD0_PERIPHERAL {{CLK_100_SDR_OTAP_DLY 0x00} {CLK_200_SDR_OTAP_DLY 0x2} {CLK_50_DDR_ITAP_DLY 0x1E} {CLK_50_DDR_OTAP_DLY 0x5} {CLK_50_SDR_ITAP_DLY 0x2C} {CLK_50_SDR_OTAP_DLY 0x5} {ENABLE 1} {IO\
{PMC_MIO 13 .. 25}}} \
      PMC_SD0_SLOT_TYPE {eMMC} \
      PMC_USE_PMC_NOC_AXI0 {1} \
      PS_BANK_2_IO_STANDARD {LVCMOS3.3} \
      PS_BOARD_INTERFACE {Custom} \
      PS_CRL_CPM_TOPSW_REF_CTRL_FREQMHZ {1000} \
      PS_GEN_IPI0_ENABLE {0} \
      PS_GEN_IPI1_ENABLE {0} \
      PS_GEN_IPI2_ENABLE {0} \
      PS_GEN_IPI3_ENABLE {1} \
      PS_GEN_IPI3_MASTER {R5_0} \
      PS_GEN_IPI4_ENABLE {1} \
      PS_GEN_IPI4_MASTER {R5_0} \
      PS_GEN_IPI5_ENABLE {1} \
      PS_GEN_IPI5_MASTER {R5_1} \
      PS_GEN_IPI6_ENABLE {1} \
      PS_GEN_IPI6_MASTER {R5_1} \
      PS_GPIO_EMIO_PERIPHERAL_ENABLE {0} \
      PS_I2C0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 2 .. 3}}} \
      PS_I2C1_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 0 .. 1}}} \
      PS_IRQ_USAGE {{CH0 1} {CH1 1} {CH10 0} {CH11 0} {CH12 0} {CH13 0} {CH14 0} {CH15 0} {CH2 0} {CH3 0} {CH4 0} {CH5 0} {CH6 0} {CH7 0} {CH8 0} {CH9 0}} \
      PS_KAT_ENABLE {0} \
      PS_KAT_ENABLE_1 {0} \
      PS_KAT_ENABLE_2 {0} \
      PS_MIO10 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO11 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO12 {{AUX_IO 0} {DIRECTION inout} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO13 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO14 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO18 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO19 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO22 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO23 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO24 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO25 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO4 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO5 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO6 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO7 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE GPIO}} \
      PS_MIO8 {{AUX_IO 0} {DIRECTION in} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 0} {SLEW slow} {USAGE Reserved}} \
      PS_MIO9 {{AUX_IO 0} {DIRECTION out} {DRIVE_STRENGTH 8mA} {OUTPUT_DATA default} {PULL pullup} {SCHMITT 1} {SLEW slow} {USAGE Reserved}} \
      PS_M_AXI_LPD_DATA_WIDTH {32} \
      PS_NUM_FABRIC_RESETS {1} \
      PS_PCIE1_PERIPHERAL_ENABLE {0} \
      PS_PCIE2_PERIPHERAL_ENABLE {1} \
      PS_PCIE_EP_RESET1_IO {PMC_MIO 24} \
      PS_PCIE_EP_RESET2_IO {PMC_MIO 25} \
      PS_PCIE_RESET {ENABLE 1} \
      PS_PL_CONNECTIVITY_MODE {Custom} \
      PS_SPI0 {{GRP_SS0_ENABLE 1} {GRP_SS0_IO {PS_MIO 15}} {GRP_SS1_ENABLE 0} {GRP_SS1_IO {PMC_MIO 14}} {GRP_SS2_ENABLE 0} {GRP_SS2_IO {PMC_MIO 13}} {PERIPHERAL_ENABLE 1} {PERIPHERAL_IO {PS_MIO 12 .. 17}}}\
\
      PS_SPI1 {{GRP_SS0_ENABLE 0} {GRP_SS0_IO {PS_MIO 9}} {GRP_SS1_ENABLE 0} {GRP_SS1_IO {PS_MIO 8}} {GRP_SS2_ENABLE 0} {GRP_SS2_IO {PS_MIO 7}} {PERIPHERAL_ENABLE 0} {PERIPHERAL_IO {PS_MIO 6 .. 11}}} \
      PS_TTC0_PERIPHERAL_ENABLE {1} \
      PS_TTC1_PERIPHERAL_ENABLE {1} \
      PS_TTC2_PERIPHERAL_ENABLE {1} \
      PS_TTC3_PERIPHERAL_ENABLE {1} \
      PS_UART0_BAUD_RATE {115200} \
      PS_UART0_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 8 .. 9}}} \
      PS_UART0_RTS_CTS {{ENABLE 0} {IO {PS_MIO 2 .. 3}}} \
      PS_UART1_PERIPHERAL {{ENABLE 1} {IO {PS_MIO 20 .. 21}}} \
      PS_USE_FPD_CCI_NOC {0} \
      PS_USE_M_AXI_FPD {0} \
      PS_USE_M_AXI_LPD {1} \
      PS_USE_NOC_LPD_AXI0 {1} \
      PS_USE_PMCPL_CLK0 {1} \
      PS_USE_PMCPL_CLK1 {1} \
      PS_USE_PMCPL_CLK2 {1} \
      PS_USE_S_AXI_LPD {0} \
      SMON_ALARMS {Set_Alarms_On} \
      SMON_ENABLE_TEMP_AVERAGING {0} \
      SMON_MEAS100 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {4 V unipolar}} {NAME VCCO_500} {SUPPLY_NUM 9}} \
      SMON_MEAS101 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {4 V unipolar}} {NAME VCCO_501} {SUPPLY_NUM 10}} \
      SMON_MEAS102 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {4 V unipolar}} {NAME VCCO_502} {SUPPLY_NUM 11}} \
      SMON_MEAS103 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 4.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {4 V unipolar}} {NAME VCCO_503} {SUPPLY_NUM 12}} \
      SMON_MEAS104 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCCO_700} {SUPPLY_NUM 13}} \
      SMON_MEAS105 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCCO_701} {SUPPLY_NUM 14}} \
      SMON_MEAS106 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCCO_702} {SUPPLY_NUM 15}} \
      SMON_MEAS118 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCC_PMC} {SUPPLY_NUM 0}} \
      SMON_MEAS119 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCC_PSFP} {SUPPLY_NUM 1}} \
      SMON_MEAS120 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCC_PSLP} {SUPPLY_NUM 2}} \
      SMON_MEAS121 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCC_RAM} {SUPPLY_NUM 3}} \
      SMON_MEAS122 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCC_SOC} {SUPPLY_NUM 4}} \
      SMON_MEAS47 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME GTYP_AVCCAUX_104} {SUPPLY_NUM 20}} \
      SMON_MEAS48 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME GTYP_AVCCAUX_105} {SUPPLY_NUM 21}} \
      SMON_MEAS64 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME GTYP_AVCC_104} {SUPPLY_NUM 18}} \
      SMON_MEAS65 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME GTYP_AVCC_105} {SUPPLY_NUM 19}} \
      SMON_MEAS81 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME GTYP_AVTT_104} {SUPPLY_NUM 22}} \
      SMON_MEAS82 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME GTYP_AVTT_105} {SUPPLY_NUM 23}} \
      SMON_MEAS96 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCCAUX} {SUPPLY_NUM 6}} \
      SMON_MEAS97 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCCAUX_PMC} {SUPPLY_NUM 7}} \
      SMON_MEAS98 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCCAUX_SMON} {SUPPLY_NUM 8}} \
      SMON_MEAS99 {{ALARM_ENABLE 1} {ALARM_LOWER 0.00} {ALARM_UPPER 2.00} {AVERAGE_EN 0} {ENABLE 1} {MODE {2 V unipolar}} {NAME VCCINT} {SUPPLY_NUM 5}} \
      SMON_TEMP_AVERAGING_SAMPLES {0} \
      SMON_VOLTAGE_AVERAGING_SAMPLES {8} \
    } \
    CONFIG.PS_PMC_CONFIG_APPLIED {1} \
  ] $cips


  # Create interface connections
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M [get_bd_intf_ports APB_M_0] [get_bd_intf_pins axi_apb_bridge_0/APB_M]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M2 [get_bd_intf_ports APB_M2_0] [get_bd_intf_pins axi_apb_bridge_0/APB_M2]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M3 [get_bd_intf_ports APB_M3_0] [get_bd_intf_pins axi_apb_bridge_0/APB_M3]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_ports M00_AXI_0] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins axi_apb_bridge_0/AXI4_LITE] [get_bd_intf_pins smartconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins axi_gpio_gt_ctl/S_AXI] [get_bd_intf_pins smartconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_ports M00_AXI_1] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_ports M00_AXI_2] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_ports M00_AXI_3] [get_bd_intf_pins smartconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_ports M00_AXI_4] [get_bd_intf_pins smartconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M07_AXI [get_bd_intf_ports M00_AXI_5] [get_bd_intf_pins smartconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M08_AXI [get_bd_intf_ports M00_AXI_6] [get_bd_intf_pins smartconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M09_AXI [get_bd_intf_pins axi_gpio_tx_datapath/S_AXI] [get_bd_intf_pins smartconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M10_AXI [get_bd_intf_pins axi_gpio_rx_datapath/S_AXI] [get_bd_intf_pins smartconnect_0/M10_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M11_AXI [get_bd_intf_pins axi_resets_dyn/S_AXI] [get_bd_intf_pins smartconnect_0/M11_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M12_AXI [get_bd_intf_pins axi_reset_done_dyn/S_AXI] [get_bd_intf_pins smartconnect_0/M12_AXI]
  connect_bd_intf_net -intf_net cips_M_AXI_FPD [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins cips/M_AXI_LPD]

  # Create port connections
  connect_bd_net -net axi_gpio_gt_ctl_gpio_io_o  [get_bd_pins axi_gpio_gt_ctl/gpio_io_o] \
  [get_bd_pins xlslice_gt_reset/Din] \
  [get_bd_pins xlslice_gt_line_rate/Din] \
  [get_bd_pins xlslice_gt_loopback/Din] \
  [get_bd_pins xlslice_gt_txprecursor/Din] \
  [get_bd_pins xlslice_gt_txpostcursor/Din] \
  [get_bd_pins xlslice_gt_txmaincursor/Din] \
  [get_bd_pins xlslice_gt_rxcdrhold/Din]
  connect_bd_net -net axi_gpio_rx_datapath_gpio_io_o  [get_bd_pins axi_gpio_rx_datapath/gpio_io_o] \
  [get_bd_pins xlslice_rx_datapath/Din]
  connect_bd_net -net axi_gpio_tx_datapath_gpio_io_o  [get_bd_pins axi_gpio_tx_datapath/gpio_io_o] \
  [get_bd_pins xlslice_tx_datapath/Din]
  connect_bd_net -net axi_resets_dyn_gpio_io_o  [get_bd_pins axi_resets_dyn/gpio_io_o] \
  [get_bd_pins xlslice_tx_serdes_rst/Din] \
  [get_bd_pins xlslice_rx_serdes_rst/Din] \
  [get_bd_pins xlslice_rx_core_rst/Din] \
  [get_bd_pins xlslice_tx_core_rst/Din]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn  [get_bd_pins proc_sys_reset_0/interconnect_aresetn] \
  [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn  [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
  [get_bd_ports pl0_resetn_0] \
  [get_bd_pins axi_apb_bridge_0/s_axi_aresetn] \
  [get_bd_pins axi_gpio_gt_ctl/s_axi_aresetn] \
  [get_bd_pins axi_gpio_tx_datapath/s_axi_aresetn] \
  [get_bd_pins axi_gpio_rx_datapath/s_axi_aresetn] \
  [get_bd_pins axi_resets_dyn/s_axi_aresetn] \
  [get_bd_pins axi_reset_done_dyn/s_axi_aresetn]
  connect_bd_net -net rx_reset_done  [get_bd_ports gt_rx_reset_done] \
  [get_bd_pins axi_reset_done_dyn/gpio2_io_i]
  connect_bd_net -net tx_reset_done  [get_bd_ports gt_tx_reset_done] \
  [get_bd_pins axi_reset_done_dyn/gpio_io_i]
  connect_bd_net -net cips_pl0_ref_clk  [get_bd_pins cips/pl0_ref_clk] \
  [get_bd_ports pl0_ref_clk_0] \
  [get_bd_pins axi_apb_bridge_0/s_axi_aclk] \
  [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
  [get_bd_pins smartconnect_0/aclk] \
  [get_bd_pins axi_gpio_gt_ctl/s_axi_aclk] \
  [get_bd_pins axi_gpio_tx_datapath/s_axi_aclk] \
  [get_bd_pins axi_gpio_rx_datapath/s_axi_aclk] \
  [get_bd_pins axi_resets_dyn/s_axi_aclk] \
  [get_bd_pins axi_reset_done_dyn/s_axi_aclk] \
  [get_bd_pins cips/m_axi_lpd_aclk]
  connect_bd_net -net cips_pl0_resetn  [get_bd_pins cips/pl0_resetn] \
  [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net xlslice_gt_line_rate_Dout  [get_bd_pins xlslice_gt_line_rate/Dout] \
  [get_bd_ports gt_line_rate]
  connect_bd_net -net xlslice_gt_loopback_Dout  [get_bd_pins xlslice_gt_loopback/Dout] \
  [get_bd_ports gt_loopback]
  connect_bd_net -net xlslice_gt_reset_Dout  [get_bd_pins xlslice_gt_reset/Dout] \
  [get_bd_ports gt_reset_all_in]
  connect_bd_net -net xlslice_gt_rxcdrhold_Dout  [get_bd_pins xlslice_gt_rxcdrhold/Dout] \
  [get_bd_ports gt_rxcdrhold]
  connect_bd_net -net xlslice_gt_txmaincursor_Dout  [get_bd_pins xlslice_gt_txmaincursor/Dout] \
  [get_bd_ports gt_txmaincursor]
  connect_bd_net -net xlslice_gt_txpostcursor_Dout  [get_bd_pins xlslice_gt_txpostcursor/Dout] \
  [get_bd_ports gt_txpostcursor]
  connect_bd_net -net xlslice_gt_txprecursor_Dout  [get_bd_pins xlslice_gt_txprecursor/Dout] \
  [get_bd_ports gt_txprecursor]
  connect_bd_net -net xlslice_rx_core_rst_Dout  [get_bd_pins xlslice_rx_core_rst/Dout] \
  [get_bd_ports rx_core_reset]
  connect_bd_net -net xlslice_rx_datapath_Dout  [get_bd_pins xlslice_rx_datapath/Dout] \
  [get_bd_ports gt_reset_rx_datapath_in]
  connect_bd_net -net xlslice_rx_serdes_rst_Dout  [get_bd_pins xlslice_rx_serdes_rst/Dout] \
  [get_bd_ports rx_serdes_reset]
  connect_bd_net -net xlslice_tx_core_rst_Dout  [get_bd_pins xlslice_tx_core_rst/Dout] \
  [get_bd_ports tx_core_reset]
  connect_bd_net -net xlslice_tx_datapath_Dout  [get_bd_pins xlslice_tx_datapath/Dout] \
  [get_bd_ports gt_reset_tx_datapath_in]
  connect_bd_net -net xlslice_tx_serdes_rst_Dout  [get_bd_pins xlslice_tx_serdes_rst/Dout] \
  [get_bd_ports tx_serdes_reset]

  # Create address segments
  assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs APB_M2_0/Reg] -force
  assign_bd_address -offset 0x80010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs APB_M3_0/Reg] -force
  assign_bd_address -offset 0x80020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs APB_M_0/Reg] -force
  assign_bd_address -offset 0x80030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs M00_AXI_0/Reg] -force
  assign_bd_address -offset 0x80040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs M00_AXI_1/Reg] -force
  assign_bd_address -offset 0x80050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs M00_AXI_2/Reg] -force
  assign_bd_address -offset 0x80060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs M00_AXI_3/Reg] -force
  assign_bd_address -offset 0x80070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs M00_AXI_4/Reg] -force
  assign_bd_address -offset 0x80080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs M00_AXI_5/Reg] -force
  assign_bd_address -offset 0x80090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs M00_AXI_6/Reg] -force
  assign_bd_address -offset 0x800A0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs axi_gpio_gt_ctl/S_AXI/Reg] -force
  assign_bd_address -offset 0x800B0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs axi_gpio_rx_datapath/S_AXI/Reg] -force
  assign_bd_address -offset 0x800C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs axi_gpio_tx_datapath/S_AXI/Reg] -force
  assign_bd_address -offset 0x800D0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs axi_reset_done_dyn/S_AXI/Reg] -force
  assign_bd_address -offset 0x800E0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces cips/M_AXI_LPD] [get_bd_addr_segs axi_resets_dyn/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


