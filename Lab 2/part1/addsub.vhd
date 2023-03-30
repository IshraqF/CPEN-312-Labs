library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addsub is
    port (
        SW       : in std_logic_vector(9 downto 0);
        KEY0 : in std_logic;
		  KEY1 : in std_logic;
        LEDR  : out std_logic_vector(7 downto 0);
		  LEDR8 : out std_logic
    );
end entity;

architecture rtl of addsub is
	signal A, B : unsigned(7 downto 0);
	signal result : unsigned(7 downto 0);
begin
	process (SW, KEY0, KEY1)
	begin
		if KEY0 = '0' then
			B <= unsigned(SW(7 downto 0));
			result(7 downto 0) <= B;
			LEDR <= std_logic_vector(result(7 downto 0));
		end if;
		if KEY1 = '0' then
			A <= unsigned(SW(7 downto 0));
			result(7 downto 0) <= A;
			LEDR <= std_logic_vector(result(7 downto 0));
		end if;
		case SW(9) is
			when '0' =>
				result <= A + B;
				LEDR <= std_logic_vector(result(7 downto 0));
				LEDR8 <= SW(9);
			when '1' =>
				result(7 downto 0) <= A - B;
				LEDR <= std_logic_vector(result(7 downto 0));
				LEDR8 <= SW(9);
		end case;
	end process;
		
end architecture;
