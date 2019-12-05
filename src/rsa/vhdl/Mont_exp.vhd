----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2019 10:16:28 PM
-- Design Name: 
-- Module Name: montgomert_exp1 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mont_exp is
  generic (N: integer := WIDTH_IN);
  Port ( m                          : in STD_LOGIC_VECTOR(N-1 DOWNTO 0 );
         e                          : in STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         clk                        : in STD_LOGIC;
         reset                      : in STD_LOGIC;
         done                       : out STD_LOGIC;
         x                          : in STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         A                          : out STD_LOGIC_VECTOR(N-1 DOWNTO 0)); -- 7^3 mod 11
end Mont_exp;

architecture Behavioral of Mont_exp is
component Mont_Mult is
    generic (N: integer := WIDTH_IN);
    Port ( clk                      : in STD_LOGIC;
           reset                    : in STD_LOGIC;
           done                     : out STD_LOGIC;
           x                        : in STD_LOGIC_VECTOR (N-1 downto 0);
           y                        : in STD_LOGIC_VECTOR (N-1 downto 0);
           m                        : in STD_LOGIC_VECTOR (N-1 downto 0);
           A                        : out STD_LOGIC_VECTOR (N-1 downto 0));
end component;
signal R                            : unsigned(N downto 0);
signal Rsquare                      : unsigned(2*N downto 0);
signal init_A                       : STD_LOGIC_VECTOR (N-1 downto 0); 
signal Rsquare_mod_m                : STD_LOGIC_VECTOR (N-1 downto 0); 
--signal m_temp                       : unsigned (N-1 downto 0);
signal temp_x                       : STD_LOGIC_VECTOR (N-1 downto 0);
signal mont_x                       : STD_LOGIC_VECTOR (N-1 downto 0);
signal temp_A1, temp_A2, temp_A3    : STD_LOGIC_VECTOR (N-1 downto 0);
signal temp_A                       : STD_LOGIC_VECTOR (N-1 downto 0);
signal done0,done1,done2,done3      : STD_LOGIC;
--signal done                         : STD_LOGIC;
signal reset0,reset1,reset2,reset3  : STD_LOGIC;
signal e_temp                       : unsigned(N-1 DOWNTO 0);
signal count                        : integer := N;
signal zeros                        : unsigned(N-1 downto 0):= (others => '0');
signal zeros_for_Rsquare_mod_m      : unsigned((2*N)-1 downto 0):= (others => '0');
signal one                          : unsigned (N-1 downto 0) := (others => '0');
type states is (s0,
                s1,
                s2,
                s3,
                s4,
                s5,
                s6,
                s7,
                s8);
                
signal state                        : states:= s0;
begin
    R <= '1' & zeros;
    Rsquare <= '1' & zeros_for_Rsquare_mod_m;
    Rsquare_mod_m <= STD_LOGIC_VECTOR(Rsquare mod unsigned(m));
    one <= zeros(N-2 downto 0) & '1';
    init_A <= std_logic_vector(R mod unsigned(m));
    Mont_Mul_0 : Mont_Mult generic map(N) port map(clk, reset0, done0, temp_x, (Rsquare_mod_m), m, mont_x); -- Rsquare mod m value is precalculated
    Mont_Mul_1 : Mont_Mult generic map(N) port map(clk, reset1, done1, temp_A(N-1 downto 0), temp_A(N-1 downto 0), m, temp_A1); -- It will calculate for t downto 0 times
    Mont_Mul_2 : Mont_Mult generic map(N) port map(clk, reset2, done2, temp_A(N-1 downto 0), mont_x(N-1 downto 0), m, temp_A2); -- if e(i) = '1' then mont(A,mont_x)
    Mont_Mul_3 : Mont_Mult generic map(N) port map(clk, reset3, done3, temp_A(N-1 downto 0), STD_LOGIC_VECTOR(one), m, temp_A3 ); -- final A-- answer
    
    process(clk,reset)
    begin
        if(reset = '1') then
            done <= '0';
            count <= N;
            temp_A <= (others => '0');
            temp_x <= (others => '0');     
            e_temp <= (others => '0');
            reset0 <= '0';
            reset1 <= '0';
            reset2 <= '0';
            reset3 <= '0';
            state <= s0;
        elsif(rising_edge(clk)) then
            case state is
                when s0 =>
                    temp_A <= init_A;
                    temp_x <= x;
                    e_temp <= unsigned(e);
                    reset0 <= '1';
                    state <= s1;
                when s1 =>
                    reset0 <= '0';
                    if (done0 = '1') then
                        reset1 <= '1';
                        state <= s2; -- mont_x will be ready
                    end if;
                when s2 =>
                    reset1 <= '0';
                    if (done1 = '1') then
                        state <= s3; -- temp_A1 will be ready
                    end if;
                when s3 =>
                    temp_A <= temp_A1;
                    if(e_temp(N-1) = '1') then
                        reset2 <= '1';
                        state <= s4; -- to initiate temp_A2 calculation
                    else 
                        e_temp <= rotate_left(e_temp,1);
                        count <= count - 1;
                        state <= s5;
                    end if;
                when s4 =>
                    reset2 <= '0';
                    if (done2 = '1') then
                        state <= s6; -- temp_A2 will be ready
                    end if;
                when s5 =>
                    if (count = 0) then
                        reset3 <= '1';
                        state <= s7; -- to initiate temp_A3 calculation
                    else
                        reset1 <= '1';
                        state <= s2; -- to initiate temp_A1 calculation (to continue loop)
                    end if;
                when s6 =>
                    temp_A <= temp_A2;
                    e_temp <= rotate_left(e_temp,1);
                    count <= count - 1;
                    state <= s5;
                when s7 =>
                    reset3 <= '0';
                    if (done3 = '1') then
                        state <= s8; -- temp_A3 will be ready
                    end if;
                when s8 =>
                    temp_A <= temp_A3;
                    done <= '1';                   
            end case;
        end if;
    end process;
   A <= temp_A;
end Behavioral;
