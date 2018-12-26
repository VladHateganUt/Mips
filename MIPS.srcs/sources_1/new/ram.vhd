----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2018 01:22:45 PM
-- Design Name: 
-- Module Name: ram - Behavioral
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

entity ram is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           en : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR(3 downto 0);
           di : in STD_LOGIC_VECTOR(15 downto 0);
           do : out STD_LOGIC_VECTOR(15 downto 0));
end ram;

architecture Behavioral of ram is

type ram_type is array(0 to 15) of std_logic_vector(15 downto 0);
signal ram_mem: ram_type;

begin

mem: process(clk)
    begin
        if(rising_edge(clk)) then
            if(en = '1') then
                if(we = '1') then
                    ram_mem(conv_integer(addr)) <= di;
                else
                    do <= ram_mem(conv_integer(addr));
                end if;
            end if;
        end if;
    end process;


end Behavioral;
