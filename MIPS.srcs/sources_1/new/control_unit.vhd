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
    Port ( op_code : in STD_LOGIC_VECTOR (2 downto 0);          -- first 3 bits of the current instruction
           reg_dst : out STD_LOGIC;                             -- destination register (mux select)
           ext_op : out STD_LOGIC;                              -- extension control
           reg_wr : out STD_LOGIC;                              -- register write control
           alu_src : out STD_LOGIC;                             -- second alu source (mux select)
           branch : out STD_LOGIC;                              -- branch control
           mem_read : out STD_LOGIC;                            -- TO BE DELETED
           mem_write : out STD_LOGIC;                           -- data memory write control
           mem_to_reg : out STD_LOGIC;                          -- data memory output (mux select)
           alu_op : out STD_LOGIC_VECTOR (2 downto 0));         -- alu operation control
end control_unit;

architecture Behavioral of control_unit is

begin

control: process(op_code)
    begin
       reg_dst <= '0'; 
       reg_wr <= '0';
       alu_src <= '0';
       branch <= '0';
       mem_read <= '0';
       mem_write <= '0';
       mem_to_reg <= '0';
       alu_op <= "000";
       ext_op <= '0';
       
       case op_code is
        when "000" => reg_dst <= '1'; reg_wr <= '1'; alu_op <= "000"; --R
        when "001" => reg_wr <= '1'; alu_src <= '1'; alu_op <= "001"; ext_op <= '0'; --addi
        when "010" => reg_wr <= '1'; alu_src <= '1'; mem_read <= '1'; mem_to_reg <= '1'; alu_op <= "001"; ext_op <= '0'; --lw
        when "011" => alu_src <= '1'; mem_write <= '1'; alu_op <= "001"; ext_op <= '0'; --sw
        when "100" => alu_op <= "010"; --beq
        when "101" => alu_op <= "011"; --andi
        when "110" => reg_wr <= '1'; alu_src <= '1'; ext_op <= '0'; alu_op <= "110"; --ldi 
        when others => alu_op <= "000";  --jmp
       end case;
       
    end process;

end Behavioral;
