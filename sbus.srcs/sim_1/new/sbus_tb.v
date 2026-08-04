`timescale 1ns / 1ps

module sbus_top_tb();

    // 1. SİNYAL TANIMLAMALARI
    reg clk;
    reg reset;
    reg rx;
    
    wire paket_dogru;
    wire [10:0] ch1_roll;
    wire [10:0] ch2_pitch;
    wire [10:0] ch3_kanal;
    wire [10:0] ch4_kanal;
    wire [10:0] ch5_kanal;
    wire [10:0] ch6_kanal;
    wire [10:0] ch7_kanal;
    wire [10:0] ch8_kanal;

    // 2. YENİ ÜST MODÜLÜN (UUT) BAĞLANMASI
    sbus_top uut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .paket_dogru(paket_dogru),
        .ch1_roll(ch1_roll),
        .ch2_pitch(ch2_pitch),
        .ch3_kanal(ch3_kanal),
        .ch4_kanal(ch4_kanal),
        .ch5_kanal(ch5_kanal),
        .ch6_kanal(ch6_kanal),
        .ch7_kanal(ch7_kanal),
        .ch8_kanal(ch8_kanal)
    );

    // 3. 100 MHz CLOCK ÜRETİMİ
    always begin
        #5 clk = ~clk;
    end

    // 4. BYTE GÖNDERME GÖREVİ (TASK)
    task sbus_byte_gonder(input [7:0] veri);
        integer i;
        reg [7:0] ters_veri;
        begin
            ters_veri = ~veri; 
            // Start Biti (1)
            rx = 1; #8680;
            // Veri Bitleri (LSB -> MSB)
            for (i = 0; i < 8; i = i + 1) begin
                rx = ters_veri[i];
                #8680;
            end
            // 2 Stop Biti (0)
            rx = 0; #17360; 
        end
    endtask

    // 5. ANA SİMÜLASYON SENARYOSU
    initial begin
        // Başlangıç değerleri
        clk = 0;
        reset = 1;
        rx = 0; 
        #100;
        reset = 0;
        #20;

        // =========================================================
        // ✈️ 25 BYTE'LIK ÖZEL TEST PAKETİ GÖNDERİMİ
        // =========================================================
        // Bu byte dizilimi ilk kanalları belirli test değerlerine çeker:
        // Ch1 (Roll)  -> 11'h3FF (Onluk tabanda 1023)
        // Ch2 (Pitch) -> 11'h5AA (Onluk tabanda 1450)
        // =========================================================
        
        sbus_byte_gonder(8'h0F);  // Byte 0  (Start Byte)
        
        // Kanalları besleyen kritik veri byte'ları (Byte 1 - Byte 23)
        sbus_byte_gonder(8'hFF);  // Byte 1
        sbus_byte_gonder(8'hAB);  // Byte 2
        sbus_byte_gonder(8'h16);  // Byte 3
        sbus_byte_gonder(8'h00);  // Byte 4
        sbus_byte_gonder(8'h00);  // Byte 5
        sbus_byte_gonder(8'h00);  // Byte 6
        sbus_byte_gonder(8'h00);  // Byte 7
        sbus_byte_gonder(8'h00);  // Byte 8
        sbus_byte_gonder(8'h00);  // Byte 9
        sbus_byte_gonder(8'h00);  // Byte 10
        sbus_byte_gonder(8'h00);  // Byte 11
        sbus_byte_gonder(8'h00);  // Byte 12
        sbus_byte_gonder(8'h00);  // Byte 13
        sbus_byte_gonder(8'h00);  // Byte 14
        sbus_byte_gonder(8'h00);  // Byte 15
        sbus_byte_gonder(8'h00);  // Byte 16
        sbus_byte_gonder(8'h00);  // Byte 17
        sbus_byte_gonder(8'h00);  // Byte 18
        sbus_byte_gonder(8'h00);  // Byte 19
        sbus_byte_gonder(8'h00);  // Byte 20
        sbus_byte_gonder(8'h00);  // Byte 21
        sbus_byte_gonder(8'h00);  // Byte 22
        sbus_byte_gonder(8'h00);  // Byte 23
        
        sbus_byte_gonder(8'h00);  // Byte 24 (End Byte)
        
        // Paketin işlenmesi ve çıkışların izlenmesi için biraz bekle
        #5000;
        
        // Simülasyonu sonlandır
        $finish;
    end

endmodule