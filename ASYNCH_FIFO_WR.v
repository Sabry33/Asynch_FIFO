module ASYNCH_FIFO_WR #(parameter PTR_SIZE=4)
(
 input  wire                  winc ,
 input  wire                  wrst_n,wclk,
 input  wire  [PTR_SIZE-1:0]  wq2_gray_rptr ,
 output reg   [PTR_SIZE-2:0]  waddr,
 output wire   [PTR_SIZE-1:0] gray_wr_ptr, 
 output wire                  wfull
 
);

reg [PTR_SIZE-1:0] bn_wptr; //binary write pointer 
assign gray_wr_ptr = bn_wptr ^ (bn_wptr>>1); //gray write pointer
assign wfull = (gray_wr_ptr[3]!=wq2_gray_rptr[3]) && (gray_wr_ptr[2]!=wq2_gray_rptr[2]) && (gray_wr_ptr[1:0]==wq2_gray_rptr[1:0]);
//assign waddr = bn_wptr[PTR_SIZE-2:0];


always @(posedge wclk or negedge  wrst_n)
begin 
    if(!wrst_n)
    begin 
        waddr<='b0;
        bn_wptr<='b0;

    end
    else 
     begin 
        if(!wfull && winc) begin 
            bn_wptr<=bn_wptr+1'b1;
            waddr <= bn_wptr[PTR_SIZE-2:0];


        end
     end
end




endmodule