----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2018 05:26:24 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;                                  -- clk signal
           sw : in STD_LOGIC_VECTOR (15 downto 0);              -- board switches
           btn : in STD_LOGIC_VECTOR (4 downto 0);              -- board buttons
           led : out STD_LOGIC_VECTOR (15 downto 0);            -- board leds
           an : out STD_LOGIC_VECTOR (3 downto 0);              -- ssd anodes
           cat : out STD_LOGIC_VECTOR (6 downto 0));            -- ssd catodes
end test_env;

architecture Behavioral of test_env is

-- mono pulses
signal mpg_if_pc_wen, mpg_if_pc_reset, mpg_rf_wen, mpg_mem_wen : std_logic;  -- enable write on different components

-- seven segments display value
signal ssd_out : std_logic_vector(15 downto 0);

-- instruction fetch 
signal pc_src : std_logic;                                      -- mux select, for pc value
signal current_instruction :std_logic_vector(15 downto 0);      -- current instruction from ROM
signal next_instr_address : std_logic_vector(15 downto 0);      -- next instr address (PC+1)


-- signals from control unit
signal reg_wr : std_logic;                          -- enables write on reg file
signal reg_dst : std_logic;                         -- which is the destination register(rt or rd)
signal ext_op : std_logic;                          -- sign extension or zero extension
signal alu_src : std_logic;                         -- what is the second operand(rt or ext_imm)
signal branch : std_logic;                          -- branch mux control
signal jump : std_logic;                            -- jump mux control
signal mem_read : std_logic;                        -- UNUSED 
signal mem_write : std_logic;                       -- enables writing in data memory
signal mem_to_reg : std_logic;                      -- mux select, what goes to reg file(mem_data or alu_res)
signal alu_op : std_logic_vector(2 downto 0);       -- which operation should be performed by alu.

--instruction decoding
signal rf_rs, rf_rt: std_logic_vector(15 downto 0); -- reg file registers 
signal ext_imm : std_logic_vector(15 downto 0);     -- extended immediate
signal func : std_logic_vector(2 downto 0);         -- func field for R type instructions
signal shift_amount : std_logic;                    -- shift amount for R type instructions

--execution unit
signal branch_address : std_logic_vector(15 downto 0);  -- computed branch address
signal jump_address : std_logic_vector(15 downto 0);    -- computed jump address
signal alu_res : std_logic_vector(15 downto 0);         -- alu result
signal zero : std_logic;                                -- zero signal : NEED COMPLETION

--data memory
signal mem_data : std_logic_vector(15 downto 0);        -- data from the ram memory
signal alu_res_mem : std_logic_vector(15 downto 0);     -- alu result (watch the schematic)
signal write_data_reg : std_logic_vector(15 downto 0);  -- data that will be written to reg file

begin

-- monopulses to control the pc, rf and data memory
mono_pulse_if_wen: entity work.mpg port map(clk => clk, btn => btn(0), enable => mpg_if_pc_wen);        
mono_pulse_if_reset: entity work.mpg port map(clk => clk, btn => btn(1), enable => mpg_if_pc_reset);
mono_pulse_rf_wen: entity work.mpg port map(clk => clk, btn => btn(2), enable => mpg_rf_wen);
mono_pulse_mem_wen: entity work.mpg port map(clk => clk, btn => btn(3), enable => mpg_mem_wen);


seven_seg_display: entity work.ssd port map(clk => clk, digits => ssd_out , an => an, cat => cat);



InstructionFetch: entity work.instruction_fetch port map(clk=>clk, br_addr=>branch_address, 
                      j_addr=>jump_address, j_ctrl=>jump, pc_src=>pc_src, pc_en=>mpg_if_pc_wen,
                      pc_reset=>mpg_if_pc_reset,curr_instr=>current_instruction, next_instr=>next_instr_address);



InstructionDecode: entity work.instruction_decode port map(clk => clk, instruction => current_instruction,
                      wd => write_data_reg, rf_wen => mpg_rf_wen, reg_wr => reg_wr, reg_dst => reg_dst, ext_op => ext_op,
                      rd1 => rf_rs, rd2 => rf_rt, ext_imm => ext_imm, func => func, sa => shift_amount);

ControlUnit: entity work.control_unit port map(op_code => current_instruction(15 downto 13), reg_dst => reg_dst, 
    ext_op => ext_op, reg_wr => reg_wr, alu_src => alu_src, branch => branch, mem_read => mem_read, mem_write => mem_write, 
    mem_to_reg => mem_to_reg, alu_op => alu_op);  


ExecutionUnit: entity work.execution_unit port map(next_instr_address => next_instr_address, rd1 => rf_rs,
               rd2 => rf_rt, ext_imm => ext_imm, func => func, sa => shift_amount, alu_src => alu_src, alu_op => alu_op,
               branch_address => branch_address, alu_res => alu_res, zero => zero, test => led(15 downto 0));
               
DataMemory: entity work.data_memory port map(clk => clk, alu_res => alu_res, rd2 => rf_rt, mem_write => mem_write,
            mem_wen => mpg_mem_wen, mem_data => mem_data, alu_res2 => alu_res_mem);


write_back_mux: process(mem_to_reg, mem_data, alu_res_mem)
    begin
        case mem_to_reg is
            when '0' => write_data_reg <= alu_res_mem;
            when '1' => write_data_reg <= mem_data;
        end case;
    end process;

ssd_mux: process(sw)
    begin
        case sw(7 downto 5) is
            when "000" => ssd_out <= current_instruction;
            when "001" => ssd_out <= next_instr_address;
            when "010" => ssd_out <= rf_rs;
            when "011" => ssd_out <= rf_rt;
            when "100" => ssd_out <= ext_imm;
            when "101" => ssd_out <= alu_res;
            when "110" => ssd_out <= mem_data;
            when "111" => ssd_out <= write_data_reg;          
        end case;
    end process;
    

led(0) <= reg_dst;
led(1) <= ext_op;
led(2) <= alu_src;
led(3) <= branch;
led(4) <= jump;
led(5) <= zero;
led(6) <= pc_src;
led(7) <= mem_write;
led(8) <= mem_to_reg;
led(11 downto 9) <= alu_op;


jump_address<=next_instr_address(15 downto 14) & current_instruction(13 downto 0);
pc_src <= zero and branch;

end Behavioral;
