----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2019 03:56:32 PM
-- Design Name: 
-- Module Name: RegN - Behavioral
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

entity RegN is
    generic(width_in: integer := 4);
    Port ( Din : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           Dout : out STD_LOGIC_VECTOR (width_in-1 downto 0);
           clk : in STD_LOGIC;          --for rising edge of the clock          
           load : in STD_LOGIC;         --load enable         
           shift : in STD_LOGIC;        --shift enable
           clear : in STD_LOGIC;        --clear enable
           serIn : in STD_LOGIC);       --Serial Input (Here for concatenating 0)
end RegN;

architecture Behavioral of RegN is
signal Dinternal: std_logic_vector(width_in-1 downto 0);
begin
process(clk)
begin
    if rising_edge(clk) then
        if clear ='1' then
            Dinternal <= (others => '0');
        elsif load = '1' then
            Dinternal <= Din;
        elsif shift = '1' then
            Dinternal <= serIn & Dinternal(width_in-1 downto 1);  
        end if;
    end if;
end process;
Dout <= Dinternal;
end Behavioral;
