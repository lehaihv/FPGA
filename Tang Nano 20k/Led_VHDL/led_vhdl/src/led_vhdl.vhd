library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity led is
 Port ( 
     clock : in std_logic;
     IO_voltage : out std_logic
    );
end led;

architecture Behavioral of led is
-- constant value clock_freq = 27000000 (clock 27MHz)
constant count_value: integer := 200; --13499999;  -- the number of count to get 0.5 s
-- signal
signal count_value_reg : integer := 0; -- Counter value;
signal count_value_flag : std_logic :='0';
signal IO_voltage_reg : std_logic :='0';

begin
process(clock) 
begin
    if rising_edge(Clock) then
            -- Counter logic
            if count_value_reg < count_value then
                count_value_reg <= count_value_reg + 1;
                count_value_flag <= '0'; -- No flip flag
            else
                count_value_reg <= 0; -- Clear counter
                count_value_flag <= '1'; -- Flip flag
            end if;

            -- IO voltage flip logic
            if count_value_flag = '1' then
                IO_voltage_reg <= not IO_voltage_reg; -- Flip IO voltage
            end if;
    end if;
 
end process; 
-- Assign output
IO_voltage <= IO_voltage_reg;

end Behavioral;