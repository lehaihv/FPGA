library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_6bits_led is
 Port ( 
     clock, reset, EN : in std_logic;
     CNT : out unsigned(5 downto 0)
    );
end counter_6bits_led;

architecture Behavioral of counter_6bits_led is
-- constant value clock_freq = 27000000 (clock 27MHz)
constant count_value: integer := 100;  -- the number of count to get 0.5 s 13499999
-- signal
signal count_value_reg : integer := 0; -- Counter value;
signal count_value_flag : std_logic := '0';
signal debouncing_key : std_logic := '0';
signal CNT_temp : unsigned(5 downto 0);

begin
    process(clock, reset) 
    begin
        if (reset = '1') then
            CNT_temp <= "111111";   -- turn off all led when reset
        elsif (clock'event and clock='1') then
            if (EN = '1') then
                -- Counter logic
                if count_value_reg < count_value then
                    count_value_reg <= count_value_reg + 1;
                    count_value_flag <= '0'; -- No flip flag
                else
                    count_value_reg <= 0; -- Clear counter
                    count_value_flag <= '1'; -- Flip flag
                end if;

                -- IO voltage flip logic
                if (count_value_flag = '1' and debouncing_key = '0') then
                    CNT_temp <= CNT_temp - 1;
                    debouncing_key <= '1';
                end if;  
            else 
                count_value_reg <= 0; -- Clear counter
                count_value_flag <= '0'; -- No flip flag
                debouncing_key <= '0';
            end if;
        end if;
    end process; 
    -- Assign output
    CNT <= CNT_temp;

end Behavioral;
