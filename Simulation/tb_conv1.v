`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2024 19:40:50
// Design Name: 
// Module Name: tb_conv1
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


module tb_conv1(
    );
    
	parameter N = 6;	//Image columns
	parameter M = 6;	//Image rows
	parameter K = 3;	//Kernel size
	parameter P = 2;  // Pooling Kernel size
  	parameter P_stride =2;
  	parameter K_stride =1;
	
    reg clk;
    reg reset;
    reg [15:0] pxl_in;
    reg i_data_valid;
    reg signed [(16*K*K)-1:0] i_kernel_data;
    wire [15:0] pxl_out;
    wire [9:0] count;
    wire o_data_valid;
    reg [15:0] in_mem [(N*N)-1:0];
    wire [15:0] o_max_pooled_pixel;
    wire o_data_valid_pooling;
    
    
    // ---------Layer1 Convolution-------------------------------------------
    conv_final #(
        .N(N),
        .M(M),
        .K(K),
        .P(P),
        .P_stride(P_stride),
        .K_stride(K_stride),
        .pool(0)
    ) C1
    (
        .clk(clk),
    	.reset(reset),
    	.pxl_in(pxl_in),
    	.i_data_valid(i_data_valid),
    	.i_kernel_data(i_kernel_data),
        .pxl_out(pxl_out),
	    .count(count),
	    .o_data_valid(o_data_valid)
    );
    
     // ---------Layer1 MAX_POOLING-------------------------------------------
    
    max_pooling #(
    .N(N),	//Image columns
    .M(M),	//Image rows
    .K(K),	//Kernel size
    .P(P),  // Pooling Kernel size
    .P_stride(P_stride),
    .K_stride(K_stride),
    .pool(1)
    ) MP1 (
    .clk(clk),
    .reset(reset),
    .pixel_in(pxl_out),
    .i_data_valid(o_data_valid),
    .o_max_pooled_pixel(o_max_pooled_pixel),
    .o_data_valid(o_data_valid_pooling)
    );
    
    
    initial begin
        clk = 0;
    end
    
    always #5 clk = ~clk;
    
    
    integer t;
    
    task sendData();
    integer t;
    begin
       $readmemh("test_conv1.txt", in_mem);
        for (t=0; t <(N*N); t=t+1) begin
            @(posedge clk);
            pxl_in <= in_mem[t];
        end 
                    //in_valid <= 1;
        //#1000
 
        //@(posedge clock);
        //in_valid <= 0;
        //expected = in_mem[t];
    end
    endtask
    
    initial begin
        reset = 1;
        #100
        reset = 0;
        pxl_in =0;
        i_kernel_data={16'd1,16'd1,16'd1,16'd1,16'd1,16'd1,16'd1,16'd1,16'd1};
        
        $readmemh("test_conv1.txt", in_mem);
        for (t=0; t <(N*N); t=t+1) begin
            @(posedge clk);
            i_data_valid <= 1'b1;
            pxl_in <= in_mem[t];
        end 
        i_data_valid <= 1'b0;
        //sendData();
    end
    
    
endmodule
