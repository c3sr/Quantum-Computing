----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2019 07:46:19 PM
-- Design Name: 
-- Module Name: RSA - Behavioral
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

entity RSA is
    Port ( clk                                  : in STD_LOGIC;
           reset                                : in STD_LOGIC;
           message                              : in STD_LOGIC_VECTOR ((2*WIDTH_IN) -1 downto 0);
           cipher_text                          : out STD_LOGIC_VECTOR ((2*WIDTH_IN) -1 downto 0);
           original_text                        : out STD_LOGIC_VECTOR ((2*WIDTH_IN) -1 downto 0);
           done                                 : out STD_LOGIC);
end RSA;

architecture Behavioral of RSA is
component LFSR is
    Port ( clk                                  : in STD_LOGIC;
           reset                                : in STD_LOGIC;
           rand                                 : out STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0));
end component;
component Miller_rabin is
    Port ( clk                                  : in STD_LOGIC;
           reset                                : in STD_LOGIC;
           number                               : in STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0);
           prime_or_not                         : out STD_LOGIC;
           done                                 : out STD_LOGIC);
end component;

component  MultTop is

    Port ( Multiplier                           : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           Multiplicand                         : in STD_LOGIC_VECTOR (width_in-1 downto 0);
           Product                              : out STD_LOGIC_VECTOR ((2*width_in)-1 downto 0);
           reset                                : in STD_LOGIC;
           clk                                  : in STD_LOGIC;
           Done                                 : out STD_LOGIC);
end component;

component gcd is
    Port ( clk                          : in STD_LOGIC;
           reset                        : in STD_LOGIC;
           x                            : in STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
           y                            : in STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
           done                         : out STD_LOGIC;
           gcd                          : out STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0));
end component;

component LFSR_e is
    Port ( clk                      : in STD_LOGIC;
           reset                    : in STD_LOGIC;
           rand                     : out STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0));
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
component mod_inv is
    generic( N : integer := WIDTH_IN);
    Port ( clk                                          : in STD_LOGIC;
           reset                                        : in STD_LOGIC;
           y                                            : in STD_LOGIC_VECTOR (N-1 downto 0);
           x                                            : in STD_LOGIC_VECTOR (N-1 downto 0);
           done                                         : out STD_LOGIC;
           a                                            : out STD_LOGIC_VECTOR (N-1 downto 0);
           b                                            : out STD_LOGIC_VECTOR (N-1 downto 0);
           v                                            : out STD_LOGIC_VECTOR (N-1 downto 0));
end component;



--component clk_wiz_0 is 
-- port (
--     clk_in2: in std_logic;
--     clk_in_sel: in std_logic;
--  --Clock out ports
--     clk_out1: out std_logic;
--  -- Status and control signals
--     reset: in std_logic;
--     locked : out std_logic;
-- -- Clock in ports
--     clk_in1: in std_logic
-- );
--end component; 

