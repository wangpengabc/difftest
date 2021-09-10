/***************************************************************************************
* Copyright (c) 2020-2021 Institute of Computing Technology, Chinese Academy of Sciences
* Copyright (c) 2020-2021 Peng Cheng Laboratory
*
* XiangShan is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

import "DPI-C" function void ram_write_helper
(
  input  longint    wIdx,
  input  longint    wdata,
  input  longint    wmask,
  input  bit        wen
);

import "DPI-C" function longint ram_read_helper
(
  input  bit        en,
  input  longint    rIdx
);

import "DPI-C" function shortint put_helper
(
  input  bit        en,
  input  byte       ch
);

module PUTCHHelper(
  input        clk,
  input         en,
  input  [7:0]  ch
);

    //always @(posedge clk) begin
      //put_helper(en, ch);
    //end

    wire [7:0] put_re;
    assign put_re = put_helper(en, ch);
endmodule

module RAMHelper(
  input         clk,
  input         en,
  input  [63:0] rIdx,
  output [63:0] rdata,
  input  [63:0] wIdx,
  input  [63:0] wdata,
  input  [63:0] wmask,
  input         wen
);

  assign rdata = ram_read_helper(en, rIdx);

  always @(posedge clk) begin
    ram_write_helper(wIdx, wdata, wmask, wen && en);
  end

endmodule

module RAMHelper_1W2R(
input         clk,
input         i_en,
input  [63:0] i_rIdx,
output [63:0] i_rdata,
input         d_en,
input  [63:0] d_rIdx,
output [63:0] d_rdata,
input  [63:0] wIdx,
input  [63:0] wdata,
input  [63:0] wmask,
input         wen
);

assign i_rdata = ram_read_helper(i_en, i_rIdx);
assign d_rdata = ram_read_helper(d_en, d_rIdx);

always @(posedge clk) begin
ram_write_helper(wIdx, wdata, wmask, wen && d_en);
end

endmodule
