----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 06:14:50 PM
-- Design Name: 
-- Module Name: gcd - Behavioral
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

entity gcd is
    Port ( clk                          : in STD_LOGIC;
           reset                        : in STD_LOGIC;
           x                            : in STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
           y                            : in STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
           done                         : out STD_LOGIC;
           gcd                          : out STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0));
end gcd;

architecture Behavioral of gcd is
    type states is (s0,s1);
    signal state                            : states := s0;
    signal x_temp                           : unsigned ((2*WIDTH_IN)-1 downto 0);
    signal y_temp                           : unsigned ((2*WIDTH_IN)-1 downto 0);
    signal gcd_temp                         : unsigned ((2*WIDTH_IN)-1 downto 0);
    
    begin
        process(clk,reset)
        begin
            if(reset = '1') then
                x_temp <= (others => '0');
                y_temp <= (others => '0');
                done <= '0';
                state <= s0;
            elsif(rising_edge(clk)) then
                case state is
                    when s0 =>
                        x_temp <= unsigned(x);
                        y_temp <= unsigned(y);
                        state <= s1;
                    when s1 =>
                        if(x_temp /= y_temp) then
                            if(x_temp = 1 or y_temp = 1) then
                                gcd_temp <= to_unsigned(1,(2*width_in));
                                done <= '1';
                            elsif(x_temp  > y_temp) then
                                x_temp  <= x_temp - y_temp;
                            else 
                                y_temp  <= y_temp - x_temp;
                            end if;
                        else 
--                            if(x_temp = y_temp and x_temp /= 0 and y_temp /= 0) then
                                gcd_temp <= x_temp;
                                done <= '1';
--                            end if;
                        end if;
                end case;
            end if;
        end process;
        gcd <= STD_LOGIC_VECTOR(gcd_temp);

end Behavioral;
