`timescale 1ns / 1ps

module ALU_TB();
    logic [15:0] instruction;
    logic [7:0] data0;
    logic [7:0] data1;
    logic [7:0] out0, out1, out2, out3;
    logic overflow_flag;
    logic zero_flag;

    ALU dut (
        .instruction(instruction),
        .data0(data0),
        .data1(data1),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .overflow_flag(overflow_flag),
        .zero_flag(zero_flag)
    );

initial begin
        $display("Time\t Instr\t D0\t D1\t O0\t O1\t O2\t O3\t OV\t Z");
        $monitor("%0t\t %h\t %d\t %d\t %d\t %d\t %d\t %d\t %b\t %b", $time, instruction, data0, data1, out0, out1, out2, out3, overflow_flag, zero_flag);

        instruction = 16'hF000;
        data0 = 8'd129; data1 = 8'd129; 
        #10;

        instruction = 16'h0800; 
        data0 = 8'd200; data1 = 8'd150;
        #10; 

        instruction = 16'h5000;
        data0 = 8'hAA; data1 = 8'h55;
        #10;

        instruction = 16'h8400;
        data0 = 8'd7; data1 = 8'd2; 
        #10;

        instruction = 16'h0C00;
        data0 = 8'd42; data1 = 8'd42; 
        #10;

        instruction = 16'hD400;
        data0 = 8'd100; data1 = 8'd20;
        #10;

        $display("Merge");
        $finish;
    end
endmodule
