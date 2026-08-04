`timescale 1ns / 1ps

module sbus_top(
    input clk,
    input reset,
    input rx,
    output paket_dogru,
    

    output [10:0] ch1_roll,  
    output [10:0] ch2_pitch,
    output [10:0] ch3_kanal,
    output [10:0] ch4_kanal,
    output [10:0] ch5_kanal,
    output [10:0] ch6_kanal,
    output [10:0] ch7_kanal,
    output [10:0] ch8_kanal,
    output [10:0] ch9_kanal,
    output [10:0] ch10_kanal,
    output [10:0] ch11_kanal,
    output [10:0] ch12_kanal,
    output [10:0] ch13_kanal 
);

    wire [7:0] ara_baglanti_verisi;
    wire ara_baglanti_bitti;

   
    sbus_rx u_sbus_rx (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .veri_cik(ara_baglanti_verisi), 
        .rx_bitti(ara_baglanti_bitti)   
    );

  
    sbus_parser u_sbus_parser (
        .clk(clk),
        .reset(reset),
        .rx_bitti(ara_baglanti_bitti),
        .gelen_veri(ara_baglanti_verisi),
        .paket_dogru(paket_dogru),
        
       
        .ch1_roll(ch1_roll),    
        .ch2_pitch(ch2_pitch),
        .ch3_kanal(ch3_kanal),
        .ch4_kanal(ch4_kanal),
        .ch5_kanal(ch5_kanal),
        .ch6_kanal(ch6_kanal),
        .ch7_kanal(ch7_kanal),
        .ch8_kanal(ch8_kanal),
        .ch9_kanal(ch9_kanal),
        .ch10_kanal(ch10_kanal),
        .ch11_kanal(ch11_kanal),
        .ch12_kanal(ch12_kanal),
        .ch13_kanal(ch13_kanal) 
    );

endmodule