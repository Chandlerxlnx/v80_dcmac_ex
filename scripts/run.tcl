open_project ./dcmac_0_ex/dcmac_0_ex.xpr

#walk around the error that some synth_1 or impl_1 are out of date in no reason.
reset_project

if {[get_property needs_refresh [get_runs synth_1]]} {
	reset_runs [get_runs synth_1]
}
# walk around the issue that synth is killed somehow.
set runs 0
while {$runs < 2 && [get_property STATUS [get_runs synth_1]] !="synth_design Complete!"} {
    reset_runs [get_runs -filter {PROGRESS <100} ]
    launch_runs [get_runs synth_1] -jobs 8
    if { [catch {wait_on_runs [get_runs synth_1] } status ] } {
	    puts "Error: during wait_on_runs synth_1. message: $status"
    }
    incr runs
}

if {[get_property needs_refresh [get_runs impl_1]]} {

	reset_runs [get_runs impl_1]
}
set runs 0
while {$runs < 2 && [get_property STATUS [get_runs impl_1]] !="write_device_image Complete!"} {
	if {$runs >0} {
		reset_runs [get_runs impl_1]
		#reset_project
	}
	launch_runs [get_runs impl_1] -to_step write_device_image -jobs 8

	if {[catch {wait_on_runs [get_runs impl_1] } status] } {
		puts "Error: during wait_on_runs impl_1. message: $status";
	}
	incr runs
}
write_hw_platform -fixed -force -include_bit -file ./dcmac_0_ex_top.xsa
exit
