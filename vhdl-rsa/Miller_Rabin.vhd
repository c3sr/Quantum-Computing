----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2019 01:41:05 PM
-- Design Name: 
-- Module Name: Miller_rabin1 - Behavioral
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

entity Miller_rabin is
    Port ( clk                                  : in STD_LOGIC;
           reset                                : in STD_LOGIC;
           number                               : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           prime_or_not                         : out STD_LOGIC;
           done                                 : out STD_LOGIC);
end Miller_rabin;

architecture Behavioral of Miller_rabin is
component LFSR is
    Port ( clk                                  : in STD_LOGIC;
           reset                                : in STD_LOGIC;
           rand                                 : out STD_LOGIC_VECTOR (width_in-1 downto 0));
end component;

component find_r_and_d is
    Port ( clk                          : in STD_LOGIC;
           reset                        : in STD_LOGIC;
           number                       : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           r_out                        : out STD_LOGIC_VECTOR (width_in-1 downto 0);
           d_out                        : out STD_LOGIC_VECTOR (width_in-1 downto 0);
           done                         : out STD_LOGIC);
end component;

component Mont_exp is
  generic (N: integer := WIDTH_IN);
  Port ( m                          : in STD_LOGIC_VECTOR(N-1 DOWNTO 0 );
         e                          : in STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         clk                        : in STD_LOGIC;
         reset                      : in STD_LOGIC;
         done                       : out STD_LOGIC;
         x                          : in STD_LOGIC_VECTOR(N-1 DOWNTO 0);
         A                          : out STD_LOGIC_VECTOR(N-1 DOWNTO 0)); 
end component;
    type states is (s0,s1,s2,s3,s4,s5,s6,s7,s8);    
    signal state                                : states := s0;
    signal number_to_check,n_reg,temp_number    : STD_LOGIC_VECTOR (width_in-1 downto 0);
    signal Random_a,a                           : STD_LOGIC_VECTOR (width_in-1 downto 0);    
    signal reset_rand_n,reset_rand_a            : STD_LOGIC;
    signal reset_r_and_d                        : STD_LOGIC;
    signal reset_exp                            : STD_LOGIC;
    signal reset_exp_y                          : STD_LOGIC;
    signal temp_prime_or_not                    : STD_LOGIC;
    signal r_out, d_out,r,d                     : STD_LOGIC_VECTOR (width_in-1 downto 0);
    signal j                                    : unsigned (width_in-1 downto 0);
    signal done_r_and_d                         : STD_LOGIC;
    signal done_exp                             : STD_LOGIC;
    signal done_exp_y                           : STD_LOGIC;
    signal x_exp_ans                            : STD_LOGIC_VECTOR (width_in-1 downto 0);
    signal y_exp_ans                            : STD_LOGIC_VECTOR (width_in-1 downto 0);
    signal x,y                                  : unsigned (width_in-1 downto 0);
    signal count                                : integer := 0;
    constant witness_count                      : integer := 5;
    signal two                                  : STD_LOGIC_VECTOR (width_in-1 downto 0);
begin
two <= STD_LOGIC_VECTOR(to_unsigned(2,width_in));
--Random_generator_n    : LFSR port map(clk, reset_rand_n, number_to_check);
Random_generator_a    : LFSR port map(clk, reset_rand_a, Random_a);

r_and_d             : find_r_and_d port map(clk, reset_r_and_d, n_reg, r_out, d_out, done_r_and_d );
Modular_Exponentiation1: Mont_exp port map(n_reg, d, clk, reset_exp, done_exp, a, x_exp_ans);
Modular_Exponentiation2: Mont_exp port map(n_reg, two, clk, reset_exp_y, done_exp_y, STD_LOGIC_VECTOR(x), y_exp_ans);
    
    process(clk,reset)
    begin
        if (reset = '1') then
            reset_r_and_d <= '0';
            reset_exp <= '0';
            reset_exp_y <= '0';
            done <= '0';
            temp_prime_or_not <= '0';
            count <= 0;
            state <= s0;            
        elsif (rising_edge(clk)) then        
            case state is
                when s0 =>
                    if(unsigned(number) >= 3 and number(0) = '1') then
                        n_reg <= number;
                        reset_r_and_d <= '1';
                        state <= s1;
                    else
                        done <= '1';
                        temp_prime_or_not <= '0';
                    end if;
                when s1 =>
                    reset_r_and_d <= '0';
                    if(done_r_and_d = '1') then
                        r <= r_out;
                        d <= d_out;                    
                        state <= s2;
                    end if;
                when s2 =>
                    if(count = witness_count) then
                        done <= '1';
                        temp_prime_or_not <= '1';
                    else
                        if (count = 0) then
                            reset_rand_a <= '1';
                        end if;                  
                        state <= s3;
                    end if;
                when s3 =>
                    reset_rand_a <= '0';
                    if(unsigned(Random_a) > 2 and unsigned(Random_a) < unsigned(n_reg) - 2 and a /= Random_a) then
                        count <= count + 1;
                        a <= Random_a;
                        reset_exp <= '1';
                        state <= s4;
                    end if;
                when s4 =>
                    reset_exp <= '0';
                    if(done_exp = '1') then
                        x <= unsigned(x_exp_ans);
                        state <= s5;
                    end if;
                when s5 =>
                    if(x = 1 or x = unsigned(n_reg) - 1) then
                        state <= s2;
                    else
                        j <= (others => '0');
                        j(0) <= '1';                        
                        state <= s6;
                    end if;
                when s6 =>
                    if(j <= unsigned(r) - 1 and x /= unsigned(n_reg) - 1) then
                        reset_exp_y <= '1';
                        state <= s7;
                    else 
                        if(x /= unsigned(n_reg) - 1) then
                            done <= '1';
                            temp_prime_or_not <= '0';
                        else 
                            state <= s2;
                        end if;
                    end if;
                when s7 =>
                    reset_exp_y <= '0';
                    if(done_exp_y = '1') then
                        x <= unsigned(y_exp_ans);
                        state <= s8;
                    end if;
                when s8 =>
                    if(x = 1) then
                        done <= '1';
                        temp_prime_or_not <= '0';
                    else 
                        j <= j + 1;
                        state <= s6;
                    end if;            
            end case;        
        end if;
    end process;    
    prime_or_not <= temp_prime_or_not;  
end Behavioral;
