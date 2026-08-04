`timescale 1ns / 1ps

module sbus_parser#(parameter WIDTH = 11)(
    input clk,
    input reset,
    input rx_bitti,               
    input [7:0] gelen_veri,       
    
    output reg paket_dogru,
    
    output reg [WIDTH-1:0] ch1_roll,
    output reg [WIDTH-1:0] ch2_pitch,
    output reg [10:0] ch3_kanal,
    output reg [10:0] ch4_kanal,
    output reg [10:0] ch5_kanal,
    output reg [10:0] ch6_kanal,
    output reg [10:0] ch7_kanal,
    output reg [10:0] ch8_kanal,
    output reg [10:0] ch9_kanal,
    output reg [10:0] ch10_kanal,
    output reg [10:0] ch11_kanal,
    output reg [10:0] ch12_kanal,
    output reg [10:0] ch13_kanal
    
    
);

    localparam s_idle    = 2'b00,
               s_collect = 2'b01,
               s_verify  = 2'b10;

    reg [1:0] state;
    reg [4:0] byte_sayac;         
    reg [7:0] sbus_paket [0:24];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state        <= s_idle;
            byte_sayac   <= 0;
            paket_dogru  <= 0;
            ch1_roll     <= 11'd1024; 
            ch2_pitch    <= 11'd1024;
            ch3_kanal <= 11'd1024;
            ch4_kanal<=11'd1024;
            ch5_kanal<=11'd1024;
            ch6_kanal<=11'd1024;
            ch7_kanal<=11'd1024;
            ch8_kanal<=11'd1024;
            ch9_kanal <=11'd1024;
            ch10_kanal<=11'd1024;
            ch11_kanal<=11'd1024;
            ch12_kanal<=11'd1024;
            ch13_kanal<=11'd1024;
            
            
            
            
            
            
        end 
        else begin
            paket_dogru <= 0; 

            case (state)
                s_idle: begin
                    byte_sayac <= 0;
                    if (rx_bitti && (gelen_veri == 8'h0F)) begin
                        sbus_paket[0] <= gelen_veri; 
                        byte_sayac    <= 1;          
                        state         <= s_collect;  
                    end
                end

                s_collect: begin
                    if (rx_bitti) begin
                        sbus_paket[byte_sayac] <= gelen_veri;
                        
                        if (byte_sayac < 24) begin
                            byte_sayac <= byte_sayac + 1;
                        end 
                        else begin
                            state <= s_verify; 
                        end
                    end
                end

                s_verify: begin
                  
                    if (sbus_paket[24] == 8'h00) begin
                        paket_dogru <= 1'b1;
                        
                        
                        ch1_roll  <= { sbus_paket[2][2:0], sbus_paket[1] };
                        ch2_pitch <= { sbus_paket[3][5:0], sbus_paket[2][7:3] };
                        ch3_kanal <= { sbus_paket[5][0], sbus_paket[4],sbus_paket[3][7:6]};
                        ch4_kanal <={sbus_paket[6][3:0],sbus_paket[5][7:1]};
                        ch5_kanal<={sbus_paket[7][6:0],sbus_paket[6][7:4]};
                        ch6_kanal<={sbus_paket[9][1:0],sbus_paket[8],sbus_paket[7][7]};
                        ch7_kanal<={sbus_paket[10][4:0],sbus_paket[9][7:2]};
                        ch8_kanal<={sbus_paket[11][7:0],sbus_paket[10][7:5]};
                        ch9_kanal  <= 11'd1024;
                        ch10_kanal <= 11'd1024;
                        ch11_kanal <= 11'd1024;
                        ch12_kanal <= 11'd1024;
                        ch13_kanal <= 11'd1024;
                    end
                    state <= s_idle;
                end

                default: state <= s_idle;
            endcase
        end
    end

endmodule