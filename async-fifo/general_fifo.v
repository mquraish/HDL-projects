/*
This is a general asynchronous FIFO, developed using the Nallatech FIFO IP. 
The original IP is developed in VHDL.
*/


module general_fifo #(parameter DWIDTH = 32,
                      parameter AWIDTH = 9,
                      parameter ALMOST_FULL_THOLD = 500,
                      parameter FIRST_WORD_FALL_THRU = 0)(
    input write_clock,
    input read_clock,
    input fifo_flush,
    input write_enable,
    input [DWIDTH-1:0] write_data,
    input read_enable,
    output [DWIDTH-1:0] read_data;
    output almost_full,
    output [AWIDTH-1:0] depth,
    output empty
);

reg [DWIDTH-1:0] ram [2**AWIDTH-1:0];
integer i;

//write clock domain
//TODO: We might need a write_reset
always@(posedge write_clock) begin
    if(write_enable==1) begin
        ram[write_addr] <= write_data;
        write_addr <= write_addr + 1;
    end

    write_addr_gray[AWIDTH-1] <= write_addr[AWIDTH=1];
    for(i=0; i<AWIDTH-1; i++) begin
        write_addr_gray[i] <= write_addr[i] ^ write_addr[i+1];
    end
    almost_full_r1 <= almost_full_i;
    almost_full_r2 <= almost_full_r1;
end

//read clock domain
always@(posedge read_clock) begin
    if (FIRST_WORD_FALL_THRU == 1) begin
        if((empty_i == 0) && (empty_d1 == 1) || (read_enable == 1)) begin
            read_data <= ram[read_addr_fwft];
        end
        else begin
            if(read_enable == 1) begin
                read_data <= ram[read_addr];
            end
        end
    end

    