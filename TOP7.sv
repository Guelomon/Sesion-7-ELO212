`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2019 04:28:57 PM
// Design Name: 
// Module Name: TOP7
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


module TOP7(input logic CLK100MHZ,BTNL,BTNR,BTNC, UART_TXD_IN, UART_RXD_OUT,
output logic [7:0]AN, [15:0]LED,SW,
output logic CA,CB,CC,CD,CE,CF,CG,LED16_G,LED16_R);
//output logic uart_tx_busy,
//output logic uart_tx_usb,


//output  logic [7:0]ss_value,
//output  logic [7:0]ss_select);
logic [15:0]datos;
logic clk_out,rx_ready,t1,t2,t3,Rs,Rp,Rr,Cs,Cp,Cr;
clock (CLK100MHZ,BTNR,clk_out);
PB_Debouncer_FSM fsmR(CLK100MHZ,BTNL,BTNR,Rs,Rp,Rr);
PB_Debouncer_FSM fsmC(CLK100MHZ,BTNL,BTNC,Cs,Cp,Cr);
RX maquinita(CLK100MHZ, BTNR ,rx_ready, LED[15:0], t1, t2,t3,t4,t5);

logic [7:0]    tx_data; 
logic [7:0]    rx_data; 
logic [15:0]   result16;
logic uart_tx_busy;
logic uart_tx_usb;
logic [1:0]    reset_sr;
logic reset, tx_start,tx_busy;
assign  reset = reset_sr[1];
assign uart_tx_busy = tx_busy;

uart_basic #(100000000,115200) uart_basic_inst (CLK100MHZ,Rp,UART_TXD_IN,rx_data,rx_ready,UART_RXD_OUT,tx_start,tx_data,tx_busy);

always_ff @(posedge CLK100MHZ) begin
        if(Rp)
            result16 <= 16'd0;
        else 
        if (rx_ready)
            result16 <= {rx_data, result16[15:8]};
    end

//assign LED[15:0]=result16;


endmodule
