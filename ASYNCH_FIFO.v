module ASYNCH_FIFO #(parameter PTR_WIDTH = 4, WIDTH = 8)
(
    input wire             W_CLK, W_RST, W_INC,
    input wire             R_CLK, R_RST, R_INC,
    input wire [WIDTH-1:0] WR_DATA,
    output wire [WIDTH-1:0] RD_DATA,
    output wire            FULL, EMPTY
);

// Internal signals
wire [PTR_WIDTH-1:0] sync_gray_rptr, sync_gray_wptr;
wire [PTR_WIDTH-1:0] gray_wptr, gray_rptr;
wire [PTR_WIDTH-2:0] r_address, w_address;

// Submodule instantiation
RegFile  #(.DATA_WIDTH(WIDTH), .PTR_SIZE(PTR_WIDTH)) U0_RegFile
(
    .wclk(W_CLK),
    .wrst_n(W_RST),
    .wrclken(W_INC && !FULL),
    .waddr(w_address),
    .raddr(r_address),
    .WrData(WR_DATA),
    .RdData(RD_DATA)
);

ASYNCH_FIFO_RD #(.PTR_SIZE(PTR_WIDTH)) U0_ASYNCH_FIFO_RD
(
    .rinc(R_INC),
    .rrst_n(R_RST),
    .rclk(R_CLK),
    .rq2_gray_wptr(sync_gray_wptr),
    .raddr(r_address),
    .gray_rd_ptr(gray_rptr),
    .rempty(EMPTY)
);

ASYNCH_FIFO_WR #(.PTR_SIZE(PTR_WIDTH)) U0_ASYNCH_FIFO_WR
(
    .winc(W_INC),
    .wrst_n(W_RST),
    .wclk(W_CLK),
    .wq2_gray_rptr(sync_gray_rptr),
    .waddr(w_address),
    .gray_wr_ptr(gray_wptr),
    .wfull(FULL)
);

MULTIPLE_FLOP_SYNCH #(.NUM_STAGES(2), .BUS_WIDTH(PTR_WIDTH)) U0_MULTIPLE_FLOP_SYNCH
(
    .CLK(W_CLK),
    .RST(W_RST),
    .ASYNC(gray_rptr),
    .SYNC(sync_gray_rptr)
);

MULTIPLE_FLOP_SYNCH #(.NUM_STAGES(2), .BUS_WIDTH(PTR_WIDTH)) U1_MULTIPLE_FLOP_SYNCH
(
    .CLK(R_CLK),
    .RST(R_RST),
    .ASYNC(gray_wptr),
    .SYNC(sync_gray_wptr)
);

endmodule
