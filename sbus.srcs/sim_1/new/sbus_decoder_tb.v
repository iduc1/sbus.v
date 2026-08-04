`timescale 1ns / 1ps

module sbus_decoder_tb();

 
    reg clk;
    reg reset;
    reg paket_dogru;
    reg [7:0] sbus_paket_0;
    reg [7:0] sbus_paket_1;
    reg [7:0] sbus_paket_2;
    reg [7:0] sbus_paket_3;
    
    wire [10:0] ch1_roll;
    wire [10:0] ch2_pitch;

    
    sbus_decoder uut (
        .clk(clk),
        .reset(reset),
        .paket_dogru(paket_dogru),
        .sbus_paket_0(sbus_paket_0),
        .sbus_paket_1(sbus_paket_1),
        .sbus_paket_2(sbus_paket_2),
        .sbus_paket_3(sbus_paket_3),
        .ch1_roll(ch1_roll),
        .ch2_pitch(ch2_pitch)
    );


    always begin
        #5 clk = ~clk;
    end


    initial begin
    
        clk = 0;
        reset = 1;
        paket_dogru = 0;
        sbus_paket_0 = 8'h00;
        sbus_paket_1 = 8'h00;
        sbus_paket_2 = 8'h00;
        sbus_paket_3 = 8'h00;
        
        #100;
        reset = 0;
        #20;

 
        sbus_paket_0 = 8'h0F;
        sbus_paket_1 = 8'hFF;
        sbus_paket_2 = 8'hAB;
        sbus_paket_3 = 8'h16;
        
        #50; 
       
        paket_dogru = 1;
        #10; 
        paket_dogru = 0;
        
        #100;
        $finish;
    end

endmodule