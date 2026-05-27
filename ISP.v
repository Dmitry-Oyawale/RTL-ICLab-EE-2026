
module ISP(
    //Input Port
    clk,
    rst_n,

    in_valid,
    in,
    param_valid,
    param_gain,

    //Output Port
    out_valid,
    r_out,
    g_out,
    b_out
    );

//==============================
//   INPUT/OUTPUT DECLARATION
//==============================
input clk;
input rst_n;
input in_valid;
input [11:0] in;
input param_valid;
input [11:0] param_gain;

output reg out_valid;
output reg [11:0] r_out;
output reg [11:0] g_out;
output reg [11:0] b_out;

//==============================
//   Design
//==============================

localparam IMG_W = 16;
localparam IMG_H = 16;
localparam TOTAL_PIXELS = 256;
localparam TH = 320;
localparam BLACK_LEVEL = 64;

localparam S_IDLE = 3'd0;
localparam S_INPUT = 3'd1;
localparam S_LSC = 3'd2;
localparam S_DPC = 3'd3;
localparam S_OUTPUT = 3'd4;

reg [2:0] state;
reg [7:0] in_cnt;
reg [7:0] calc_cnt;
reg [7:0] out_cnt;
reg [7:0] param_cnt;

reg [11:0] raw_img [0:255];
reg [11:0] lsc_img [0:255];
reg [11:0] dpc_img [0:255];

reg [11:0] gain_r [0:35];
reg [11:0] gain_gr [0:35];
reg [11:0] gain_gb [0:35];
reg [11:0] gain_b [0:35];

function [3:0] get_x;
    input [7:0] idx;
    begin 
        get_x = idx[3:0];
    end 
endfunction 

function [3:0] get_y;
    input [7:0] idx;
    begin 
        get_y = idx[7:4];
    end 
endfunction 

function integer reflect16;
    input integer v;
    begin 
        if (v < 0)
            reflect16 = -v;
        else if (v >= 16)
            reflect16 = 30 - v;
        else 
            reflect16 = v;
    end 
endfunction

function [7:0] idx_reflect;
    input integer x;
    input integer y;
    integer xr;
    integer yr;
    begin 
        xr = reflect16(x);
        yr = reflect16(y);
        idx_reflect = yr * 16 + xr;
    end 
endfunction


