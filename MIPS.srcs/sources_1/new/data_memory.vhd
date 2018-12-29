----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/28/2018 02:04:17 PM
-- Design Name: 
-- Module Name: data_memory - Behavioral
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

entity data_memory is
    Port ( clk : in STD_LOGIC;
           alu_res : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           mem_write : in STD_LOGIC;
           mem_wen : in STD_LOGIC;
           mem_data : out STD_LOGIC_VECTOR (15 downto 0);
           alu_res2 : out STD_LOGIC_VECTOR (15 downto 0));
end data_memory;

architecture Behavioral of data_memory is

type ram_type is array (0 to 15) of std_logic_vector (15 downto 0);
signal ram: ram_type;
signal address : std_logic_vector(3 downto 0);

begin

address <= alu_res(3 downto 0);

memory: process(clk)
    begin
        if(rising_edge(clk)) then
            if(mem_write = '1') then
                if(mem_wen = '1') then
                    ram(conv_integer(address)) <= rd2;
                end if;
            end if;
        end if;
        
        mem_data <= ram(conv_integer(address));       
    end process;

alu_res2 <= alu_res;

end Behavioral;
