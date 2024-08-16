`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2024 07:18:47
// Design Name: 
// Module Name: max_pooling
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


module max_pooling #(
    parameter N=28,
	parameter M=28,
	parameter K=3,
	parameter P=2,
	parameter P_stride=2,
	parameter K_stride=2,
	parameter pool=1
    
    ) (
        input clk,
        input reset,
        input [15:0] pixel_in,
        input i_data_valid,
        output [15:0] o_max_pooled_pixel,
        output reg o_data_valid

    );

    wire [15:0] wire_1,reg1,sr_out,wire_2,reg2;
    register R1 (.clk(clk),.reset(reset),.in(pixel_in),.out(reg1));
    max_data M1(.A(pixel_in),.B(reg1),.Y(wire_1));
    shift_reg #(.M(M),.K(K),.pool(pool),.P(P)) LD1 (.clk(clk),.reset(reset),.data_in(wire_1),.data_out(sr_out));
    max_data M2(.A(sr_out),.B(pixel_in),.Y(wire_2));
    register R2 (.clk(clk),.reset(reset),.in(wire_2),.out(reg2));
    max_data M3(.A(pixel_in),.B(reg2),.Y(o_max_pooled_pixel));

    reg [$clog2(M+P+P+P)-1:0] counter;

    always@(posedge clk) begin
        if(reset | !(i_data_valid)) begin
            counter <= 0;
            o_data_valid <= 1'b0;
        end
        else begin
            counter <= counter+1;
            if(counter == (M+P+P+P)-1) begin
                counter <= 0;
                o_data_valid <= 1'b0;
            end
            else if(counter==(M+P-2)) begin
                o_data_valid <= 1'b1;
            end
            else if(counter == (M+P+P-2)) begin
                o_data_valid <= 1'b1;
            end
            else if(counter==(M+P+P+P-2)) begin
                o_data_valid<=1'b1;
            end
            else begin
                o_data_valid <= 1'b0;
            end
        end
    end


endmodule
