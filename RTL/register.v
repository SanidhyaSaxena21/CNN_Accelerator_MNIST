`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2024 22:12:07
// Design Name: 
// Module Name: register
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


module register(
    input clk,
    input reset,
    input [15:0] in,
    output [15:0] out
    );

reg [15:0] data;
assign out[15:0] = data[15:0];

always @(posedge clk) begin
	if (reset) begin
		data[15:0] <= 16'b0000000000000000;
	end
	else begin
		data[15:0] <= in[15:0];
	end

end

endmodule
