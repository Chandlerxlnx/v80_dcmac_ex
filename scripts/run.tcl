open_project ./dcmac_0_ex/dcmac_0_ex.xpr
launch_runs [get_runs impl_1] -to_step write_device_image -jobs 30
wait_on_runs [get_runs impl_1]
write_hw_platform -fixed -force -include_bit -file ./dcmac_0_ex_impl_top.xsa
exit
