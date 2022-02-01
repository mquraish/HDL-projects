`default_nettype none
`timescale 1ns/1ns

module alu
  #(parameter int data_width = 12,
    parameter int instruction_width = 12)
   (input wire clk,

    // Active high reset
    input wire rst,

    // Instructions for the ALU to perform, a new instruction will be
    // given each clock cycle.
    input wire [instruction_width-1:0] instruction,

    // Data output from the ALU, its value is considered undefined if
    // out_valid is deasserted.
    output logic [data_width-1:0]      out_data,
    output logic                       out_valid,

    // Stop execution if asserted
    output logic                       halt);

    // The ALU should have four 12 bits general purpose register.
    localparam int num_registers = 4;
    reg [11:0] R0;
    reg [11:0] R1;
    reg [11:0] R2;
    reg [11:0] R3;

    // Your code here...

    //internal wires
    logic carry;
    logic [3:0] opcode;
    logic [11:0] Rd;
    logic [11:0] Rx;
    logic [11:0] Ry;
    logic [1:0] Rdn;
    logic [1:0] Rxn;
    logic [1:0] Ryn;
    logic [5:0] immediate;

    
    //ALU Operation
    always@* begin

      Rd = 12'b0;
      out_valid = 1'b0;
      out_data = 12'b0;
      halt = 1'b0;
     
  
      case(opcode)
      4'b0000: Rd = Rx | Ry;
      4'b0001: Rd = Rx ^ Ry;
      4'b0010: Rd = Rx & Ry;
      4'b0011: Rd = ~Rx;
      4'b0100: Rd = Rx << 1;
      4'b0101: Rd = Rx >> 1;
      4'b0110: Rd = {Rx[11], Rx[11:1]};
      4'b0111: {carry, Rd} = {1'b0, Rx} + {1'b0, Ry};
      4'b1000: {carry, Rd} = {1'b0, Rx} + {1'b0, Ry} + carry;
      4'b1001: Rd = Rx - Ry;
      4'b1010: Rd[5:0] = immediate;
      4'b1011: Rd[11:6] = immediate;
      4'b1100: begin
            out_data = Rx;
            out_valid = 1'b1;
            end
      4'b1101: begin
            out_data = Rx;
            out_valid = 1'b1;
            halt = 1'b1;
            end
      default: begin
            Rd = 12'b0;
            out_valid = 1'b0;
            out_data = 12'b0;
            halt = 1'b0;
      end
      endcase
    end
    
    assign opcode = instruction[11:8];
    assign immediate = instruction[5:0];
    assign Rdn = instruction [7:6];
    assign Rxn = instruction [5:4];
    assign Ryn = instruction [3:2];

    //Write output result from ALU
    always@(posedge clk) begin
      if(rst) begin
        R0 <= 12'b0;
        R1 <= 12'b0;
        R2 <= 12'b0;
        R3 <= 12'b0;
      end

      else begin
        if(opcode == 4'hC || opcode == 4'hD) begin
          R0 <= R0;
          R1 <= R1;
          R2 <= R2;
          R3 <= R3;
        end
        else begin
        case (Rdn)
          2'b00: R0 <= Rd;
          2'b01: R1 <= Rd;
          2'b10: R2 <= Rd;
          2'b11: R3 <= Rd;
          default: begin
            R0 <= 12'b0;
            R1 <= 12'b0;
            R2 <= 12'b0;
            R3 <= 12'b0;
          end
        endcase
        end
      end
    end

    //Read input for ALU
    always@* begin
      Rx = 12'b0;
      case (Rxn)
      2'b00: Rx = R0;
      2'b01: Rx = R1;
      2'b10: Rx = R2;
      2'b11: Rx = R3;
      default: Rx = 12'b0;
      endcase
    end

    always@* begin
      Ry = 12'b0;
      case (Ryn)
      2'b00: Ry = R0;
      2'b01: Ry = R1;
      2'b10: Ry = R2;
      2'b11: Ry = R3;
      default: Ry = 12'b0;
      endcase
    end    
endmodule
