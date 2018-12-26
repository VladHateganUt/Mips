----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/24/2018 03:41:47 PM
-- Design Name: 
-- Module Name: instruction_fetch - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_fetch is
    Port ( clk : in STD_LOGIC;                                          
           br_addr : in STD_LOGIC_VECTOR (3 downto 0);                  -- branch address
           j_addr : in STD_LOGIC_VECTOR (3 downto 0);                   -- jump address
           pc_src : in STD_LOGIC;                                       -- branch control - mux select
           j_ctrl : in STD_LOGIC;                                       -- jump control - mux select
           pc_en : in STD_LOGIC;                                        -- enable for pc write        
           pc_reset : in STD_LOGIC;                                     -- reset for pc value
           curr_instr : out STD_LOGIC_VECTOR (15 downto 0);             -- current instruction from prog mem
           next_instr : out STD_LOGIC_VECTOR (3 downto 0));             -- next instruction index (pc)
end instruction_fetch;

architecture Behavioral of instruction_fetch is

signal program_cnt, next_pc, br_mux_out, j_mux_out : std_logic_vector(3 downto 0);

-- ROM signals
signal rom_addr_reset : std_logic;
signal rom_data, rom_data_next : std_logic_vector(15 downto 0);
begin


rom_program_mem: entity work.rom_prog port map(addr => program_cnt, do => rom_data);



branch_mux: process(br_addr,pc_src,next_pc)
    begin
        case pc_src is
            when '0' => br_mux_out <= next_pc;
            when '1' => br_mux_out <= br_addr;
        end case;
    end process;
    
jump_mux: process(br_mux_out,j_addr,j_ctrl)
    begin
        case j_ctrl is
            when '0' => j_mux_out <= br_mux_out;
            when '1' => j_mux_out <= j_addr;
        end case;
    end process;

program_counter: process(clk, pc_reset, pc_en, pc_src)
    begin
        if(rising_edge(clk) and pc_en='1') then
            program_cnt <= j_mux_out; 
        end if;
        
        if(pc_reset = '1') then
            program_cnt <= x"0";
        end if;
    end process;
    
curr_instr <= rom_data;
next_pc <= program_cnt + '1';
next_instr <= next_pc;



end Behavioral;
