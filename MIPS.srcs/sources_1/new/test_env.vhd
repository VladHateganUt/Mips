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

signal mpg_en: std_logic;
signal mpg_en_rf : std_logic;

signal ssd_out : std_logic_vector(15 downto 0);


signal cnt : std_logic_vector(3 downto 0);

-- ROM SIGNALS
--signal mpg_en_rom : std_logic;
--signal addr_rom_cnt : std_logic_vector(3 downto 0);
--signal rom_addr_reset : std_logic;
--signal rom_data : std_logic_vector(15 downto 0);


--signal sum, rf_data1, rf_data2 : std_logic_vector(15 downto 0);

signal mpg_en_if_wr, mpg_en_if_reset : std_logic;
signal branch_tmp : std_logic_vector(3 downto 0):= "0000";
signal jmp_tmp : std_logic_vector(3 downto 0):= "0000";
signal current_instruction :std_logic_vector(15 downto 0);
signal next_inst_address : std_logic_vector(3 downto 0);
begin

--mono_pulse_rom_en: entity work.mpg port map(clk => clk, btn => btn(0), enable => mpg_en_rom);
--seven_seg_display: entity work.ssd port map(clk => clk, digits => rom_data , an => an, cat => cat);
--rom_program_mem: entity work.rom_prog port map(addr => addr_rom_cnt, do => rom_data);

--rom_addr_reset <= btn(2);                    
--addr_gen: process(clk)
--    begin
 --       if(rising_edge(clk) and mpg_en_rom = '1') then
  --          addr_rom_cnt <= addr_rom_cnt + '1';
   --     end if;
    --    if(rom_addr_reset = '1') then
     --       addr_rom_cnt <= x"0";
      --  end if;
    --end process;

mono_pulse_if_wen: entity work.mpg port map(clk => clk, btn => btn(0), enable => mpg_en_if_wr);
mono_pulse_if_reset: entity work.mpg port map(clk => clk, btn => btn(1), enable => mpg_en_if_reset);
instruction_fetching: entity work.instruction_fetch port map(clk=>clk, br_addr=>x"5", 
                                                             j_addr=>x"0",
                                                             j_ctrl=>sw(0), pc_src=>sw(1), pc_en=>mpg_en_if_wr,
                                                             pc_reset=>mpg_en_if_reset,curr_instr=>current_instruction, 
                                                             next_instr=>next_inst_address);
seven_seg_display: entity work.ssd port map(clk => clk, digits => current_instruction , an => an, cat => cat);
end Behavioral;
