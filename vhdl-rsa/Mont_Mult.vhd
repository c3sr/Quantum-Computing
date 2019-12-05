----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2019 06:17:57 PM
-- Design Name: 
-- Module Name: montgomery-mul4 - Behavioral
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

entity Mont_Mult is
    generic (N: integer := WIDTH_IN);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           done : out STD_LOGIC;
           x : in STD_LOGIC_VECTOR (N-1 downto 0);
           y : in STD_LOGIC_VECTOR (N-1 downto 0);
           m : in STD_LOGIC_VECTOR (N-1 downto 0);
           A : out STD_LOGIC_VECTOR (N-1 downto 0));
end Mont_Mult;

architecture Behavioral of Mont_Mult is

signal A_temp               : unsigned (N+1 downto 0):=(others => '0'); 
signal x_temp               : unsigned (N+1 downto 0); 
signal y_temp               : unsigned (N+1 downto 0); 
signal m_temp               : unsigned (N+1 downto 0); 
signal u_temp               : unsigned(N+1 downto 0); 
signal count                : unsigned (N-1 downto 0);
signal u_temp0              : STD_LOGIC;
signal zeros                : unsigned(N downto 0):= (others => '0');
type states is (init_s,u_init_s, u_s, A_S, check_s);
signal state : states := init_s;
begin
    process(clk) 
    begin
        if(reset = '1') then
            A_temp <= (others => '0');
            u_temp <= (others => '0');
            zeros <= (others => '0');
            count <= (others => '0');
            done <= '0';
            state <= init_s;
        elsif(rising_edge(clk)) then
            case state is 
                when init_s =>
                    x_temp <= "00" & unsigned(x);
                    y_temp <= "00" & unsigned(y);
                    m_temp <= "00" & unsigned(m);                    
                    state <= u_init_s;
                when u_init_s =>   
                    u_temp0 <= u_temp(0);                    
                    state <= u_s;                    
                when u_s =>
                    if(count <= N-1) then                       
                        u_temp <= ((zeros & A_temp(0)) + ((zeros & x_temp(0)) and (zeros & y_temp(0)))) mod 2;
                        state <= A_s;
                    else 
                        state <= check_s;
                    end if;
                when A_s =>
                    if (x_temp(0) = '0') then
                        if(u_temp(0) = '0') then
                            A_temp <= (shift_right(A_temp,1));
                        else 
                            A_temp <= shift_right((A_temp + m_temp),1);
                        end if;
                    else
                        if(u_temp(0) = '0') then
                            A_temp <= shift_right((A_temp + y_temp),1);
                        else
                            A_temp <= shift_right((A_temp + y_temp + m_temp),1);
                        end if;                       
                    end if;
                    count <= count + 1;
                    x_temp <= shift_right(x_temp, 1);
                    u_temp <= shift_left(u_temp(N downto 0), 1) & u_temp0;                  
                    state <= u_s; 
                when check_s =>
--                    book algorithm suggests >=
                    if(A_temp >= m_temp ) then
                        A_temp <= (A_temp(N+1 downto 0) - m_temp(N+1 downto 0));
                        done <= '1';
                    else
                        A_temp <= (A_temp(N+1 downto 0));
                        done <= '1';
                    end if;
                    state <= init_s;
                when others =>
                    state <= init_s;
            end case;   
        end if;
    end process;
    A <= STD_LOGIC_VECTOR(A_temp(N-1 downto 0));
end Behavioral;
