open_project ./dcmac_0_ex/dcmac_0_ex.xpr

if {[get_property needs_refresh [get_runs synth_1]]} {
	reset_runs [get_runs synth_1]
}
# walk around the issue that synth is killed somehow.
set runs 0
while {$runs < 2 && [get_property STATUS [get_runs synth_1]] !="synth_design Complete!"} {
    reset_runs [get_runs synth_1]
    launch_runs [get_runs synth_1] -jobs 20
    wait_on_runs [get_runs synth_1]
    incr runs
}

if {[get_property needs_refresh [get_runs impl_1]]} {

	reset_runs [get_runs impl_1]
}
set runs 0
while {$runs < 2 && [get_property STATUS [get_runs impl_1]] !="synth_design Complete!"} {
	launch_runs [get_runs impl_1] -to_step write_device_image -jobs 20
	wait_on_runs [get_runs impl_1]
	incr runs
}
write_hw_platform -fixed -force -include_bit -file ./dcmac_0_ex_impl_top.xsa
exit
