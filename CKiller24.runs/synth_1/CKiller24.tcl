# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 1
set_param xicom.use_bs_reader 1
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/tim_c/CK24/CKiller24.cache/wt [current_project]
set_property parent.project_path C:/Users/tim_c/CK24/CKiller24.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo c:/Users/tim_c/CK24/CKiller24.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/ip/progmem/progmemInit.coe
read_vhdl -library xil_defaultlib {
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/new/ALU.vhd
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/new/DEC8_1.vhd
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/new/Reg.vhd
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/new/RegisterFile.vhd
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/new/Top.vhd
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/new/ControlUnit.vhd
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/imports/tmc/SevenSegmentDecoder.vhd
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/imports/tmc/Decoder3_8.vhd
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/imports/tmc/SevenSegmentDigitController.vhd
  C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/new/MMU.vhd
}
read_ip -quiet C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/ip/progmem/progmem.xci
set_property used_in_implementation false [get_files -all c:/Users/tim_c/CK24/CKiller24.srcs/sources_1/ip/progmem/progmem_ooc.xdc]

read_ip -quiet C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/ip/dataRam/dataRam.xci
set_property used_in_implementation false [get_files -all c:/Users/tim_c/CK24/CKiller24.srcs/sources_1/ip/dataRam/dataRam_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/tim_c/CK24/CKiller24.srcs/constrs_1/imports/tmc/Keyboard.xdc
set_property used_in_implementation false [get_files C:/Users/tim_c/CK24/CKiller24.srcs/constrs_1/imports/tmc/Keyboard.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top CKiller24 -part xc7a100tcsg324-1 -flatten_hierarchy none -directive RuntimeOptimized -fsm_extraction off -quick


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef CKiller24.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file CKiller24_utilization_synth.rpt -pb CKiller24_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
