/*
 * fir_xifu_pkg.sv
 * Francesco Conti <f.conti@unibo.it>
 *
 * Copyright (C) 2024 ETH Zurich, University of Bologna
 * Copyright and related rights are licensed under the Solderpad Hardware
 * License, Version 0.51 (the "License"); you may not use this file except in
 * compliance with the License.  You may obtain a copy of the License at
 * http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
 * or agreed to in writing, software, hardware and materials distributed under
 * this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 *
 */

package fir_xifu_pkg;

  // Width of XIF ID field
  parameter int unsigned X_ID_WIDTH = 4;
  parameter int unsigned X_ID_MAX   = 2**X_ID_WIDTH;

  // placeholder for actual opcode
  parameter logic [6:0] INSTR_OPCODE = 7'b0;

  // placeholder for xfirdotp funct3
  parameter logic [2:0] INSTR_XFIRDOTP_FUNCT3 = 3'b000;

  // placeholder for xfirlw funct3
  parameter logic [2:0] INSTR_XFIRLW_FUNCT3 = 3'b000;

  // placeholder for xfirsw funct3
  parameter logic [2:0] INSTR_XFIRSW_FUNCT3 = 3'b000;

  // placeholder: you can remove this line after you fix the ID stage
  parameter logic [2:0] INSTR_PLACEHOLDER_FUNCT3 = 3'b000;

  function automatic logic [2:0] xifu_get_funct3(logic [31:0] in);
    logic [2:0] out;
    out = in[14:12];
    return out;
  endfunction

  function automatic logic [6:0] xifu_get_opcode(logic [31:0] in);
    logic [6:0] out;
    out = in[6:0];
    return out;
  endfunction

  function automatic logic [11:0] xifu_get_immediate_I(logic [31:0] in);
    logic [11:0] out;
    out = in[31:20];
    return out;
  endfunction

  function automatic logic [11:0] xifu_get_immediate_S(logic [31:0] in);
    logic [11:0] out;
    out = {in[31:25], in[11:7]};
    return out;
  endfunction

  function automatic logic [4:0] xifu_get_rs1(logic [31:0] in);
    logic [4:0] out;
    out = in[19:15];
    return out;
  endfunction

  function automatic logic [4:0] xifu_get_rs2(logic [31:0] in);
    logic [4:0] out;
    out = in[24:20];
    return out;
  endfunction

  function automatic logic [4:0] xifu_get_rd(logic [31:0] in);
    logic [4:0] out;
    out = in[11:7];
    return out;
  endfunction

  typedef enum logic[1:0] {
    INSTR_XFIRLW   = 2'b10,
    INSTR_XFIRSW   = 2'b11,
    INSTR_XFIRDOTP = 2'b01,
    INSTR_INVALID  = 2'b00
  } instr_t;
    
  typedef struct packed {
    instr_t instr;
    logic [31:0] base;
    logic [11:0] offset;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd; // also right_shift
    logic [X_ID_WIDTH-1:0] id;
  } id2ex_t;
    
  typedef struct packed {
    instr_t instr;
    logic [31:0] result;
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
    logic [X_ID_WIDTH-1:0] id;
  } ex2wb_t;

  typedef struct packed {
    logic [4:0]  rd;
    logic [31:0] result;
    logic       we;
  } wb_fwd_t;

  typedef struct packed {
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;
  } ex2regfile_t;

  typedef struct packed {
    logic [31:0] op_a;
    logic [31:0] op_b;
    logic [31:0] op_c;
  } regfile2ex_t;

  typedef struct packed {
    logic [31:0] result;
    logic [4:0]  rd;
    logic        write;
  } wb2regfile_t;

  typedef struct packed {
    logic                  issue;
    logic [X_ID_WIDTH-1:0] id;
  } id2ctrl_t;

  typedef struct packed {
    logic [X_ID_MAX-1:0] commit;
  } ctrl2ex_t;

  typedef struct packed {
    logic [X_ID_MAX-1:0] clear;
  } wb2ctrl_t;

  typedef struct packed {
    logic [X_ID_MAX-1:0] issue;
    logic [X_ID_MAX-1:0] commit;
    logic [X_ID_MAX-1:0] kill;
  } ctrl2wb_t;

endpackage /* fir_xifu_pkg */
