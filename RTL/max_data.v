`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2024 04:01:44
// Design Name: 
// Module Name: max_data
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


module max_data(
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] Y
    );


    always @(*) begin
        if(A>B)
            Y = A;
        else
            Y = B;

    end
    
endmodule
