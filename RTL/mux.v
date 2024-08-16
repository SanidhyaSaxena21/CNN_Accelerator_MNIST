`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2024 23:08:13
// Design Name: 
// Module Name: mux
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


module mux(
    input [15:0] A,
    input [15:0] B,
    input reset,
    input sel,
    output reg [15:0] out
    );
    
    always @(*) begin
        if(reset)
            out =0;
        else begin
            if(sel)
                out=A;
            else
                out=B;
        end
    end


    //assign out = sel?A:B;
endmodule
