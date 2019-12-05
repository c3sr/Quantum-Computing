----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2019 07:47:22 PM
-- Design Name: 
-- Module Name: Random_generator - Behavioral
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
------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2019 09:57:24 AM
-- Design Name: 
-- Module Name: LFSR2 - Behavioral
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
use work.RSA_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LFSR is
    Port ( clk                      : in STD_LOGIC;
           reset                    : in STD_LOGIC;
           rand                     : out STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0));
end LFSR;

architecture Behavioral of LFSR is
    signal fb                           : STD_LOGIC;
    signal r_reg, r_next                : STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0);
begin
    -- x^3 + x + 1
    fb <= r_reg(WIDTH_IN-1) xor r_reg(WIDTH_IN-3) xor r_reg(0);
    r_next <= fb & r_reg(WIDTH_IN-1 downto 1);
    
    process(clk)
    begin
        if(reset = '1') then
            r_reg(0) <= '1';
            r_reg(WIDTH_IN-1 downto 1) <= (others => '0');
        elsif (rising_edge(clk)) then
            r_reg <= r_next;
        end if; 
    end process;
    
    rand <= r_reg;
end Behavioral;
