`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 		Pavas Kant; Peiwen Hu; Zafar Takhirov
//
// Create Date:    12:58:53 12/16/2012
// Design Name:
// Module Name:    box_drawing
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
module box_drawing(
	input [30:0] hCounter_in,
	input [30:0] vCounter_in,

	output blank
    );

	parameter BOX_TL_X = 100;
	parameter BOX_TL_Y = 100;
	parameter BOX_SIDE = 80;
	parameter BOX_Y_SIZE = BOX_SIDE*5 + 20;
	// controls for the box showing up

	wire [1:0] h_line;
	wire [5:0] v_line;


	///////////////////////////////////////////////
	// draw a box:
	assign h_line[0] = 	(hCounter_in >= BOX_TL_X - 5 & hCounter_in < BOX_TL_X + BOX_Y_SIZE + 5) &
								(vCounter_in >= BOX_TL_Y - 5 & vCounter_in < BOX_TL_Y);
	assign h_line[1] =	(hCounter_in >= BOX_TL_X - 5 & hCounter_in < BOX_TL_X + BOX_Y_SIZE + 5) &
								(vCounter_in >= BOX_TL_Y + BOX_SIDE & vCounter_in < BOX_TL_Y + BOX_SIDE + 5);

	assign v_line[0] =	(hCounter_in >= BOX_TL_X - 5 & hCounter_in < BOX_TL_X) &
								(vCounter_in >= BOX_TL_Y & vCounter_in < BOX_TL_Y + BOX_SIDE);

	assign v_line[1] =	(hCounter_in >= BOX_TL_X + 80 & hCounter_in < BOX_TL_X + 85) &
								(vCounter_in >= BOX_TL_Y & vCounter_in < BOX_TL_Y + BOX_SIDE);

	assign v_line[2] =	(hCounter_in >= BOX_TL_X + 165 & hCounter_in < BOX_TL_X + 170) &
								(vCounter_in >= BOX_TL_Y & vCounter_in < BOX_TL_Y + BOX_SIDE);

	assign v_line[3] =	(hCounter_in >= BOX_TL_X + 250 & hCounter_in < BOX_TL_X + 255) &
								(vCounter_in >= BOX_TL_Y & vCounter_in < BOX_TL_Y + BOX_SIDE);

	assign v_line[4] =	(hCounter_in >= BOX_TL_X + 335 & hCounter_in < BOX_TL_X + 340) &
								(vCounter_in >= BOX_TL_Y & vCounter_in < BOX_TL_Y + BOX_SIDE);

	assign v_line[5] =	(hCounter_in >= BOX_TL_X + 420 & hCounter_in < BOX_TL_X + 425) &
								(vCounter_in >= BOX_TL_Y & vCounter_in < BOX_TL_Y + BOX_SIDE);

	assign blank = (|h_line) | (|v_line);

endmodule
