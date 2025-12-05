library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detect is
    port (
        clk, reset : in STD_LOGIC;  -- Clock and Reset inputs
        level      : in STD_LOGIC;  -- Input signal to be monitored for edges
        tick       : out STD_LOGIC   -- Output pulse (goes high for one cycle on a rising edge of 'level')
    );
end edge_detect;

architecture gate_level_arch of edge_detect is
    signal delay_reg : std_logic;
begin
    -- Delay register process (Synchronous Logic)
    process (clk, reset)
    begin
        if (reset = '1') then         -- Active high asynchronous reset
            delay_reg <= '0';
        elsif (clk'event and clk = '1') then -- Equivalent to rising_edge(clk)
            delay_reg <= level;       -- Capture the current 'level' input on the clock edge
        end if;
    end process;

    -- Decoding logic (Concurrent Assignment)
    tick <= (not delay_reg) and level;

end gate_level_arch;