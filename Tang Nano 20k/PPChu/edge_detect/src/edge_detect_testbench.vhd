library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Assuming the entity to be tested is named 'edge_detect'
-- and has the ports: clk, reset, level (input), and tick (output)

entity edge_detect_testbench is
end edge_detect_testbench;

architecture tb_arch of edge_detect_testbench is

    -- Component Declaration for the Unit Under Test (UUT)
    component edge_detect
        Port (
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            level : in  STD_LOGIC;
            tick  : out STD_LOGIC
        );
    end component;

    -- Signals to drive the UUT inputs
    signal tb_clk   : STD_LOGIC := '0';
    signal tb_reset : STD_LOGIC := '1'; -- Start with reset active
    signal tb_level : STD_LOGIC := '0';

    -- Signal to observe the UUT output
    signal tb_tick  : STD_LOGIC;

    -- Clock period definition (e.g., 10ns period, 100MHz freq)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT_EdgeDetector : edge_detect
        port map (
            clk   => tb_clk,
            reset => tb_reset,
            level => tb_level,
            tick  => tb_tick
        );

    -- Clock generation process
    clk_gen_p : process
    begin
        while true loop
            tb_clk <= '0';
            wait for CLK_PERIOD / 2;
            tb_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process clk_gen_p;

    -- Stimulus generation process (applying inputs)
    stim_p : process
    begin
        -- 1. Hold in reset for initial period
        wait for CLK_PERIOD * 2;
        tb_reset <= '0'; -- Release reset
        wait for CLK_PERIOD;

        -- 2. Test a single positive edge
        -- level is currently '0'
        wait for CLK_PERIOD * 1.5;
        tb_level <= '1'; -- Apply rising edge to input 'level'
        wait for CLK_PERIOD * 4;
        -- Observe 'tb_tick' should be '1' for exactly one cycle after this transition

        -- 3. Test a falling edge (should produce no tick)
        tb_level <= '0';
        wait for CLK_PERIOD * 3;
        
        -- 4. Test another positive edge quickly after falling
        tb_level <= '1';
        wait for CLK_PERIOD * 4;

        -- 5. Test level staying high (should produce no tick after the first cycle)
        tb_level <= '1';
        wait for CLK_PERIOD * 4;

        wait; -- Stop the stimulus process forever

    end process stim_p;

end tb_arch;