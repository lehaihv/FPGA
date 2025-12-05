library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Required for unsigned integer operations

entity square_wave_gen is
    Port (
        clk     : in  STD_LOGIC;  -- 20ns period system clock
        reset   : in  STD_LOGIC;  -- Synchronous or asynchronous reset (assumed async reset here)
        m_ctrl  : in  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit 'm' duration control
        n_ctrl  : in  STD_LOGIC_VECTOR (3 downto 0); -- 4-bit 'n' duration control
        sq_wave : out STD_LOGIC   -- The generated square wave output
    );
end square_wave_gen;

architecture Behavioral of square_wave_gen is
    -- Define states for the state machine
    type state_type is (STATE_ON, STATE_OFF);
    signal current_state : state_type := STATE_OFF;

    -- A single counter used for both ON and OFF durations
    -- Needs enough bits to cover the maximum possible duration (e.g., 15 * 100ns = 1500ns)
    -- We can just use the 4-bit input directly and count to m or n.
    signal counter : unsigned (3 downto 0) := (others => '0');

    -- Signal to hold the output value before assigning to the port
    signal output_val : STD_LOGIC := '0';

begin

    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= STATE_OFF;
            counter <= (others => '0');
            output_val <= '0';
        elsif rising_edge(clk) then

            -- The counter increments every 20ns clock cycle
            counter <= counter + 1;
            
            case current_state is
                when STATE_ON =>
                    -- Check if we've reached the 'm' duration (as an unsigned value)
                    if counter >= unsigned(m_ctrl) then
                        current_state <= STATE_OFF;
                        counter <= (others => '0'); -- Reset counter for next state
                        output_val <= '0';        -- Turn the wave OFF
                    else
                        output_val <= '1';        -- Keep the wave ON
                    end if;

                when STATE_OFF =>
                    -- Check if we've reached the 'n' duration (as an unsigned value)
                    if counter >= unsigned(n_ctrl) then
                        current_state <= STATE_ON;
                        counter <= (others => '0'); -- Reset counter for next state
                        output_val <= '1';        -- Turn the wave ON
                    else
                        output_val <= '0';        -- Keep the wave OFF
                    end if;
            end case;

        end if;
    end process;

    -- Assign the internal signal to the output port
    sq_wave <= output_val;

end Behavioral;