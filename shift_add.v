`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:        Pavas Kant; Peiwen Hu; Zafar Takhirov
//
// Create Date:    20:32:37 12/12/2012
// Design Name:
// Module Name:    shift_add
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module shift_add(old, new_pix, Y);

	input [15:0] old, new_pix;
	output [15:0] Y;

	assign Y = (new_pix >> 15) + (old >> 1);


endmodule
