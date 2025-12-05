library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity swg_testbench is
end swg_testbench;

architecture tb_arch of swg_testbench is

    -- Component Declaration for the Unit Under Test (UUT)
    component square_wave_gen
        Port (
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            m_ctrl  : in  STD_LOGIC_VECTOR (3 downto 0);
            n_ctrl  : in  STD_LOGIC_VECTOR (3 downto 0);
            sq_wave : out STD_LOGIC
        );
    end component;

    -- Signals to drive the UUT
    signal tb_clk   : STD_LOGIC := '0';
    signal tb_reset : STD_LOGIC := '1'; -- Start with reset active
    signal tb_m     : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal tb_n     : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal tb_out   : STD_LOGIC;

    -- Clock period definition (20ns as per spec)
    constant CLK_PERIOD : time := 20 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT_Generator : square_wave_gen
        port map (
            clk     => tb_clk,
            reset   => tb_reset,
            m_ctrl  => tb_m,
            n_ctrl  => tb_n,
            sq_wave => tb_out
        );

    -- Clock process
    clk_gen_p : process
    begin
        while true loop
            tb_clk <= '0';
            wait for CLK_PERIOD / 2;
            tb_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process clk_gen_p;

    -- Stimulus process (setting m and n)
    stim_p : process
    begin
        -- Release reset after a short time
        wait for 100 ns;
        tb_reset <= '0';
        wait for 100 ns;

        -- Test Case 1: m=5, n=5 (50% duty cycle)
        tb_m <= "0101"; -- Decimal 5
        tb_n <= "0101"; -- Decimal 5
        wait for 500 ns; -- Observe the waveform for a while

        -- Test Case 2: m=10, n=2 (High duty cycle)
        tb_m <= "1010"; -- Decimal 10
        tb_n <= "0010"; -- Decimal 2
        wait for 500 ns;

        -- Test Case 3: m=1, n=15 (Low duty cycle)
        tb_m <= "0001"; -- Decimal 1
        tb_n <= "1111"; -- Decimal 15
        wait for 500 ns;

        wait; -- Stop the process forever
    end process stim_p;

end tb_arch;