library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ssd1306_ctrl is
    port (
        clk      : in  std_logic;
        reset_n  : in  std_logic;
        scl      : out std_logic;
        sda      : inout std_logic
    );
end entity;

architecture rtl of ssd1306_ctrl is
    component i2c_master
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
    end component;

    signal start, stop, send_byte, busy, done : std_logic := '0';
    signal data_in : std_logic_vector(7 downto 0) := (others => '0');
    signal state   : integer := 0;

    constant SSD1306_ADDR : std_logic_vector(7 downto 1) := "0111100"; -- 0x3C
    type rom_type is array (0 to 4, 0 to 7) of std_logic_vector(7 downto 0);
begin
    i2c : i2c_master
        port map (
            clk => clk,
            reset_n => reset_n,
            start => start,
            stop => stop,
            send_byte => send_byte,
            data_in => data_in,
            scl => scl,
            sda => sda,
            busy => busy,
            done => done
        );

    process(clk, reset_n)
        type seq_array is array (0 to 30) of std_logic_vector(7 downto 0);
        variable init_seq : seq_array := (
            x"00", -- Control byte (command)
            x"AE", -- Display off
            x"D5", x"80", -- Set display clock divide ratio
            x"A8", x"3F", -- Multiplex ratio
            x"D3", x"00", -- Display offset
            x"40", -- Start line
            x"8D", x"14", -- Enable charge pump
            x"20", x"00", -- Memory mode horizontal
            x"A1", -- Segment remap
            x"C8", -- COM scan direction
            x"DA", x"12", -- COM pins config
            x"81", x"CF", -- Contrast
            x"D9", x"F1", -- Pre-charge
            x"DB", x"40", -- Vcom detect
            x"A4", -- Resume
            x"A6", -- Normal display
            x"AF", -- Display on
            others => x"00"
        );
        variable idx : integer := 0;
    begin
        if reset_n = '0' then
            start <= '0';
            stop <= '0';
            send_byte <= '0';
            state <= 0;
        elsif rising_edge(clk) then
            case state is
                when 0 => -- Start init
                    if busy = '0' then
                        data_in <= SSD1306_ADDR & '0';
                        start <= '1';
                        state <= 1;
                    end if;

                when 1 =>
                    start <= '0';
                    if done = '1' then
                        data_in <= x"00";
                        send_byte <= '1';
                        state <= 2;
                    end if;

                when 2 =>
                    send_byte <= '0';
                    if done = '1' then
                        data_in <= init_seq(idx);
                        send_byte <= '1';
                        idx := idx + 1;
                        if idx = 22 then
                            state <= 10; -- Done with init
                        end if;
                    end if;

                when 10 =>
                    send_byte <= '0';
                    if done = '1' then
                        data_in <= x"40"; -- Data mode
                        send_byte <= '1';
                        state <= 11;
                    end if;

                when 11 =>
                    -- Send simple “HELLO” bitmap pattern
                    send_byte <= '0';
                    if done = '1' then
                        data_in <= x"48"; -- ‘H’ column byte (demo)
                        send_byte <= '1';
                        state <= 12;
                    end if;

                when 12 =>
                    send_byte <= '0';
                    if done = '1' then
                        stop <= '1';
                        state <= 99;
                    end if;

                when 99 =>
                    stop <= '0';
                    null;
                when others =>
                    null;
            end case;
        end if;
    end process;
end architecture;
