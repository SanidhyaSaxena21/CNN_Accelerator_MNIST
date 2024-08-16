`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2024 22:11:18
// Design Name: 
// Module Name: mac
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Multiply Accumulate Unit

module mac(
    input [15:0] in,
    input [15:0] w,
    input [15:0] b,
    output [15:0] out
    );

wire [15:0] d;
assign d = w * in;
assign out = d + b;
 
endmodule
