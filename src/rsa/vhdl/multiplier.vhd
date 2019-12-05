----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2019 11:09:43 AM
-- Design Name: 
-- Module Name: multiplier - Behavioral
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

entity MultTop is

    Port ( Multiplier                           : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           Multiplicand                         : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           Product                              : out STD_LOGIC_VECTOR ((2*width_in)-1 downto 0);
           reset                                : in STD_LOGIC;
           clk                                  : in STD_LOGIC;
           Done                                 : out STD_LOGIC);
end MultTop;

architecture Behavioral of MultTop is
component RegN
    generic(width_in                                   : integer := 4);
    Port     ( Din                              : in STD_LOGIC_VECTOR (width_in-1 downto 0);
               Dout                             : out STD_LOGIC_VECTOR (width_in-1 downto 0);
               clk                              : in STD_LOGIC;          --for rising edge of the clock          
               load                             : in STD_LOGIC;         --load enable         
               shift                            : in STD_LOGIC;        --shift enable
               clear                            : in STD_LOGIC;        --clear enable
               serIn                            : in STD_LOGIC);       --Serial Input (Here for concatenating 0)
end component;

component AdderN
    generic(width_in                                   : integer := 4);
    Port ( A                                    : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           B                                    : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           S                                    : out STD_LOGIC_VECTOR (width_in downto 0)); -- includes a carry bit
end component;


component Controller is
    generic (CONTROLLER_VAR: integer := 2); -- for counter bits
    Port ( clk : in STD_LOGIC;
           Q0 : in STD_LOGIC;  --LSB of Mplier Q
--           start : in STD_LOGIC;
           reset : in std_logic; -- I added reset in order to solve the problem of asynchronous reset in all other modules
           load : out STD_LOGIC; -- when '1' load M (Mcand),Q (Mplier)and Accumulator(A)
           shift : out STD_LOGIC; -- shift A:Q
           addA : out STD_LOGIC; -- when addA signal occurs, transfer the adder output to the accumulatorA
           Done : out STD_LOGIC); -- indicates the end of the algorithm
end component;

signal Mout,Qout                                : std_logic_vector(Width_in-1 downto 0);
signal Dout,Aout                                : std_logic_vector(Width_in downto 0);
signal Load,Shift,AddA                          : std_logic;
begin

    C: Controller generic map (CONTROLLER_VAR)               --Controller with 2-bit counter
    port map (Clk,Qout(0),reset,Load,Shift,AddA,Done);
    A: AdderN generic map (Width_in)                   --4-bit adder; 5-bit output includes carry
    port map (Aout(Width_in-1 downto 0),Mout,Dout);
    M: RegN generic map (Width_in)                     --4-bit Multiplicand register
    port map (Multiplicand,Mout,Clk,Load,'0','0','0');
    Q: RegN generic map (Width_in)                     --4-bit Multiplier register
    port map (Multiplier,Qout,Clk,Load,Shift,'0',Aout(0));
    ACC: RegN generic map (Width_in+1)                    --5-bit Accumulator register
    port map (Dout,Aout,Clk,AddA,Shift,Load,'0');

Product <= Aout(Width_in-1 downto 0) & Qout; --8-bit product

end Behavioral;