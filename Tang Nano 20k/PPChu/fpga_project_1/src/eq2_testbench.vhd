library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity eq2_testbench is
end eq2_testbench;

architecture tb_arch of eq2_testbench is
    -- Signal declarations for the inputs and output of the Unit Under Test (UUT)
    signal test_in0, test_in1 : std_logic_vector(1 downto 0);
    signal test_out : std_logic;

begin

    -- Instantiate the circuit under test (eq2 entity from the work library)
    uut : entity work.eq2(struc_arch)
        port map (
            a    => test_in0, 
            b    => test_in1, 
            aeqb => test_out
        );

    -- Test vector generator process
    process
    begin
        -- Test Vector 1: 00 == 00 (True)
        test_in0 <= "00";
        test_in1 <= "00";
        wait for 200 ns;

        -- Test Vector 2: 01 != 00 (False)
        test_in0 <= "01";
        test_in1 <= "00";
        wait for 200 ns;

        -- Test Vector 3: 01 != 11 (False)
        test_in0 <= "01";
        test_in1 <= "11";
        wait for 200 ns;

        -- Test Vector 4: 10 == 10 (True)
        test_in0 <= "10";
        test_in1 <= "10";
        wait for 200 ns;
        
        -- Test Vector 5: 10 != 00 (False)
        test_in0 <= "10";
        test_in1 <= "00";
        wait for 200 ns;

        -- Test Vector 6: 11 == 11 (True)
        test_in0 <= "11";
        test_in1 <= "11";
        wait for 200 ns;

        -- Test Vector 7: 11 != 01 (False)
        test_in0 <= "11";
        test_in1 <= "01";
        wait for 200 ns;
        
        -- Stop the simulation after all tests run
        wait; 
        
    end process;

end tb_arch;