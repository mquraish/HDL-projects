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
integer i, j;

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

    if ((empty_i == 0) && (empty_d1 == 1)) begin
        read_addr_fwft <= read_addr + 1;
    end
    else if (empty_i == 1) begin
        read_addr_fwft <= read_addr;
    end
    else if (read_enable == 1) begin
        read_addr_fwft <= read_addr_fwft + 1;
    end

    if (fifo_flush == 1) begin
        read_addr <= write_addr_dec;
    end
    else if (read_enable == 1) begin
        read_addr <= read_addr + 1;
    end

    write_addr_gray_r1 <= write_addr_gray;
    write_addr_gray_r2 <= write_addr_gray_r1;

    for(i=0; i<AWIDTH-1; i++) begin
        xor_reduce_v = 0;
        for (j=0; j<AWIDTH-1; j++) begin
            xor_reduce_v = xor_reduce_v ^ write_addr_gray_r2[j]
        end
        write_addr_dec[i] <= xor_reduce_v;
    end

    if(fifo_flush == 1) begin
        empty_i <= 1;
    end
    else if (((write_addr_dec = read_addr) || ((write_addr_dec = read_addr +1) && (read_enable == 1))) begin
        empty_i <= 1;
    end
    else begin
        empty_i <= 0;
    end

    if(fifo_flush == 1) begin
        empty_d1 <= 1;
    end
    else begin
        empty_d1 < empty_i;
    end

    if(fifo_flush == 1) begin
        empty_fwft <= 1;
    end
    else if (((write_addr_dec = read_addr) || (empty_i == 1) || ((write_addr_dec = read_addr +1) && (read_enable == 1))) begin
        empty_fwft <= 1;
    end
    else begin
        empty_fwft <= 0;
    end


    if(fifo_flush == 1) begin
        depth_i <= 0;
    end
    else begin
        if(read_enable == 1) begin
            depth_i <= write_addr_dec - (read_addr + 1);
        end
        else begin
            depth_i <= write_addr_dec - read_addr;
        end
    end

    if(depth_i >= ALMOST_FULL_THOLD) begin
        almost_full_i <= 1;
    end
    else begin
        almost_full_i <= 0;
    end
end

assign empty = (FIRST_WORD_FALL_THRU)? empty_fwft : empty_i;
assign depth = depth_i;
assign almost_full = almost_full_r2;

endmodule











