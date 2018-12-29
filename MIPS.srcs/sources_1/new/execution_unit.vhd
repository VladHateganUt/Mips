----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/28/2018 12:02:58 PM
-- Design Name: 
-- Module Name: execution_unit - Behavioral
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

entity execution_unit is
    Port ( next_instr_address : in STD_LOGIC_VECTOR (15 downto 0);       --Pc+4+s_ext(imm)
           rd1 : in STD_LOGIC_VECTOR (15 downto 0);                     -- source register (rs)
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);                     -- sourse register (rt)
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);                  
           func : in STD_LOGIC_VECTOR (2 downto 0);                     -- function to be executed
           sa : in STD_LOGIC;                                           -- shift amount
           alu_src : in STD_LOGIC;                                      -- 0=>rd2, 1=>ext_imm
           alu_op : in STD_LOGIC_VECTOR(2 downto 0);                    -- alu code, from control unit
           branch_address : out STD_LOGIC_VECTOR (15 downto 0);         -- branch address
           alu_res : out STD_LOGIC_VECTOR (15 downto 0);                -- alu result
           zero : out STD_LOGIC;                                        -- zero signal
           test : out std_logic_vector(15 downto 0));                   -- for DEBUGGING
end execution_unit;

architecture Behavioral of execution_unit is
signal alu_in2 : std_logic_vector(15 downto 0);                         -- second alu source
signal alu_control : std_logic_vector(3 downto 0);                      -- intermediate control for operations
signal alu_res_aux : std_logic_vector(15 downto 0);                     -- intermediate result
signal zero_aux : std_logic;                                            -- intermediate zero result
signal test_in : std_logic_vector(15 downto 0);                         -- for debugging only
begin

branch_address <= next_instr_address + ext_imm;


-- Alu source select mux
with alu_src select
    alu_in2 <= rd2 when '0',
               ext_imm when '1';    

 
process(alu_op, func)
    begin
        case alu_op is
            when "000" => case func is
                            when "000" => alu_control <= "0000"; -- add
                            when "001" => alu_control <= "0001"; -- substract
                            when "010" => alu_control <= "0010"; -- sll
                            when "011" => alu_control <= "0011"; -- slr
                            when "100" => alu_control <= "0100"; -- and
                            when "101" => alu_control <= "0101"; -- or
                            when "110" => alu_control <= "0110"; -- setonlessthan
                            when "111" => alu_control <= "0111"; -- xor
                          end case;
            when "001" => alu_control <= "0000"; -- addi
            when "010" => alu_control <= "0000"; -- lw
            when "011" => alu_control <= "0000"; -- sw
            when "100" => alu_control <= "0001"; -- beq
            when "101" => alu_control <= "0100"; -- andi
            when "110" => alu_control <= "1000"; test_in <= x"0003"; -- ldi
            when "111" => alu_control <= "1001"; -- jump
        end case;
    end process; 

process(alu_control, rd1, alu_in2, sa)
    begin
        case alu_control is
            when "0000" => alu_res_aux <= rd1 + alu_in2;                                -- add
            when "0001" => alu_res_aux <= rd1 - alu_in2;                                -- substract
            when "0010" => case sa is                                                   -- sll
                               when '0' => alu_res_aux <= rd1;      
                               when '1' => alu_res_aux <= rd1(14 downto 0) & '0';
                           end case;
            when "0011" => case sa is                                                   -- slr
                               when '0' => alu_res_aux <= rd1;
                               when '1' => alu_res_aux <= '0' & rd1(15 downto 1);
                           end case;
            when "0100" => alu_res_aux <= rd1 and alu_in2;                              -- and
            when "0101" => alu_res_aux <= rd1 or alu_in2;                               -- or
            when "0110" => if(rd1 < alu_in2) then                                       -- sltu
                               alu_res_aux <= x"0001";
                           else 
                               alu_res_aux <= x"0000";
                           end if;
            when "0111" => alu_res_aux <= rd1 xor rd2;                                  -- xor
            when "1000" => alu_res_aux <= ext_imm;                                      -- ldi
            when "1001" => alu_res_aux <= x"0000";                                      -- jump
            when others => alu_res_aux <= x"0000";
        end case;
        
        case alu_res_aux is
            when x"0000" => zero_aux <= '1';
            when others => zero_aux <= '1';
        end case;
        
    end process;
    
alu_res <= alu_res_aux;
zero <= zero_aux;
end Behavioral;
