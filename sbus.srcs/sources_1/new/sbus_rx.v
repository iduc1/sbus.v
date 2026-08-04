`timescale 1ns / 1ps

module sbus_rx(
    input clk,
    input reset,
    input rx,
    output reg [7:0] veri_cik,
    output reg rx_bitti 
);

   
    wire rx_inv;
    assign rx_inv = ~rx; 

    localparam s_idle  = 3'b000,
               s_start = 3'b001,
               s_data  = 3'b010,
               s_stop  = 3'b011,
               s_stop2 = 3'b100;
               
    localparam baud_limit = 868;
    localparam half_baud  = 434;     
    
    reg [2:0]  state;
    reg [16:0] baud_sayac;
    reg [2:0]  bit_sayac;
    reg [7:0]  shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= s_idle;
            baud_sayac  <= 0;
            bit_sayac   <= 0;
            shift_reg   <= 0;
            veri_cik    <= 0;
            rx_bitti    <= 0;
        end 
        else begin
            rx_bitti <= 0;
            
            case (state)
                s_idle: begin
            baud_sayac <= 0;
            bit_sayac  <= 0;
            if (rx_inv == 1'b0) begin
            state <= s_start;
                    end 
                end

                s_start: begin
                    if(baud_sayac < half_baud) begin
                     baud_sayac <= baud_sayac + 1;
                    end 
                    else begin
                        baud_sayac <= 0;
                        if (rx_inv == 1'b0) begin
                         state <= s_data;
                        end 
                        else begin
                            state <= s_idle;
                        end
                    end
                end

               s_data: begin
               if(baud_sayac < baud_limit) begin
               baud_sayac <= baud_sayac + 1;
                    end 
                    else begin
                     baud_sayac <= 0;
                     shift_reg  <= {rx_inv, shift_reg[7:1]}; 
                        
                        if (bit_sayac < 7) begin
                            bit_sayac <= bit_sayac + 1; 
                        end 
                        else begin
                            bit_sayac <= 0;
                            state     <= s_stop;
                        end
                    end
                end

                s_stop: begin
                    if (baud_sayac < baud_limit) begin
                        baud_sayac <= baud_sayac + 1;
                    end 
                    else begin
                        baud_sayac <= 0;
                        state      <= s_stop2;
                    end
                end

                s_stop2: begin
                    if(baud_sayac < baud_limit) begin
                     baud_sayac <= baud_sayac + 1;
                    end 
                    else begin
                        baud_sayac <= 0;
                        if (rx_inv == 1'b1) begin
                         veri_cik <= shift_reg; 
                         rx_bitti <= 1'b1;
                        end
                        state <= s_idle;
                        end
                        end
                
                           default: state <= s_idle;
                           endcase
                           end
                           end
    
endmodule
