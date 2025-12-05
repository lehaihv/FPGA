library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity pwm_fixed_brightness is
    Port (
        clk             : in  STD_LOGIC;     -- 20ns system clock
        reset           : in  STD_LOGIC;     -- System reset
        -- Input port duty_cycle_ctrl is removed
        led_pwm_out     : out STD_LOGIC      -- PWM output to the LED
    );
end pwm_fixed_brightness;

architecture Behavioral of pwm_fixed_brightness is

    -- Define the maximum count value for the PWM period (~1.25 kHz frequency)
    constant PWM_PERIOD_MAX : integer := 40000; 

    -- Define the fixed duty cycle value (128 out of 255 is approx 50%)
    constant FIXED_DUTY_VALUE : integer := 20; 
    
    -- Calculate the threshold for turning OFF the LED within the period
    constant OFF_THRESHOLD : integer := (FIXED_DUTY_VALUE * PWM_PERIOD_MAX / 255);

    -- Counter must be large enough to hold 40000 (16 bits is sufficient)
    signal pwm_counter : unsigned (15 downto 0) := (others => '0');
    signal pwm_signal  : STD_LOGIC := '0';

begin

    process(clk, reset)
    begin
        if reset = '1' then
            pwm_counter <= (others => '0');
            pwm_signal <= '0';
        elsif rising_edge(clk) then

            -- Check if the counter has reached the end of the PWM period
            if to_integer(pwm_counter) >= PWM_PERIOD_MAX - 1 then
                pwm_counter <= (others => '0');
                -- Start the cycle by turning the LED ON
                pwm_signal <= '1';
            else
                pwm_counter <= pwm_counter + 1;
                -- Compare current count with the fixed off threshold
                if to_integer(pwm_counter) >= OFF_THRESHOLD then
                    pwm_signal <= '0'; -- Turn the LED OFF for the rest of the cycle
                end if;
            end if;

        end if;
    end process;

    led_pwm_out <= pwm_signal;

end Behavioral;