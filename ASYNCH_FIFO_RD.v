module ASYNCH_FIFO_RD #(parameter PTR_SIZE=4)
(
 input  wire                  rinc ,
 input  wire                  rrst_n,rclk,
 input  wire  [PTR_SIZE-1:0]  rq2_gray_wptr ,
 output reg   [PTR_SIZE-2:0]  raddr,
 output wire   [PTR_SIZE-1:0]  gray_rd_ptr,
 output wire                   rempty
 
);
reg [PTR_SIZE-1:0] bn_rptr; // three bits to accsess the memory and the 4th one to differentiate between empty and full  flags conditions

assign gray_rd_ptr = bn_rptr ^ (bn_rptr>>1);
assign rempty = (gray_rd_ptr==rq2_gray_wptr);
//assign raddr=bn_rptr[PTR_SIZE-2:0];
always @(posedge rclk or negedge  rrst_n)
begin 
    if(!rrst_n)
    begin 
        raddr<='b0;
        bn_rptr<='b0;

    end
    else 
     begin 
        if(!rempty && rinc) begin 
            bn_rptr<=bn_rptr+1'b1;
            raddr<=bn_rptr[PTR_SIZE-2:0];


        end
     end
end

endmodule