// fifo.v
module fifo #(
  parameter WIDTH = 8,
  parameter DEPTH = 16
) (
  input               clk,
  input               rst_n,
  input               wr_en,
  input               rd_en,
  input  [WIDTH-1:0]  din,
  output [WIDTH-1:0]  dout,
  output              full,
  output              empty
);

  localparam ADDR_WIDTH = $clog2(DEPTH);

  reg [WIDTH-1:0] mem [0:DEPTH-1];
  reg [ADDR_WIDTH:0] wr_ptr, rd_ptr; // extra bit for full/empty detect

  // write logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr <= 0;
    end else if (wr_en && !full) begin
      mem[wr_ptr[ADDR_WIDTH-1:0]] <= din;
      wr_ptr <= wr_ptr + 1;
    end
  end

  // read logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_ptr <= 0;
    end else if (rd_en && !empty) begin
      rd_ptr <= rd_ptr + 1;
    end
  end

  assign dout  = mem[rd_ptr[ADDR_WIDTH-1:0]];
  assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                 (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);
  assign empty = (wr_ptr == rd_ptr);

endmodule