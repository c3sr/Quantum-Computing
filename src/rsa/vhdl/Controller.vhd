----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2019 04:18:26 PM
-- Design Name: 
-- Module Name: Controller - Behavioral
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
use ieee.numeric_std.all;
use work.RSA_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    generic (CONTROLLER_VAR: integer := 2); -- for counter bits
    Port ( clk : in STD_LOGIC;
           Q0 : in STD_LOGIC;  --LSB of Mplier Q
--           start : in STD_LOGIC;
           reset : in std_logic; -- I added reset in order to solve the problem of asynchronous reset in all other modules
           load : out STD_LOGIC; -- when '1' load M (Mcand),Q (Mplier)and Accumulator(A)
           shift : out STD_LOGIC; -- shift A:Q
           addA : out STD_LOGIC; -- when addA signal occurs, transfer the adder output to the accumulatorA
           Done : out STD_LOGIC); -- indicates the end of the algorithm
end Controller;

architecture Behavioral of Controller is
type states is (HaltS,InitS,QtempS,AddS,ShiftS); --Qtemp is included for timing
signal state: states := HaltS; 
signal CNT: unsigned(CONTROLLER_VAR-1 downto 0);
begin

-- Moore model outputs to control the datapath
--Done <= '1' when (state = HaltS) else '0'; --End of algorithm
Load <= '1' when state = InitS else '0'; --Load M/Q, Clear A
AddA<= '1' when state = AddS else '0'; --Load adder to A
Shift <= '1' when state = ShiftS else '0'; --Shift A:Q


process(clk,reset) -- added reset
begin
    if (reset = '1') then
        done <= '0';
        state <= HaltS;
    elsif rising_edge(clk) then
        case state is
            when HaltS=> 
--                if Start = '1' then --Start pulse applied?
                    state <= InitS;--Start the algorithm
--                end if;
            when InitS=> 
                state <= QtempS; --Test Q0 at next clock**
            when QtempS=> 
                if (Q0 = '1') then
                    state <= AddS; --Add if multiplier bit = 1
                else
                    state <= ShiftS; --Skip add if multiplier bit = 0
                end if;
            when AddS=>
                state <= ShiftS; --Shift after add
            when ShiftS=> 
                if (CNT = 2**CONTROLLER_VAR -1) then
                    done <= '1';
--                    state <= HaltS; --Halt after 2^N iterations
                else
                    state <= QtempS;--Next iteration of algorithm: test Q0 **
                end if;
        end case;
    end if;
 end process;
 
 process(Clk)
 begin
     if rising_edge(Clk) then
         if state = InitS then
            CNT <= to_unsigned(0,CONTROLLER_VAR);--Reset CNT in InitSstate
         elsif state = ShiftS then
            CNT <= CNT + 1;--Count in ShiftSstate
         end if;
     end if;
 end process;
   
end Behavioral;
