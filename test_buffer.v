`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:        Pavas Kant; Peiwen Hu; Zafar Takhirov
//
// Create Date:    00:54:47 12/16/2012
// Design Name:
// Module Name:    test_buffer
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

`define IDLE					0
`define WAIT_4_NEW_FRAME	1
`define RECORD_IMAGE			2
`define PROCESS_IMAGE		3

module test_buffer(
	input [15:0] pixel_in,
	output [15:0] pixel_out,

	input [30:0] hCounter_in,
	input [30:0] vCounter_in,

	input clk
	);

	wire [15:0] pixel_temp;
	wire blank_bg, blank_fg, blank_real;

	assign blank_bg 	= (hCounter_in >= 160 | vCounter_in >= 140);
	assign blank_real = 	hCounter_in < 170 | hCounter_in >= 330 | vCounter_in >= 140;
	assign blank_fg	=	hCounter_in < 340 | hCounter_in >= 500 | vCounter_in >= 140;

	assign pixel_out = 	( {16{~blank_bg}} & pixel_temp ) |
								( {16{~blank_real}} & real_data ) |
								( {16{~blank_fg}} & {16{pixel_fg}});



/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

reg [16:0] counter_address, counter_address_real, counter_address_fg;
reg wea = 1;
reg [39:0] proc_d;	// processed data from BRAM
wire [16:0] addr_write = (counter_address==0)? 22399: counter_address-2;	// computes the address of the BRAM

reg [39:0]temp_bg;	// computed background (going to the BRAM)

reg [15:0] temp_real;	// input from the camera
reg [15:0] real_data;	// output of the camera feed
reg temp_fg;				// the difference (goes to the BRAM)

reg pixel_fg;	// the difference for foreground detection
wire [15:0] difference;

assign pixel_temp={temp_bg[38:34],temp_bg[25:20],temp_bg[11:7]};	// background output pixel
assign difference[15:11] = (temp_real[15:11] > pixel_temp[15:11]) ?
											(temp_real[15:11] - pixel_temp[15:11]) :
											(pixel_temp[15:11] - temp_real[15:11]);
assign difference[10:5] = (temp_real[10:5] > pixel_temp[10:5]) ?
											(temp_real[10:5] - pixel_temp[10:5]) :
											(pixel_temp[10:5] - temp_real[10:5]);
assign difference[4:0] = (temp_real[4:0] > pixel_temp[4:0]) ?
											(temp_real[4:0] - pixel_temp[4:0]) :
											(pixel_temp[4:0] - temp_real[4:0]);



always @(posedge clk) begin
	// compute the current address for the BG detection
	// as well as real feed
	if (~blank_bg) counter_address <= counter_address+1;
	if (counter_address >= 22399) counter_address <= 0;

	if (~blank_real) counter_address_real <= counter_address_real+1;
	if (counter_address_real >= 22399) counter_address_real <= 0;

	if (~blank_fg) counter_address_fg <= counter_address_fg+1;
	if (counter_address_fg >= 22399) counter_address_fg <= 0;

end




always @ (posedge clk) begin
	if (~blank_bg) begin
		temp_bg[39:27] = 	proc_d[39:27] 	- proc_d[39:34]	+ pixel_in[15:11];
		temp_bg[26:13] = 	proc_d[26:13] 	- proc_d[26:20] 	+ pixel_in[10:5];
		temp_bg[12:0] = 	proc_d[12:0] 	- proc_d[12:7] 	+ pixel_in[4:0];

		temp_real = pixel_in;
		temp_fg = (difference[15:11] > 15) | (difference[10:5] > 15) | (difference[4:0] > 15);
	end
end

// stores computed background
bram1 buffer_data(
	 .clka(clk),
    .wea(wea),
    .addra(addr_write),
    .dina(temp_bg),
    .douta(),
    .clkb(clk),
    .web(0),
    .addrb(counter_address),
    .dinb(),
    .doutb(proc_d)
);

// stores real feed
bram_current_frame buffer_data_real(
	 .clka(clk),
    .wea(wea),
    .addra(addr_write),
    .dina(temp_real),
    .douta(),
    .clkb(clk),
    .web(0),
    .addrb(counter_address_real),
    .dinb(),
    .doutb(real_data)
);

// stores the difference frame
bram_fg buffer_data_fg(
	 .clka(clk),
    .wea(wea),
    .addra(addr_write),
    .dina(temp_fg),
    .douta(),
    .clkb(clk),
    .web(0),
    .addrb(counter_address_fg),
    .dinb(),
    .doutb(pixel_fg)
);

endmodule
