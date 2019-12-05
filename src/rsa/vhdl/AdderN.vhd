----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2019 04:08:30 PM
-- Design Name: 
-- Module Name: AdderN - Behavioral
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

entity AdderN is
    generic(width_in: integer := 4);
    Port ( A : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           B : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           S : out STD_LOGIC_VECTOR (width_in downto 0)); -- includes a carry bit
end AdderN;

architecture Behavioral of AdderN is

begin
 S <= std_logic_vector(('0' & unsigned(A)) + unsigned(B));

end Behavioral;
