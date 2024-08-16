`timescale 1ns / 1ps

module conv_final #(
	parameter N=28,
	parameter M=28,
	parameter K=3,
	parameter P=2,
	parameter P_stride=2,
	parameter K_stride=2,
	parameter pool=0
    
) (
    	input clk,
    	input reset,
    	input [15:0] pxl_in,
		input i_data_valid,
		input [(K*K*16)-1:0]i_kernel_data,
   		output [31:0] pxl_out,
		output [9:0] count,
		output reg o_data_valid
    );


	wire [31:0] reg_00,reg_01,reg_02,sr_0;
	wire[31:0] reg_10, reg_11,reg_12,sr_1;
	wire[31:0] reg_20, reg_21,reg_22;

	// Intermediate wires
	wire [31:0] wire_00; wire [31:0] wire_01; wire [31:0] wire_02;
	wire [31:0] wire_10; wire [31:0] wire_11; wire [31:0] wire_12;
	wire [31:0] wire_20; wire [31:0] wire_21; wire [31:0] wire_22;

	wire signed [15:0] kernel [(K*K)-1:0];

	genvar i;

	generate
		for(i=0;i<(K*K);i=i+1) begin
			assign kernel[i] = i_kernel_data[16*(i)+:16];
		end
	endgenerate

	reg sel_1,sel_2,sel_3;
	wire [15:0] out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8,out_9;

	// Row : 1
	mux M1 (.A(pxl_in),.B(0),.reset(reset),.sel(sel_1),.out(out_1));
	mac mac_00(out_1, kernel[0], 0, wire_00);
	register r_00(clk, reset, wire_00, reg_00); 
	
	mux M2 (.A(pxl_in),.B(0),.reset(reset),.sel(sel_2),.out(out_2));
	mac mac_01(out_2, kernel[1], reg_00, wire_01); 
	register r_01(clk, reset, wire_01, reg_01); 

	mux M3 (.A(pxl_in),.B(0),.reset(reset),.sel(sel_3),.out(out_3));
	mac mac_02(out_3, kernel[2], reg_01, wire_02); 
	register r_02(clk, reset, wire_02, reg_02); 

	shift_reg #(.pool(0),.M(M),.K(K),.P(P)) row_1(.clk(clk),.reset(reset), .data_in(reg_02), .data_out(sr_0));

	// Row : 2
	mux M4 (.A(pxl_in),.B(0),.reset(reset),.sel(sel_1),.out(out_4));
	mac mac_10(out_4, kernel[3], sr_0, wire_10); 
	register r_10(clk, reset, wire_10, reg_10); 

	mux M5 (.A(pxl_in),.B(0),.reset(reset),.sel(sel_2),.out(out_5));
	mac mac_11(out_5, kernel[4], reg_10, wire_11); 
	register r_11(clk, reset, wire_11, reg_11); 

	mux M6 (.A(pxl_in),.B(0),.reset(reset),.sel(sel_3),.out(out_6));
	mac mac_12(out_6, kernel[5], reg_11, wire_12); 
	register r_12(clk, reset, wire_12, reg_12); 

	shift_reg #(.pool(0),.M(M),.K(K),.P(P)) row_2(.clk(clk),.reset(reset), .data_in(reg_12), .data_out(sr_1));

	// Row : 3
	mux M7 (.A(pxl_in),.B(0),.reset(reset),.sel(sel_1),.out(out_7));
	mac mac_20(out_7, kernel[6], sr_1, wire_20); 
	register r_20(clk, reset, wire_20, reg_20); 

	mux M8 (.A(pxl_in),.B(0),.reset(reset),.sel(sel_2),.out(out_8));
	mac mac_21(out_8, kernel[7], reg_20, wire_21); 
	register r_21(clk, reset, wire_21, reg_21); 

	mux M9 (.A(pxl_in),.B(0),.reset(reset),.sel(sel_3),.out(out_9));
	mac mac_22(out_9, kernel[8], reg_21, wire_22); 
	register r_22(clk, reset, wire_22, reg_22); 
	
	assign pxl_out = reg_22;	

	// Valid bit logic

	reg [9:0] counter = 0;
	reg temp = 0;
	reg [$clog2(M*M)-1:0] count_valid;

	always @(posedge clk) begin
		if ((reset == 1) | (!i_data_valid)) begin
			counter = 0;
		end else begin
			counter = counter + 1;
			if ((counter > (((M*(K-1))/2)+((K-1)/2)))) begin
				temp <= 1'b1;
			end
			/*else if(count_valid == (M*M)) begin
				temp <= 1'b0;
			end*/
			else begin
				temp <= temp; 
			end
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin
		    temp <= 0;
		    count_valid <= 0;
			o_data_valid=0;
		end
		else begin
			if(temp) begin
			    o_data_valid <= 1'b1;
				count_valid <= count_valid+1;
				if(count_valid == (M*M)-1) begin
				    o_data_valid <= 1'b0;
				    temp <= 1'b0;
				end
			end
			else begin
				o_data_valid <= o_data_valid;
			end
		end
	end

	always@(posedge clk) begin
		if(reset | (!i_data_valid) ) begin
			sel_1 <= 1'b0;
		end
		else begin
			if((counter % 6)==0) begin
				sel_1<= 1'b0;
			end
			else if(counter > (M*M))
				sel_1 <= 1'b0;
			else begin
				sel_1 <= 1'b1;
			end
		end
	end

	always@(posedge clk) begin
		if(reset | (!i_data_valid)) begin
			sel_3 <= 1'b0;
		end
		else begin
			if((counter % 6)==1) begin
				sel_3<= 1'b0;
			end
			else if(counter > (M*M))
				sel_3 <= 1'b0;
			else begin
				sel_3 <= 1'b1;
			end
		end
	end

	always @(posedge clk) begin
		if(reset | (!i_data_valid)) 
			sel_2 <= 1'b0;
		else begin
			if(counter > (M*M))
				sel_2 <= 1'b0;
			else
				sel_2 <= 1'b1; 
		end
	end

	assign count = counter;
	assign valid = temp;

endmodule