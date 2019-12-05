----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2019 03:32:38 PM
-- Design Name: 
-- Module Name: find_r_and_d - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.RSA_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity find_r_and_d is
    Port ( clk                          : in STD_LOGIC;
           reset                        : in STD_LOGIC;
           number                       : in STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0);
           r_out                        : out STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0);
           d_out                        : out STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0);
           done                         : out STD_LOGIC);
end find_r_and_d;

architecture Behavioral of find_r_and_d is
type states is (s0,s1,s2);
signal state : states := s0;
signal final_d,final_r      : unsigned (WIDTH_IN-1 downto 0);
signal d, r                 : unsigned (WIDTH_IN-1 downto 0);
signal number_minus_1       : unsigned (WIDTH_IN-1 downto 0);

begin
    number_minus_1 <= unsigned(number) - 1;
    process(clk)
    begin
        if(reset = '1') then
            final_d <= (others => '0');
            final_r <= (others => '0');
            done <= '0';
            state <= s0;
        elsif(rising_edge(clk)) then 
            case state is 
                when s0 => 
                    d <= number_minus_1;
                    r <= (others => '0');
                    state <= s1;
                when s1 =>
                    if(d mod 2 = 0) then
                        d <= shift_right(d,1);
                        r <= r + 1;
                    end if;
                    
                    if (d mod 2  = 0) then
                        state <= s1;
                    else 
                        state <= s2;
                    end if;
                when s2 =>
                    final_r <= r;
                    final_d <= d;
                    done <= '1';
           end case;
        end if;
    end process;
    
    
    r_out <= STD_LOGIC_VECTOR(final_r);
    d_out <= STD_LOGIC_VECTOR(final_d);
end Behavioral;