type states is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11);
signal state                                    : states := s0; 
signal reset_rand                               : STD_LOGIC := '1';
signal reset_check_p                            : STD_LOGIC;
signal reset_check_q                            : STD_LOGIC;
signal reset_rand_e                             : STD_LOGIC := '1';
signal reset_enc                                : STD_LOGIC;
signal reset_dec                                : STD_LOGIC;
signal reset_d                                  : STD_LOGIC;
signal reset_gcd                                : STD_LOGIC;
signal reset_mod_inv                            : STD_LOGIC;
signal done_gcd                                 : STD_LOGIC;
signal prime_or_not_p                           : STD_LOGIC;
signal prime_or_not_q                           : STD_LOGIC;
signal generate_q                               : STD_LOGIC := '1';
signal done_p                                   : STD_LOGIC;
signal done_q                                   : STD_LOGIC;
signal done_d                                 : STD_LOGIC;
signal done_enc                                 : STD_LOGIC;
signal done_dec                                 : STD_LOGIC;
signal reset_mul                                : STD_LOGIC;
signal reset_mul_phi                            : STD_LOGIC;
signal done_mul_n                               : STD_LOGIC;
signal done_mul_phiOfN                          : STD_LOGIC;
signal done_mod_inv                             : STD_LOGIC;
signal rand_number                              : STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0);
signal rand_number_e                              : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal number_p                                 : STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0) := (others => '0');
signal number_q                                 : STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0) := (others => '0');
signal number_e                                 : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0) := (others => '0');
signal reg_p                                    : STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0) := (others => '0');
signal reg_q                                    : STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0) := (others => '0');
signal reg_e                                    : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0) := (others => '0');
signal reg_n                                    : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal reg_d                                    : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal reg_phiOfN                               : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal reg_phiOfN_minus_1                       : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal product_n                                : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0) := (others => '0');
signal phiOfN                                   : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0) := (others => '0');
signal pMinus1                                  : STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0) := (others => '0');
signal qMinus1                                  : STD_LOGIC_VECTOR (WIDTH_IN-1 downto 0) := (others => '0');
signal gcd_of_e_and_phiOfN                      : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0) := (others => '0');
signal cipher_text_temp                         : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal encrypted_text                           : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal d_temp                                   : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal decrypted_text                           : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal decrypted_text_temp                           : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal mod_inv_a                                : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal mod_inv_b                                : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
signal mod_inv_v                                : STD_LOGIC_VECTOR ((2*WIDTH_IN)-1 downto 0);
begin

    
    Random_generator : LFSR port map(clk, reset_rand, rand_number);
    Random_generator_e : LFSR_e port map(clk, reset_rand_e, rand_number_e);
    
    Prime_checker_p: Miller_rabin port map(clk, reset_check_p, number_p, prime_or_not_p, done_p );
    Prime_checker_q: Miller_rabin port map(clk, reset_check_q, number_q, prime_or_not_q, done_q );
    Multiplier_n : MultTop port map(reg_p,reg_q, product_n,reset_mul, clk, done_mul_n);
    Multiplier_phiOfN : MultTop port map(pMinus1,qMinus1, phiOfN,reset_mul_phi, clk, done_mul_phiOfN);
    GCD_e_and_phiOfN : gcd port map(clk, reset_gcd, number_e, reg_phiOfN , done_gcd, gcd_of_e_and_phiOfN);
    Modular_exp_for_encryption: Mont_exp generic map(2 * width_in)
                                         port map(reg_n, reg_e, clk, reset_enc, done_enc, message,cipher_text_temp);
    Modular_inverse_for_finding_d: mod_inv generic map(2 * width_in) port map(clk, reset_mod_inv, reg_e ,reg_phiOfN, done_mod_inv, mod_inv_a, mod_inv_b, mod_inv_v);
    Modular_exp_for_decryption: Mont_exp generic map(2 * width_in)
                                         port map(reg_n, reg_d, clk, reset_dec, done_dec, encrypted_text,decrypted_text_temp);
    process(clk,reset)
    begin
        if(reset = '1'  ) then
            number_p <= (others => '0');
            number_q <= (others => '0');
            number_e <= (others => '0');
            reg_p <= (others => '0');
            reg_q <= (others => '0');
            generate_q <= '1';
            reset_mul_phi <= '0';
            reset_mul <= '0';
            reset_enc <= '0';
            done <= '0';
            state <= s0;
        elsif(rising_edge(clk)) then
            case state is
                when s0 => -- random generator p
                    reset_rand <= '0';
                    if (unsigned(rand_number) > 3 and rand_number(0) = '1' and rand_number /= number_q and rand_number /= number_p) then
                        number_p <= rand_number;
                        reset_check_p <= '1'; 
                        if(generate_q = '1') then
                            state <= s1; 
                        else 
                            state <= s2;
                        end if;
                    end if;                 
                when s1 => -- random generator q
                    if (unsigned(rand_number) > 3 and rand_number(0) = '1' and rand_number /= number_p and rand_number /= number_q) then
                        number_q <= rand_number;
                        generate_q <= '0';
                        reset_check_q <= '1';
                        state <= s2;
                    end if;                    
                when s2 => -- check for prime_p
                    if(unsigned(reg_p) /= 0) then
                        state <= s3;
                    else
                        reset_check_p <= '0';                    
                        if (done_p = '1') then
                            if(prime_or_not_p = '1') then
                                reg_p <= number_p;
                            else 
                                state <= s0;
                            end if;
                        end if;
                    end if;
                when s3 => -- check for prime_q
                    reset_check_q <= '0';
                    if (done_q = '1') then
                        if(prime_or_not_q = '1') then
                            reg_q <= number_q;
                        else 
                            state <= s1;
                        end if;
                    end if;
                    if(unsigned(reg_q) /= 0) then
                        state <= s4;
                    end if;
                when s4 =>
                    if (prime_or_not_p = '1' and prime_or_not_q = '1') then
                        reset_mul <= '1';
                        state <= s5;
                    end if; 
                when s5 =>
                    reset_mul <= '0';
                    if (done_mul_n = '1') then
                        reg_n <= product_n;
                        pMinus1 <= STD_LOGIC_VECTOR( unsigned(reg_p) - 1);
                        qMinus1 <= STD_LOGIC_VECTOR( unsigned(reg_q) - 1);
                        reset_mul_phi <= '1';
                        state <= s6;
                    end if;  
                when s6 =>
                    reset_mul_phi <= '0';
                    if(done_mul_phiOfN = '1') then
                        reg_phiOfN <= phiOfN ;
                        state <= s7; 
                    end if;
               when s7 =>
                    reset_rand_e <= '0';
                    if(rand_number_e < reg_phiOfN and unsigned(rand_number_e) /= 1) then
                       number_e <= rand_number_e;
                       reset_gcd <= '1';
                       state <= s8;
                    end if;
                when s8 =>
                    reset_gcd <= '0';
                    if (done_gcd = '1') then
                        if (unsigned(gcd_of_e_and_phiOfN) = 1) then
                            reg_e  <= number_e;
                            reset_enc <= '1';
                            state <= s9;
                        else
                            state <= s7;
                        end if;
                    end if;  
                 when s9 =>
                    reset_enc <= '0';
                    if(done_enc = '1') then
                        encrypted_text  <= cipher_text_temp;
                        reset_mod_inv <= '1';
                        state <= s10;                        
                    end if;
                 when s10 =>
                       reset_mod_inv <= '0';
                       if(done_mod_inv = '1') then
                           if(unsigned(mod_inv_v) = 1) then
                               reg_d <= mod_inv_b;
                               reset_dec <= '1';
                               state <= s11; 
                           else 
                               reg_d <= (others => '0');
                           end if;  
                       end if;
                 when s11 =>
                     reset_dec <= '0';
                     if(done_dec = '1') then
                        decrypted_text <= decrypted_text_temp;
                        done <= '1';
                     end if;
                    
            end case;
        end if;
    end process;
    cipher_text <= encrypted_text;
    Original_text <= decrypted_text;
end Behavioral;
