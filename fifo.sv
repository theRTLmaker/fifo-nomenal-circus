module fifo #(
    parameter int WIDTH      = 8,
    parameter int DEPTH      = 16,
    localparam int ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic                 wr_en,
    input  logic                 rd_en,
    input  logic [WIDTH-1:0]     din,
    output logic [WIDTH-1:0]     dout,
    output logic                 full,
    output logic                 empty
);

    // Memory array
    logic [WIDTH-1:0]            mem [0:DEPTH-1];
    // Write and read pointers (one extra bit for full/empty detection)
    logic [ADDR_WIDTH:0]         wr_ptr, rd_ptr;

    // Write pointer and memory write
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= din;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read pointer
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= '0;
        end else if (rd_en && !empty) begin
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Output data
    assign dout  = mem[rd_ptr[ADDR_WIDTH-1:0]];

    // Full when pointers have wrapped differently and address bits match
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);
    // Empty when pointers are equal
    assign empty = (wr_ptr == rd_ptr);

endmodule : fifo
