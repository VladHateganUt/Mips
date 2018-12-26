----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2018 04:02:20 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
    Port ( op_code : in STD_LOGIC_VECTOR (2 downto 0);
           reg_dst : out STD_LOGIC;
           reg_wr : out STD_LOGIC;
           alu_src : out STD_LOGIC;
           pc_src : out STD_LOGIC;
           mem_read : out STD_LOGIC;
           mem_write : out STD_LOGIC;
           mem_to_reg : out STD_LOGIC;
           alu_op : out STD_LOGIC_VECTOR (1 downto 0));
end control_unit;

architecture Behavioral of control_unit is

begin

control: process(op_code)
    begin
       reg_dst <= '0'; 
       reg_wr <= '0';
       alu_src <= '0';
       pc_src <= '0';
       mem_read <= '0';
       mem_write <= '0';
       mem_to_reg <= '0';
       alu_op <= "00";
       
       case op_code is
        when "000" => reg_dst <= '1'; reg_wr <= '1';
        when "001" => reg_wr <= '1'; alu_src <= '1';
        when "010" => reg_wr <= '1'; alu_src <= '1'; mem_read <= '1'; mem_to_reg <= '1';
        when "011" => alu_src <= '1'; mem_write <= '1';
        when "110" => reg_wr <= '1'; alu_src <= '1'; 
        when others => alu_op <= "00"; 
       end case;
       
    end process;

end Behavioral;
