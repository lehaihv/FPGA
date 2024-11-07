library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity button_press is
 Port ( 
     reset, press_key : in std_logic;
     CNT : out unsigned(5 downto 0)
    );
end button_press;

architecture Behavioral of button_press is
-- constant value clock_freq = 27000000 (clock 27MHz)
constant count_value: integer := 300;  -- the number of count to get 0.5 s
-- signal
signal count_value_reg : integer := 0; -- Counter value;
signal count_value_flag : std_logic :='0';
signal CNT_temp : unsigned(5 downto 0);

begin
    process(press_key, reset) 
    begin
        if (reset = '1') then CNT_temp <= "111111";
        end if;
        if (press_key = '1') then
            count_value_reg <= count_value_reg + 1;
            if (count_value_reg > count_value) then
                CNT_temp <= CNT_temp -1;
                count_value_reg <= 0;
            end if;    
        end if;
    end process; 
    -- Assign output
    CNT <= CNT_temp;

end Behavioral;

