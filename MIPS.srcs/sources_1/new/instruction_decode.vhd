----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/25/2018 07:48:14 PM
-- Design Name: 
-- Module Name: instruction_decode - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_decode is                                                
    Port ( clk : in STD_LOGIC;                                              -- clk signal
           instruction : in STD_LOGIC_VECTOR (15 downto 0);                 -- current instruction
           wd : in STD_LOGIC_VECTOR (15 downto 0);                          -- data to be written to reg file
           rf_wen : in STD_LOGIC;                                           -- reg file write enable(button)
           reg_wr : in STD_LOGIC;                                           -- reg file write control
           reg_dst : in STD_LOGIC;                                          -- which reg is the destination
           ext_op : in STD_LOGIC;                                           -- extension control
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);                        -- data out
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);                        -- data ou
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);                    -- extended immediate
           func : out STD_LOGIC_VECTOR (2 downto 0);                        -- func for R type instr
           sa : out STD_LOGIC);                                             -- shift amount for R type instr
end instruction_decode;

architecture Behavioral of instruction_decode is

signal regf_write_addr : std_logic_vector(2 downto 0);                      -- reg file write address
signal extended_immediate : std_logic_vector(15 downto 0);                  -- extended immedaite - to be computed
begin

write_address_mux: process(instruction, reg_dst)
    begin
        case reg_dst is
            when '0' => regf_write_addr <= instruction(9 downto 7);
            when '1' => regf_write_addr <= instruction(6 downto 4);
        end case;
    end process;

register_file: entity work.reg_file port map(clk => clk, reg_wr => reg_wr, ra1 => instruction(12 downto 10),
                                             ra2 => instruction(9 downto 7), wa => regf_write_addr, wd => wd,
                                             wen => rf_wen, rd1 => rd1, rd2 => rd2);


extension_unit: process(ext_op,instruction(6 downto 0))
    begin
        case ext_op is
            when '0' => extended_immediate <= "000000000" & instruction(6 downto 0);
            when '1' => extended_immediate <= "111111111" & instruction(6 downto 0);  
        end case;
    end process;
    
func <= instruction(2 downto 0);
sa <= instruction(3);
ext_imm <= extended_immediate;


end Behavioral;
