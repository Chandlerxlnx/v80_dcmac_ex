open_project ./dcmac_0_ex/dcmac_0_ex.xpr
launch_runs [get_runs impl_1]
wait_on_runs [get_runs impl_1]
write_hw_platform -force -include_bit dcmac_0_ex.xsa
