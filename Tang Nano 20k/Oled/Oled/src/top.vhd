library ieee;
use ieee.std_logic_1164.all;

entity top is
    port (
        clk_27m   : in  std_logic;
        reset_btn : in  std_logic;
        scl       : out std_logic;
        sda       : inout std_logic
    );
end entity;

architecture rtl of top is
begin
    u1 : entity work.ssd1306_ctrl
        port map (
            clk => clk_27m,
            reset_n => not reset_btn,
            scl => scl,
            sda => sda
        );
end architecture;
