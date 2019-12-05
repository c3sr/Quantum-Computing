----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 07:57:11 AM
-- Design Name: 
-- Module Name: sim_RSA1 - Behavioral
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

entity sim_RSA1 is
--  Port ( );
end sim_RSA1;

architecture Behavioral of sim_RSA1 is
component RSA is
    Port ( clk                                  : in STD_LOGIC;
           reset                                : in STD_LOGIC;
           message                              : in STD_LOGIC_VECTOR ((2*WIDTH_IN) -1 downto 0);
           cipher_text                          : out STD_LOGIC_VECTOR ((2*WIDTH_IN) -1 downto 0);
           original_text                        : out STD_LOGIC_VECTOR ((2*WIDTH_IN) -1 downto 0);
           done                                 : out STD_LOGIC);
end component;

signal clk                                      : STD_LOGIC := '0';
signal reset                                    : STD_LOGIC;
signal m                                        : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0):= (others => '0');
signal c                                        : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0):= (others => '0');
signal retrived_msg                             : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0):= (others => '0');
signal done                                     : STD_LOGIC;
begin
    UUT: RSA port map (clk, reset, m, c, retrived_msg,done);
    clk <= not clk after 20 ns;
    process
    begin
        reset <= '1'; wait for 2 ns;
        reset <= '0';
--        m <= "0001111011011000"; --7896
--        m <= "1111111011010000"; --65232
--        m <= "010010";
   
        m <= "0001111000010101"; --7701
        wait for 0.3 ms;
        reset <= '1'; wait for 2 ns;
        reset <= '0';
        m <= "0000010001000000";  
        wait;  
    end process;

end Behavioral;
