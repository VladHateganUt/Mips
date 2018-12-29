----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/22/2018 06:06:02 PM
-- Design Name: 
-- Module Name: reg_file - Behavioral
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

entity reg_file is
    Port ( clk : in STD_LOGIC;                                  -- clk signal
           reg_wr : in STD_LOGIC;                               -- reg file write control
           ra1 : in STD_LOGIC_VECTOR (2 downto 0);              -- reg1 address
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);              -- reg2 address
           wa : in STD_LOGIC_VECTOR (2 downto 0);               -- write address
           wd : in STD_LOGIC_VECTOR (15 downto 0);              -- data to be written
           wen : in STD_LOGIC;                                  -- write enable(button)
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);            -- reg1 value
           rd2 : out STD_LOGIC_VECTOR (15 downto 0));           -- reg2 value
           
end reg_file;

architecture Behavioral of reg_file is

type regfile is array(0 to 15) of std_logic_vector(15 downto 0);
signal registers : regfile :=(
    others => x"0000"
);
begin

regf: process(clk, reg_wr, wen)
    begin
        if(rising_edge(clk)) then
            if(reg_wr = '1' and wen='1') then
                registers(conv_integer(wa)) <= wd;
            end if;
        end if;
    end process;

rd1 <= registers(conv_integer(ra1));
rd2 <= registers(conv_integer(ra2));
    
end Behavioral;
