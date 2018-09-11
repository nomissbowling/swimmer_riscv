#!/bin/ruby
#
# Copyright (c) 2015, Masayuki Kimura
# All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions are met:
#   * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#   * Neither the name of the Masayuki Kimura nor the
#     names of its contributors may be used to endorse or promote products
#     derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL MASAYUKI KIMURA BE LIABLE FOR ANY
#   DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#   ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#


require "../script/decode_table.rb"

$arch_name = "riscv"
$arch_inst_mod = ""

$arch_table = Array[]  # instruction table

$arch_list_def = Hash.new()


$arch_list_def["NAME"]        = 0
$arch_list_def["LENGTH"]      = 1
$arch_list_def["DLENGTH"]     = 2
$arch_list_def["R3"]          = 3
$arch_list_def["F2"]          = 4
$arch_list_def["R2"]          = 5
$arch_list_def["R1"]          = 6
$arch_list_def["F3"]          = 7
$arch_list_def["RD"]          = 8
$arch_list_def["OP"]          = 9
$arch_list_def["LD"]          = 10
$arch_list_def["CATEGORY"]    = 11
$arch_list_def["FUNC_SUFFIX"] = 12
$arch_list_def["IMPL"]        = 13
$arch_list_def["TAIL"]        = 14

$decode_field_list = Array[DecodeFieldInfo.new("R3", $arch_list_def["R3"], 31, 27),
                           DecodeFieldInfo.new("F2", $arch_list_def["F2"], 26, 25),
                           DecodeFieldInfo.new("R2", $arch_list_def["R2"], 24, 20),
                           DecodeFieldInfo.new("R1", $arch_list_def["R1"], 19, 15),
                           DecodeFieldInfo.new("F3", $arch_list_def["F3"], 14, 12),
                           DecodeFieldInfo.new("RD", $arch_list_def["RD"], 11,  7),
                           DecodeFieldInfo.new("OP", $arch_list_def["OP"],  6,  2),
                           DecodeFieldInfo.new("LD", $arch_list_def["LD"],  1,  0)]


