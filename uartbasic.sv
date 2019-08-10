`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2019 07:48:49 PM
// Design Name: 
// Module Name: uartbasic
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


module uartbasic
#(
	parameter CLK_FREQUENCY = 100000000,
	parameter BAUD_RATE = 115200
)(
	input logic clk,
	input logic reset,
	input logic rx,
	output logic [7:0] rx_data,
	output logic rx_ready,
	output logic tx,
	input logic tx_start,
	input logic [7:0] tx_data,
	output logic tx_busy
);

	logic baud8_tick;
	logic baud_tick;

	logic rx_ready_sync;
	logic rx_ready_pre;

	uart_baud_tick_gen #(.CLK_FREQUENCY(CLK_FREQUENCY),.BAUD_RATE(BAUD_RATE),.OVERSAMPLING(8)) 
	baud8_tick_blk (.clk(clk),.enable(1'b1),.tick(baud8_tick));
	uart_rx uart_rx_blk (.clk(clk),.reset(reset),.baud8_tick(baud8_tick),.rx(rx),.rx_data(rx_data),.rx_ready(rx_ready_pre));

	always @(posedge clk) begin
		rx_ready_sync <= rx_ready_pre;
		rx_ready <= ~rx_ready_sync & rx_ready_pre;
	end


	uart_baud_tick_gen #(.CLK_FREQUENCY(CLK_FREQUENCY),.BAUD_RATE(BAUD_RATE),.OVERSAMPLING(1))
	baud_tick_blk (
		.clk(clk),
		.enable(tx_busy),
		.tick(baud_tick)
	);

	uart_tx uart_tx_blk (
		.clk(clk),
		.reset(reset),
		.baud_tick(baud_tick),
		.tx(tx),
		.tx_start(tx_start),
		.tx_data(tx_data),
		.tx_busy(tx_busy)
	);

endmodule
