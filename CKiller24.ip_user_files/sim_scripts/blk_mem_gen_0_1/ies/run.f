-makelib ies_lib/xpm -sv \
  "/tools/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/tools/Xilinx/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../CKiller24.srcs/sources_1/ip/blk_mem_gen_0_1/blk_mem_gen_0_sim_netlist.vhdl" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

