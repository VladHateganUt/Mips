----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2018 05:59:06 PM
-- Design Name: 
-- Module Name: mpg - Behavioral
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

entity mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           enable : out STD_LOGIC);
end mpg;

architecture Behavioral of mpg is

signal q1,q2,q3: std_logic;
signal cnt: std_logic_vector(15 downto 0):=(others => '0');

begin

counter:process(clk, btn)
    begin
        if(rising_edge(clk)) then
            cnt <= cnt + '1';
        end if;
    end process;
    
reg1: process(clk)
    begin
        if(cnt = x"ffff") then
            q1 <= btn;
        end if;
    end process;

reg2: process(clk)
    begin
        if(rising_edge(clk)) then
            q2 <= q1;
        end if;
    end process;

reg3: process(clk)
    begin
        if(rising_edge(clk)) then
            q3 <= q2;
        end if;
    end process;

enable <= q2 and (not q3);

end Behavioral;
