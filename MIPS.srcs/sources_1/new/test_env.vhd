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
    Port ( clk : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

-- mono pulses
signal mpg_if_pc_wen, mpg_if_pc_reset, mpg_rf_wen : std_logic;

-- seven segments display value
signal ssd_out : std_logic_vector(15 downto 0);

-- instruction fetch output
signal current_instruction :std_logic_vector(15 downto 0);
signal next_inst_address : std_logic_vector(3 downto 0);


-- signals from control unit
signal reg_wr, reg_dst, ext_op, alu_src, pc_src, mem_read, mem_write, mem_to_reg : std_logic;
signal alu_op : std_logic_vector(1 downto 0);

--instruction decoding
signal rf_rs, rf_rt, ext_imm : std_logic_vector(15 downto 0);
signal func : std_logic_vector(2 downto 0);
signal shift_amount : std_logic;

begin

mono_pulse_if_wen: entity work.mpg port map(clk => clk, btn => btn(0), enable => mpg_if_pc_wen);
mono_pulse_if_reset: entity work.mpg port map(clk => clk, btn => btn(1), enable => mpg_if_pc_reset);
mono_pulse_rf_wen: entity work.mpg port map(clk => clk, btn => btn(2), enable => mpg_rf_wen);
seven_seg_display: entity work.ssd port map(clk => clk, digits => ssd_out , an => an, cat => cat);



instruction_fetching: entity work.instruction_fetch port map(clk=>clk, br_addr=>x"5", 
                      j_addr=>x"0", j_ctrl=>sw(0), pc_src=>sw(1), pc_en=>mpg_if_pc_wen,
                      pc_reset=>mpg_if_pc_reset,curr_instr=>current_instruction, next_instr=>next_inst_address);



instruction_decoding: entity work.instruction_decode port map(clk => clk, instruction => current_instruction,
                      wd => x"0007", rf_wen => mpg_rf_wen, reg_wr => reg_wr, reg_dst => reg_dst, ext_op => ext_op,
                      rd1 => rf_rs, rd2 => rf_rt, ext_imm => ext_imm, func => func, sa => shift_amount);

ControlUnit: entity work.control_unit port map(op_code => current_instruction(15 downto 13), reg_dst => reg_dst,
    reg_wr => reg_wr, alu_src => alu_src, pc_src => pc_src, mem_read => mem_read, mem_write => mem_write, 
    mem_to_reg => mem_to_reg, alu_op => alu_op);  



ssd_mux: process(sw)
    begin
        case sw(7 downto 5) is
            when "000" => ssd_out <= current_instruction;
            when "001" => ssd_out <= x"000" & next_inst_address;
            when "010" => ssd_out <= rf_rs;
            when "011" => ssd_out <= rf_rt;
            when "100" => ssd_out <= "00000000000000" & shift_amount;
            when "101" => ssd_out <= ext_imm;
            when "110" => ssd_out <= "0000000000000" & func;
            when others => ssd_out <= x"ffff";          
        end case;
    end process;
    
led(0) <= reg_dst;
led(1) <= reg_wr;
led(2) <= alu_src;
led(3) <= pc_src;
led(4) <= mem_read;
led(5) <= mem_write;
led(6) <= mem_to_reg;
led(8 downto 7) <= alu_op;

end Behavioral;
