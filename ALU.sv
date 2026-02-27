`timescale 1ns / 1ps

module ALU(
    input  logic clk, 
    input  logic rst,
    input  logic [15:0] instruction,
    input  logic [7:0] data0, data1,
    output logic [7:0] out0, out1, out2, out3,
    output logic overflow_flag, zero_flag
);
    logic [7:0] res_arith, res_logic, final_res;
    logic [8:0] sum_full; 

    logic special_val;
    
    assign special_val = (data0[7] == data0[0]) && (data1[7] == data1[0]) && (data0[7] == data1[7]);

    assign sum_full = data0 + data1;
    always_comb begin
        case(instruction[11:10])
            2'b00:res_arith = data0 >> data1;
            2'b01:res_arith = data0 << data1;
            2'b10:res_arith = data0 + data1; 
            2'b11:res_arith = data0 - data1;   
        endcase
    end

    always_comb begin
        case(instruction[11:10])
            2'b00:res_logic = data0 & data1;
            2'b01:res_logic = data0 | data1;
            2'b10:res_logic = data0 ^ data1;
            2'b11:res_logic = 8'h01;
        endcase
    end

    always_comb begin
        case(instruction[13:12])
            2'b00:final_res = res_arith;
            2'b01:final_res = res_logic;
            2'b10:final_res = 8'h00;
            2'b11:final_res = {7'b0, special_val};
        endcase
    end

    assign overflow_flag = (instruction[13:12] == 2'b00 && instruction[11:10] == 2'b10) ? sum_full[8] : 1'b0;
    assign zero_flag = (final_res == 8'h00);

    always_comb begin
        {out0, out1, out2, out3} = 32'h0;
        case(instruction[15:14])
            2'b00:out0 = final_res;
            2'b01:out1 = final_res;
            2'b10:out2 = final_res;
            2'b11:out3 = final_res;
        endcase
    end
    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            {out0, out1, out2, out3} <= 32'h0;
            overflow_flag <= 1'b0;
            zero_flag     <= 1'b0;
        end else begin
            overflow_flag <= (instruction[13:10] == 4'b0010) && sum_full[8];
            zero_flag     <= (final_res == 8'h00);
            
            {out0, out1, out2, out3} <= 32'h0;
            case(instruction[15:14])
                2'b00: out0 <= final_res;
                2'b01: out1 <= final_res;
                2'b10: out2 <= final_res;
                2'b11: out3 <= final_res;
            endcase
        end
    end
    
endmodule
