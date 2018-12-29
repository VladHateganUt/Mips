----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/24/2018 12:42:05 PM
-- Design Name: 
-- Module Name: rom_prog - Behavioral
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

entity rom_prog is
  Port (addr : in STD_LOGIC_VECTOR(15 downto 0);            --read address
        do : out STD_LOGIC_VECTOR(15 downto 0) );           -- data out
end rom_prog;

architecture Behavioral of rom_prog is
signal mem_res : std_logic_vector(15 downto 0);
type rom is array(0 to 255) of std_logic_vector(15 downto 0);
signal rom_mem : rom := (
    "1100000010000001", --ldi rs(0), rt(1), imm(1) HEX: C081
    "1100000100000001", --ldi rs(0), rt(2), imm(1) HEX: C101
    "0000010100110000", --add rs(1), rt(2), rd(2), sa(0), fct(0) HEX: 530
    "0110010110000000", --sw rs(1), rt(3), imm(0) HEX: 6580
    "0100011000000000", --lw rs(1), rt(4), imm(0) HEX: 4600
    "0010011000000100", --addi rs(1), rt(4), imm(4) HEX: 2604
    others => x"0000"); 

begin

do <= rom_mem(conv_integer(addr));

end Behavioral;
