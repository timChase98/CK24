// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Wed Apr 22 22:56:07 2020
// Host        : DESKTOP-RTHS3DT running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/tim_c/CK24/CKiller24.srcs/sources_1/ip/progmem/progmem_stub.v
// Design      : progmem
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module progmem(clka, rsta, ena, wea, addra, dina, douta, rsta_busy)
/* synthesis syn_black_box black_box_pad_pin="clka,rsta,ena,wea[0:0],addra[15:0],dina[23:0],douta[23:0],rsta_busy" */;
  input clka;
  input rsta;
  input ena;
  input [0:0]wea;
  input [15:0]addra;
  input [23:0]dina;
  output [23:0]douta;
  output rsta_busy;
endmodule