## start of RISC-V instructions
#                       ['BITFIELD'                                                                   BIT, DLength, 31-27,   26-25,    24-20    19-15    14-12     11-07    06-00    ]
#                       ['NAME',                                                                                    'rs3',   'funct2', 'rs2',   'rs1',   'funct3', 'rd',    'opcode' , Category, Support Func, Behavior
#                       ['DECODE-KEY',                                                                              'R3',    'F2'      'R2',    'R1',    'F3',     'RD'     'OP'     ]
$arch_table.push(Array['lui        r[11:7],h[31:12]'                                                , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '01101', '11', 'ALU',    "",           ""])
$arch_table.push(Array['auipc      r[11:7],h[31:12]'                                                , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '00101', '11', 'ALU',    "",           ""])
$arch_table.push(Array['jal        r[11:7],uj[31:12]'                                               , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '11011', '11', 'BRU',    "",           ""])
$arch_table.push(Array['jalr       r[11:7],r[19:15],h[11:0]'                                        , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '000',    'XXXXX', '11001', '11', 'BRU',    "",           ""])
$arch_table.push(Array['beq        r[19:15],r[24:20],u[31:31]|u[7:7]|u[30:25]|u[11:8]<<1'           , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '000',    'XXXXX', '11000', '11', 'BRU',    "",           ""])
$arch_table.push(Array['bne        r[19:15],r[24:20],u[31:31]|u[7:7]|u[30:25]|u[11:8]<<1'           , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '001',    'XXXXX', '11000', '11', 'BRU',    "",           ""])
$arch_table.push(Array['blt        r[19:15],r[24:20],u[31:31]|u[7:7]|u[30:25]|u[11:8]<<1'           , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '100',    'XXXXX', '11000', '11', 'BRU',    "",           ""])
$arch_table.push(Array['bge        r[19:15],r[24:20],u[31:31]|u[7:7]|u[30:25]|u[11:8]<<1'           , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '101',    'XXXXX', '11000', '11', 'BRU',    "",           ""])
$arch_table.push(Array['bltu       r[19:15],r[24:20],u[31:31]|u[7:7]|u[30:25]|u[11:8]<<1'           , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '110',    'XXXXX', '11000', '11', 'BRU',    "",           ""])
$arch_table.push(Array['bgeu       r[19:15],r[24:20],u[31:31]|u[7:7]|u[30:25]|u[11:8]<<1'           , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '111',    'XXXXX', '11000', '11', 'BRU',    "",           ""])
$arch_table.push(Array['lb         r[11:7],h[31:20](r[19:15])'                                      , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '000',    'XXXXX', '00000', '11', 'LSU',    "",           ""])
$arch_table.push(Array['lh         r[11:7],h[31:20](r[19:15])'                                      , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '001',    'XXXXX', '00000', '11', 'LSU',    "",           ""])
$arch_table.push(Array['lw         r[11:7],h[31:20](r[19:15])'                                      , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '00000', '11', 'LSU',    "",           ""])
$arch_table.push(Array['lbu        r[11:7],h[31:20](r[19:15])'                                      , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '100',    'XXXXX', '00000', '11', 'LSU',    "",           ""])
$arch_table.push(Array['lhu        r[11:7],h[31:20](r[19:15])'                                      , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '101',    'XXXXX', '00000', '11', 'LSU',    "",           ""])
$arch_table.push(Array['sb         r[24:20],h[31:25]|h[11:7](r[19:15])'                             , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '000',    'XXXXX', '01000', '11', 'LSU',    "",           ""])
$arch_table.push(Array['sh         r[24:20],h[31:25]|h[11:7](r[19:15])'                             , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '001',    'XXXXX', '01000', '11', 'LSU',    "",           ""])
$arch_table.push(Array['sw         r[24:20],h[31:25]|h[11:7](r[19:15])'                             , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01000', '11', 'LSU',    "",           ""])
$arch_table.push(Array['addi       r[11:7],r[19:15],h[31:20]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '000',    'XXXXX', '00100', '11', 'ALU',    "",           ["XS", "XS", "IS", "return m_pe_thread->SExtXlen(op1 +  op2)"]])
$arch_table.push(Array['slti       r[11:7],r[19:15],h[31:20]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '00100', '11', 'ALU',    "",           ["XS", "XS", "IU", "return m_pe_thread->SExtXlen(op1 <  op2)"]])
$arch_table.push(Array['sltiu      r[11:7],r[19:15],h[31:20]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '00100', '11', 'ALU',    "",           ["XU", "XU", "IU", "return m_pe_thread->SExtXlen(op1 <  op2)"]])
$arch_table.push(Array['xori       r[11:7],r[19:15],h[31:20]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '100',    'XXXXX', '00100', '11', 'ALU',    "",           ["XS", "XS", "IS", "return m_pe_thread->SExtXlen(op1 ^  op2)"]])
$arch_table.push(Array['ori        r[11:7],r[19:15],h[31:20]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '110',    'XXXXX', '00100', '11', 'ALU',    "",           ["XS", "XS", "IS", "return m_pe_thread->SExtXlen(op1 |  op2)"]])
$arch_table.push(Array['andi       r[11:7],r[19:15],h[31:20]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '111',    'XXXXX', '00100', '11', 'ALU',    "",           ["XS", "XS", "IS", "return m_pe_thread->SExtXlen(op1 &  op2)"]])
$arch_table.push(Array['slli       r[11:7],r[19:15],h[25:20]'                                       , 32,  32,      '00000', '0X',     'XXXXX', 'XXXXX', '001',    'XXXXX', '00100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['srli       r[11:7],r[19:15],h[24:20]'                                       , 32,  32,      '00000', '0X',     'XXXXX', 'XXXXX', '101',    'XXXXX', '00100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['srai       r[11:7],r[19:15],h[24:20]'                                       , 32,  32,      '01000', '0X',     'XXXXX', 'XXXXX', '101',    'XXXXX', '00100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['add        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '000',    'XXXXX', '01100', '11', 'ALU',    "",           ["XS", "XS", "XS", "return m_pe_thread->SExtXlen(op1 +  op2)"]])
$arch_table.push(Array['sub        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '01000', '00',     'XXXXX', 'XXXXX', '000',    'XXXXX', '01100', '11', 'ALU',    "",           ["XS", "XS", "XS", "return m_pe_thread->SExtXlen(op1 -  op2)"]])
$arch_table.push(Array['sll        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '001',    'XXXXX', '01100', '11', 'ALU',    "",           ["XS", "XS", "XS", "return m_pe_thread->SExtXlen(op1 << op2)"]])
$arch_table.push(Array['slt        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01100', '11', 'ALU',    "",           ["XS", "XS", "XS", "return m_pe_thread->SExtXlen(op1 <  op2)"]])
$arch_table.push(Array['sltu       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01100', '11', 'ALU',    "",           ["XU", "XU", "XU", "return m_pe_thread->SExtXlen(op1 <  op2)"]])
$arch_table.push(Array['xor        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '100',    'XXXXX', '01100', '11', 'ALU',    "",           ["XS", "XS", "XS", "return m_pe_thread->SExtXlen(op1 ^  op2)"]])
$arch_table.push(Array['srl        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '101',    'XXXXX', '01100', '11', 'ALU',    "",           ["XU", "XU", "XU", "return m_pe_thread->SExtXlen(m_pe_thread->UExtXlen(op1) >> op2)"]])
$arch_table.push(Array['sra        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '01000', '00',     'XXXXX', 'XXXXX', '101',    'XXXXX', '01100', '11', 'ALU',    "",           ["XS", "XS", "XS", "return m_pe_thread->SExtXlen(op1 >> op2)"]])
$arch_table.push(Array['or         r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '110',    'XXXXX', '01100', '11', 'ALU',    "",           ["XU", "XU", "XU", "return          op1 |  op2 "]])
$arch_table.push(Array['and        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '111',    'XXXXX', '01100', '11', 'ALU',    "",           ["XU", "XU", "XU", "return          op1 &  op2 "]])
$arch_table.push(Array['fence'                                                                      , 32,  32,      '0000X', 'XX',     'XXXXX', '00000', '000',    'XXXXX', '00011', '11', 'ALU',    "",           ""])
$arch_table.push(Array['fence.i'                                                                    , 32,  32,      '00000', '00',     '00000', '00000', '001',    'XXXXX', '00011', '11', 'ALU',    "",           ""])
# $arch_table.push(Array['rdcycle    r[11:7]'                                                       , 32,  32,      '11000', '00',     '00000', '00000', '010',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
# $arch_table.push(Array['rdcycleh   r[11:7]'                                                       , 32,  32,      '11001', '00',     '00000', '00000', '010',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
# $arch_table.push(Array['rdtime     r[11:7]'                                                       , 32,  32,      '11000', '00',     '00001', '00000', '010',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
# $arch_table.push(Array['rdtimeh    r[11:7]'                                                       , 32,  32,      '11001', '00',     '00001', '00000', '010',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
# $arch_table.push(Array['rdinstret  r[11:7]'                                                       , 32,  32,      '11000', '00',     '00010', '00000', '010',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
# $arch_table.push(Array['rdinstreth r[11:7]'                                                       , 32,  32,      '11001', '00',     '00010', '00000', '010',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['mul        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '000',    'XXXXX', '01100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['mulh       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '001',    'XXXXX', '01100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['mulhsu     r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['mulhu      r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['div        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '100',    'XXXXX', '01100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['divu       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '101',    'XXXXX', '01100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['rem        r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '110',    'XXXXX', '01100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['remu       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '111',    'XXXXX', '01100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['lr.w       r[11:7],r[19:15]'                                                , 32,  32,      '00010', 'XX',     '00000', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['sc.w       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00011', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoswap.w  r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '00001', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoadd.w   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '00000', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoxor.w   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '00100', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoand.w   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '01100', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoor.w    r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '01000', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amomin.w   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '10000', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amomax.w   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '10100', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amominu.w  r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '11000', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amomaxu.w  r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '11100', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['flw        f[11:7],h[31:20](r[19:15])'                                      , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '00001', '11', 'LSU',    "",           ""])
$arch_table.push(Array['fsw        f[24:20],h[31:25]|h[11:7](r[19:15])'                             , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '01001', '11', 'LSU',    "",           ""])
$arch_table.push(Array['fmadd.s    f[11:7],f[19:15],f[24:20],f[31:27]'                              , 32,  32,      'XXXXX', '00',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10000', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmsub.s    f[11:7],f[19:15],f[24:20],f[31:27]'                              , 32,  32,      'XXXXX', '00',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10001', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fnmsub.s   f[11:7],f[19:15],f[24:20],f[31:27]'                              , 32,  32,      'XXXXX', '00',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10010', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fnmadd.s   f[11:7],f[19:15],f[24:20],f[31:27]'                              , 32,  32,      'XXXXX', '00',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10011', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fadd.s     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsub.s     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00001', '00',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmul.s     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00010', '00',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fdiv.s     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00011', '00',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsqrt.s    f[11:7],f[19:15]'                                                , 32,  32,      '01011', '00',     '00000', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsgnj.s    f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00100', '00',     'XXXXX', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsgnjn.s   f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00100', '00',     'XXXXX', 'XXXXX', '001',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsgnjx.s   f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00100', '00',     'XXXXX', 'XXXXX', '010',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmin.s     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00101', '00',     'XXXXX', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmax.s     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00101', '00',     'XXXXX', 'XXXXX', '001',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.w.s   r[11:7],f[19:15]'                                                , 32,  32,      '11000', '00',     '00000', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.wu.s  r[11:7],f[19:15]'                                                , 32,  32,      '11000', '00',     '00001', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmv.x.w    r[11:7],f[19:15]'                                                , 32,  32,      '11100', '00',     '00000', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['feq.s      r[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '10100', '00',     'XXXXX', 'XXXXX', '010',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['flt.s      r[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '10100', '00',     'XXXXX', 'XXXXX', '001',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fle.s      r[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '10100', '00',     'XXXXX', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fclass.s   f[11:7],f[19:15]'                                                , 32,  32,      '11100', '00',     '00000', 'XXXXX', '001',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.s.w   f[11:7],r[19:15]'                                                , 32,  32,      '11010', '00',     '00000', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.s.wu  f[11:7],r[19:15]'                                                , 32,  32,      '11010', '00',     '00001', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmv.w.x    f[11:7],r[19:15]'                                                , 32,  32,      '11110', '00',     '00000', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
# $arch_table.push(Array['frcsr      f[11:7]'                                                       , 32,  32,      '00000', '00',     '00011', '00000', '010',    'XXXXX', '11100', '11', 'FPU',    "",           ""])
# $arch_table.push(Array['frrm       f[11:7]'                                                       , 32,  32,      '00000', '00',     '00010', '00000', '010',    'XXXXX', '11100', '11', 'FPU',    "",           ""])
# $arch_table.push(Array['frflags    f[11:7]'                                                       , 32,  32,      '00000', '00',     '00001', '00000', '010',    'XXXXX', '11100', '11', 'FPU',    "",           ""])
# $arch_table.push(Array['fscsr      f[11:7],f[19:15]'                                              , 32,  32,      '00000', '00',     '00011', 'XXXXX', '001',    'XXXXX', '11100', '11', 'FPU',    "",           ""])
# $arch_table.push(Array['fsrm       f[11:7],f[19:15]'                                              , 32,  32,      '00000', '00',     '00010', 'XXXXX', '001',    'XXXXX', '11100', '11', 'FPU',    "",           ""])
# $arch_table.push(Array['fsflags    f[11:7],f[19:15]'                                              , 32,  32,      '00000', '00',     '00001', 'XXXXX', '001',    'XXXXX', '11100', '11', 'FPU',    "",           ""])
# $arch_table.push(Array['fsrmi      f[11:7]'                                                       , 32,  32,      '00000', '00',     '00010', '00000', '101',    'XXXXX', '11100', '11', 'FPU',    "",           ""])
# $arch_table.push(Array['fsflagsi   f[11:7]'                                                       , 32,  32,      '00000', '00',     '00001', '00000', '101',    'XXXXX', '11100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fld        f[11:7],r[19:15],h[31:20]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '00001', '11', 'LSU',    "",           ""])
$arch_table.push(Array['fsd        f[24:20],h[31:25]|h[11:7](r[19:15])'                             , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01001', '11', 'LSU',    "",           ""])
$arch_table.push(Array['fmadd.d    f[11:7],f[19:15],f[24:20],f[31:27]'                              , 32,  32,      'XXXXX', '01',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10000', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmsub.d    f[11:7],f[19:15],f[24:20],f[31:27]'                              , 32,  32,      'XXXXX', '01',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10001', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fnmsub.d   f[11:7],f[19:15],f[24:20],f[31:27]'                              , 32,  32,      'XXXXX', '01',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10010', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fnmadd.d   f[11:7],f[19:15],f[24:20],f[31:27]'                              , 32,  32,      'XXXXX', '01',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10011', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fadd.d     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsub.d     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00001', '01',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmul.d     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00010', '01',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fdiv.d     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00011', '01',     'XXXXX', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsqrt.d    f[11:7],f[19:15]'                                                , 32,  32,      '01011', '01',     '00000', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsgnj.d    f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00100', '01',     'XXXXX', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsgnjn.d   f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00100', '01',     'XXXXX', 'XXXXX', '001',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fsgnjx.d   f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00100', '01',     'XXXXX', 'XXXXX', '010',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmin.d     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00101', '01',     'XXXXX', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmax.d     f[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '00101', '01',     'XXXXX', 'XXXXX', '001',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.s.d   f[11:7],f[19:15]'                                                , 32,  32,      '01000', '00',     '00001', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.d.s   f[11:7],f[19:15]'                                                , 32,  32,      '01000', '01',     '00000', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['feq.d      r[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '10100', '01',     'XXXXX', 'XXXXX', '010',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['flt.d      r[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '10100', '01',     'XXXXX', 'XXXXX', '001',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fle.d      r[11:7],f[19:15],f[24:20]'                                       , 32,  32,      '10100', '01',     'XXXXX', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fclass.d   r[11:7],f[19:15]'                                                , 32,  32,      '11100', '01',     '00000', 'XXXXX', '001',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.w.d   r[11:7],f[19:15]'                                                , 32,  32,      '11000', '01',     '00000', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.wu.d  r[11:7],f[19:15]'                                                , 32,  32,      '11000', '01',     '00001', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.d.w   f[11:7],r[19:15]'                                                , 32,  32,      '11010', '01',     '00000', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.d.wu  f[11:7],r[19:15]'                                                , 32,  32,      '11010', '01',     '00001', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['csrrw      r[11:7],h[31:20],r[19:15]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '001',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['csrrs      r[11:7],h[31:20],r[19:15]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '010',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['csrrc      r[11:7],h[31:20],r[19:15]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['csrrwi     r[11:7],h[31:20],h[19:15]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '101',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['csrrsi     r[11:7],h[31:20],h[19:15]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '110',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['csrrci     r[11:7],h[31:20],h[19:15]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '111',    'XXXXX', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['ecall'                                                                      , 32,  32,      '00000', '00',     '00000', '00000', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['ebreak'                                                                     , 32,  32,      '00000', '00',     '00001', '00000', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['uret'                                                                       , 32,  32,      '00000', '00',     '00010', '00000', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['sret'                                                                       , 32,  32,      '00010', '00',     '00010', '00000', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['hret'                                                                       , 32,  32,      '00100', '00',     '00010', '00000', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['mret'                                                                       , 32,  32,      '00110', '00',     '00010', '00000', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['mrts'                                                                       , 32,  32,      '00110', '00',     '00101', '00000', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['mrth'                                                                       , 32,  32,      '00100', '00',     '00110', '00000', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['wfi'                                                                        , 32,  32,      '00010', '00',     '00101', '00000', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['sfence.vma r[19:15],r[24:20]'                                               , 32,  32,      '00010', '01',     'XXXXX', 'XXXXX', '000',    '00000', '11100', '11', 'ALU',    "",           ""])
$arch_table.push(Array['lwu        r[11:7],h[31:20](r[19:15])'                                      , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '110',    'XXXXX', '00000', '11', 'ALU',    "",           ""])
$arch_table.push(Array['ld         r[11:7],h[31:20](r[19:15])'                                      , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '00000', '11', 'ALU',    "",           ""])
$arch_table.push(Array['sd         r[24:20],h[31:25]|h[11:7](r[19:15])'                             , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01000', '11', 'ALU',    "",           ""])
$arch_table.push(Array['addiw      r[11:7],r[19:15],h[31:20]'                                       , 32,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXXX', '000',    'XXXXX', '00110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['slliw      r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '001',    'XXXXX', '00110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['srliw      r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '101',    'XXXXX', '00110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['sraiw      r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '01000', '00',     'XXXXX', 'XXXXX', '101',    'XXXXX', '00110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['addw       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '000',    'XXXXX', '01110', '11', 'ALU',    "",           ["RS", "RS", "RS", "return m_pe_thread->SExtXlen(op1 +  op2)"]])
$arch_table.push(Array['subw       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '01000', '00',     'XXXXX', 'XXXXX', '000',    'XXXXX', '01110', '11', 'ALU',    "",           ["RS", "RS", "RS", "return m_pe_thread->SExtXlen(op1 -  op2)"]])
$arch_table.push(Array['sllw       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '001',    'XXXXX', '01110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['srlw       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '00',     'XXXXX', 'XXXXX', '101',    'XXXXX', '01110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['sraw       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '01000', '00',     'XXXXX', 'XXXXX', '101',    'XXXXX', '01110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['mulw       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '000',    'XXXXX', '01110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['divw       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '100',    'XXXXX', '01110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['divuw      r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '101',    'XXXXX', '01110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['remw       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '110',    'XXXXX', '01110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['remuw      r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00000', '01',     'XXXXX', 'XXXXX', '111',    'XXXXX', '01110', '11', 'ALU',    "",           ""])
$arch_table.push(Array['lr.d       r[11:7],r[19:15]'                                                , 32,  32,      '00010', 'XX',     '00000', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['sc.d       r[11:7],r[19:15],r[24:20]'                                       , 32,  32,      '00011', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoswap.d  r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '00001', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoadd.d   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '00000', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoxor.d   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '00100', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoand.d   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '01100', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amoor.d    r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '01000', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amomin.d   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '10000', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amomax.d   r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '10100', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amominu.d  r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '11000', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['amomaxu.d  r[11:7],r[24:20],(r[19:15])'                                     , 32,  32,      '11100', 'XX',     'XXXXX', 'XXXXX', '011',    'XXXXX', '01011', '11', 'LSU',    "",           ""])
$arch_table.push(Array['fcvt.l.s   r[11:7],f[19:15]'                                                , 32,  32,      '11000', '00',     '00010', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.lu.s  r[11:7],f[19:15]'                                                , 32,  32,      '11000', '00',     '00011', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.s.l   f[11:7],r[19:15]'                                                , 32,  32,      '11010', '00',     '00010', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.s.lu  f[11:7],r[19:15]'                                                , 32,  32,      '11010', '00',     '00011', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.l.d   r[11:7],f[19:15]'                                                , 32,  32,      '11000', '01',     '00010', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.lu.d  r[11:7],f[19:15]'                                                , 32,  32,      '11000', '01',     '00011', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmv.x.d    r[11:7],f[19:15]'                                                , 32,  32,      '11100', '01',     '00000', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.d.l   f[11:7],r[19:15]'                                                , 32,  32,      '11010', '01',     '00010', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fcvt.d.lu  f[11:7],r[19:15]'                                                , 32,  32,      '11010', '01',     '00011', 'XXXXX', 'XXX',    'XXXXX', '10100', '11', 'FPU',    "",           ""])
$arch_table.push(Array['fmv.d.x    f[11:7],r[19:15]'                                                , 32,  32,      '11110', '01',     '00000', 'XXXXX', '000',    'XXXXX', '10100', '11', 'FPU',    "",           ""])

$arch_table.push(Array['c.addi4spn cr[4:2],u[12:5]'                                                 , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '00X', 'XXXXX<>0', 'XXXXX', '00', 'COMPRESS', "", ""])
$arch_table.push(Array['c.fld      cf[4:2],cr[9:7],u[6:5]|u[12:10]<<3'                              , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '01X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])
# $arch_table.push(Array['c.lq       cr[4:2],cr[9:7],u[10]|u[6:5]|u[12:11]<<4'                      , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '01X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])   # RV128
$arch_table.push(Array['c.lw       cr[4:2],cr[9:7],u[5:5]|u[12:10]|u[6:6]<<2'                       , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '10X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])
$arch_table.push(Array['c.flw      cr[4:2],cr[9:7],u[5:5]|u[12:10]|u[6:6]<<2'                       , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '11X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])
$arch_table.push(Array['c.ld       cr[4:2],cr[9:7],u[6:5]|u[12:10]<<3'                              , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '11X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])   # RV64/RV128
$arch_table.push(Array['c.fsd      cr[4:2],cr[9:7],u[6:5]|u[12:10]<<3'                              , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '01X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])
# $arch_table.push(Array['c.sq     cr[4:2],cr[9:7],u[10]|u[6:5]|u[12:11]'                           , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '01X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])
$arch_table.push(Array['c.sw       cr[4:2],cr[9:7],u[5:5]|u[12:10]|u[6:6]<<2'                       , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '10X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])
$arch_table.push(Array['c.fsw      cr[4:2],cr[9:7],u[5:5]|u[12:10]|u[6:6]<<2'                       , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '11X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])
$arch_table.push(Array['c.sd       cr[4:2],cr[9:7],u[6:5]|u[12:10]<<3'                              , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '11X', 'XXXXX', 'XXXXX', '00', 'COMPRESS', "", ""])   # RV64/RV128

$arch_table.push(Array['c.nop     '                                                                 , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '000', '00000', '00000', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.addi     r[11:7],u[12:12]|u[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '00X', 'XXXXX<>0','XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.jal      u[12:12]|u[7:7]|u[10:9]|u[6:6]|u[7:7]|u[2:2]|u[11:11]|u[5:3]<<1' , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '01X', 'XXXXX', 'XXXXX', '01', 'COMPRESS', "", ""])  # RV32
$arch_table.push(Array['c.addiw    r[11:7],h[12:12]|h[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '01X', 'XXXXX', 'XXXXX', '01', 'COMPRESS', "", ""]) # RV64/RV128
$arch_table.push(Array['c.li       r[11:7],u[12:12]|h[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '10X', 'XXXXX', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.addi16sp cr[4:2],u[12:5]'                                                 , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '11X', '00010', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.lui      r[11:7],u[12:12]|h[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '11X', 'XXXXX<>2', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.srli     cr[9:7],u[12:12]|h[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '000', '00XXX', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.srli64   cr[9:7],u[12:12]|h[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '001', '00XXX', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.srai     cr[9:7],u[12:12]|h[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '000', '01XXX', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.srai64   cr[9:7],u[12:12]|h[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '001', '01XXX', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.andi     cr[9:7],u[12:12]|h[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '00X', '10XXX', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.sub      cr[9:7],cr[4:2]'                                                 , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '000', '11XXX', '00XXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.xor      cr[9:7],cr[4:2]'                                                 , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '000', '11XXX', '01XXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.or       cr[9:7],cr[4:2]'                                                 , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '000', '11XXX', '10XXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.and      cr[9:7],cr[4:2]'                                                 , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '000', '11XXX', '11XXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.subw     cr[9:7],r[6:2]'                                                  , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '001', '11XXX', '00XXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.addw     cr[9:7],r[6:2]'                                                  , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '001', '11XXX', '01XXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.j        u[12:12]|u[8:8]|u[10:9]|u[6:6]|u[7:7]|u[2:2]|u[11:11]|u[5:3]<<1' , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '01X', 'XXXXX', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.beqz     cr[9:7],u[12:12]|u[6:5]|u[2:2]|u[11:10]|u[4:3]<<1'               , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '10X', 'XXXXX', 'XXXXX', '01', 'COMPRESS', "", ""])
$arch_table.push(Array['c.bnez     cr[9:7],u[12:12]|u[6:5]|u[2:2]|u[11:10]|u[4:3]<<1'               , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '11X', 'XXXXX', 'XXXXX', '01', 'COMPRESS', "", ""])

$arch_table.push(Array['c.slli     r[11:7],u[12:12]|u[6:2]'                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '00X', 'XXXXX<>0', 'XXXXX',    '10', 'COMPRESS', "", ""])
# $arch_table.push(Array['c.slli64    '                                                             , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '000', 'XXXXX<>0', '00000',    '10', 'COMPRESS', "", ""])   # RV128
$arch_table.push(Array['c.fldsp    r[11:7],u[4:2]|u[12:12]|u[6:5]<<3 '                              , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '01X', 'XXXXX',    'XXXXX',    '10', 'COMPRESS', "", ""])
# $arch_table.push(Array['c.lqsp    '                                                               , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '01X', 'XXXXX<>0', 'XXXXX',    '10', 'COMPRESS', "", ""])   # RV128
$arch_table.push(Array['c.lwsp     r[11:7],u[3:2]|u[12:12]|u[6:4]<<2'                               , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '10X', 'XXXXX<>0', 'XXXXX',    '10', 'COMPRESS', "", ""])
$arch_table.push(Array['c.flwsp    f[11:7],u[3:2]|u[12:12]|u[6:4]<<2'                               , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '11X', 'XXXXX',    'XXXXX',    '10', 'COMPRESS', "", ""])   # RV32
$arch_table.push(Array['c.ldsp     r[11:7],u[4:2]|u[12:12]|u[6:5]<<3'                               , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX0', '11X', 'XXXXX<>0', 'XXXXX',    '10', 'COMPRESS', "", ""])   # RV64/RV128
$arch_table.push(Array['c.jr       r[11:7]'                                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '000', 'XXXXX<>0', '00000',    '10', 'COMPRESS', "", ""])
$arch_table.push(Array['c.mv       r[11:7],r[6:2]'                                                  , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '000', 'XXXXX<>0', 'XXXXX<>0', '10', 'COMPRESS', "", ""])
$arch_table.push(Array['c.ebreak  '                                                                 , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '001', '00000',    '00000',    '10', 'COMPRESS', "", ""])
$arch_table.push(Array['c.jalr     r[11:7]'                                                         , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '001', 'XXXXX<>0', '00000',    '10', 'COMPRESS', "", ""])
$arch_table.push(Array['c.add      r[11:7],r[6:2]'                                                  , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '001', 'XXXXX<>0', 'XXXXX<>0', '10', 'COMPRESS', "", ""])
$arch_table.push(Array['c.fsdsp    f[6:2],u[9:7]|u[12:10]<<3'                                       , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '01X', 'XXXXX',    'XXXXX',    '10', 'COMPRESS', "", ""])
# $arch_table.push(Array['c.sqsp    '                                                               , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '01X', 'XXXXX',    'XXXXX',    '10', 'COMPRESS', "", ""])   # RV128
$arch_table.push(Array['c.swsp     r[6:2],u[8:7]|u[12:9]<<2'                                        , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '10X', 'XXXXX',    'XXXXX',    '10', 'COMPRESS', "", ""])
$arch_table.push(Array['c.fswsp    f[6:2],u[9:7]|u[12:10]<<3'                                       , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '11X', 'XXXXX',    'XXXXX',    '10', 'COMPRESS', "", ""])   # RV32
$arch_table.push(Array['c.sdsp     r[6:2],u[9:7]|u[12:10]<<3'                                       , 16,  32,      'XXXXX', 'XX',     'XXXXX', 'XXXX1', '11X', 'XXXXX',    'XXXXX',    '10', 'COMPRESS', "", ""])   # RV64/RV128