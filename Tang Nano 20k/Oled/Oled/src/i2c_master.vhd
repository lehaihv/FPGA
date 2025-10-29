library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_master is
    port (
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        start     : in  std_logic;
        stop      : in  std_logic;
        send_byte : in  std_logic;
        data_in   : in  std_logic_vector(7 downto 0);
        scl       : out std_logic;
        sda       : inout std_logic;
        busy      : out std_logic;
        done      : out std_logic
    );
end entity;

architecture rtl of i2c_master is
    constant CLK_FREQ   : integer := 27000000; -- Tang Nano clock
    constant I2C_FREQ   : integer := 100000;   -- 100 kHz
    constant DIVIDER    : integer := CLK_FREQ / (I2C_FREQ * 4);

    type state_type is (idle, start_cond, send_bit, ack_bit, stop_cond, done_state);
    signal state        : state_type := idle;
    signal bit_cnt      : integer range 0 to 7 := 0;
    signal clk_cnt      : integer := 0;
    signal sda_out      : std_logic := '1';
    signal scl_out      : std_logic := '1';
    signal data_buf     : std_logic_vector(7 downto 0) := (others => '0');
begin
    scl <= scl_out;
    sda <= sda_out when state /= ack_bit else 'Z';

    process(clk, reset_n)
    begin
        if reset_n = '0' then
            state <= idle;
            sda_out <= '1';
            scl_out <= '1';
            busy <= '0';
            done <= '0';
        elsif rising_edge(clk) then
            done <= '0';
            case state is
                when idle =>
                    busy <= '0';
                    if start = '1' then
                        busy <= '1';
                        sda_out <= '0';
                        state <= start_cond;
                    end if;

                when start_cond =>
                    scl_out <= '0';
                    data_buf <= data_in;
                    bit_cnt <= 7;
                    state <= send_bit;

                when send_bit =>
                    if clk_cnt = DIVIDER then
                        scl_out <= not scl_out;
                        clk_cnt <= 0;
                        if scl_out = '0' then
                            sda_out <= data_buf(bit_cnt);
                        elsif scl_out = '1' then
                            if bit_cnt = 0 then
                                state <= ack_bit;
                            else
                                bit_cnt <= bit_cnt - 1;
                            end if;
                        end if;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;

                when ack_bit =>
                    if clk_cnt = DIVIDER then
                        scl_out <= not scl_out;
                        clk_cnt <= 0;
                        if scl_out = '1' then
                            sda_out <= '0';
                            if stop = '1' then
                                state <= stop_cond;
                            else
                                state <= done_state;
                            end if;
                        end if;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;

                when stop_cond =>
                    sda_out <= '0';
                    scl_out <= '1';
                    sda_out <= '1';
                    state <= done_state;

                when done_state =>
                    busy <= '0';
                    done <= '1';
                    state <= idle;
            end case;
        end if;
    end process;
end architecture;
