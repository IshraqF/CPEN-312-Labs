library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity part2 is
	port 
	(
		msd		: in unsigned (3 downto 0);
		lsd		: in unsigned (3 downto 0);
		KEY0	: in std_logic;
		KEY1	: in std_logic;
		add_sub	: in std_logic;
		
		HEX0	: out unsigned (6 downto 0);
		HEX1	: out unsigned (6 downto 0);
		HEX2	: out unsigned (6 downto 0);
		HEX3	: out unsigned (6 downto 0);
		HEX4	: out unsigned (6 downto 0);
		HEX5	: out unsigned (6 downto 0);
		LED	: out std_logic
	);
end part2;

architecture part2arch of part2 is
	signal amsd, alsd, bmsd, blsd	: unsigned (3 downto 0);
	signal oms, ols	: unsigned (3 downto 0);
	signal sum : unsigned (7 downto 0);
	signal disp_num2 : unsigned (7 downto 0);
	signal disp_num1 : unsigned (7 downto 0);
	signal num1 : unsigned (7 downto 0);
	signal num2 : unsigned (7 downto 0);
begin
	process(KEY1, msd, lsd, amsd, alsd)
	begin
		if (rising_edge(KEY1)) then
			amsd <= msd;
			alsd <= lsd;
		end if;
	end process;
	process(KEY0, msd, lsd, bmsd, blsd)
	begin
		if (rising_edge(KEY0)) then
			bmsd <= msd;
			blsd <= lsd;
		end if;
	end process;

	process(amsd) is
		-- Declaration(s)
	begin
		-- Sequential Statement(s)
		case amsd is
			 when "0000" => HEX5 <= "1000000";  -- display 0 on HEX
			 when "0001" => HEX5 <= "1111001";  -- display 1 on HEX
			 when "0010" => HEX5 <= "0100100";  -- display 2 on HEX
			 when "0011" => HEX5 <= "0110000";  -- display 3 on HEX
			 when "0100" => HEX5 <= "0011001";  -- display 4 on HEX
			 when "0101" => HEX5 <= "0010010";  -- display 5 on HEX
			 when "0110" => HEX5 <= "0000010";  -- display 6 on HEX
			 when "0111" => HEX5 <= "1111000";  -- display 7 on HEX
			 when "1000" => HEX5 <= "0000000";  -- display 8 on HEX
			 when "1001" => HEX5 <= "0011000";  -- display 9 on HEX
			 when others => HEX5 <= "1111111";  -- display blank on HEX
		end case;
	end process;
	process(alsd) is
		-- Declaration(s)
	begin
		-- Sequential Statement(s)
		case alsd is
			 when "0000" => HEX4 <= "1000000";  -- display 0 on HEX
			 when "0001" => HEX4 <= "1111001";  -- display 1 on HEX
			 when "0010" => HEX4 <= "0100100";  -- display 2 on HEX
			 when "0011" => HEX4 <= "0110000";  -- display 3 on HEX
			 when "0100" => HEX4 <= "0011001";  -- display 4 on HEX
			 when "0101" => HEX4 <= "0010010";  -- display 5 on HEX
			 when "0110" => HEX4 <= "0000010";  -- display 6 on HEX
			 when "0111" => HEX4 <= "1111000";  -- display 7 on HEX
			 when "1000" => HEX4 <= "0000000";  -- display 8 on HEX
			 when "1001" => HEX4 <= "0011000";  -- display 9 on HEX
			 when others => HEX4 <= "1111111";  -- display blank on HEX
		end case;
	end process;
	process(bmsd) is
		-- Declaration(s)
	begin
		-- Sequential Statement(s)
		case bmsd is
			 when "0000" => HEX3 <= "1000000";  -- display 0 on HEX
			 when "0001" => HEX3 <= "1111001";  -- display 1 on HEX
			 when "0010" => HEX3 <= "0100100";  -- display 2 on HEX
			 when "0011" => HEX3 <= "0110000";  -- display 3 on HEX
			 when "0100" => HEX3 <= "0011001";  -- display 4 on HEX
			 when "0101" => HEX3 <= "0010010";  -- display 5 on HEX
			 when "0110" => HEX3 <= "0000010";  -- display 6 on HEX
			 when "0111" => HEX3 <= "1111000";  -- display 7 on HEX
			 when "1000" => HEX3 <= "0000000";  -- display 8 on HEX
			 when "1001" => HEX3 <= "0011000";  -- display 9 on HEX
			 when others => HEX3 <= "1111111";  -- display blank on HEX
		end case;
	end process;
	process(blsd) is
		-- Declaration(s)
	begin
		-- Sequential Statement(s)
		case blsd is
			 when "0000" => HEX2 <= "1000000";  -- display 0 on HEX
			 when "0001" => HEX2 <= "1111001";  -- display 1 on HEX
			 when "0010" => HEX2 <= "0100100";  -- display 2 on HEX
			 when "0011" => HEX2 <= "0110000";  -- display 3 on HEX
			 when "0100" => HEX2 <= "0011001";  -- display 4 on HEX
			 when "0101" => HEX2 <= "0010010";  -- display 5 on HEX
			 when "0110" => HEX2 <= "0000010";  -- display 6 on HEX
			 when "0111" => HEX2 <= "1111000";  -- display 7 on HEX
			 when "1000" => HEX2 <= "0000000";  -- display 8 on HEX
			 when "1001" => HEX2 <= "0011000";  -- display 9 on HEX
			 when others => HEX2 <= "1111111";  -- display blank on HEX
		end case;
	end process;
	process(amsd, alsd, bmsd, blsd, oms, ols, sum)
	begin
		num1 <= (amsd * 10) + alsd;
		num2 <= (bmsd * 10) + blsd;
		if (add_sub = '1') then
			sum <= num1 - num2;
		else
			sum <= num1 + num2;
		end if;
		
		disp_num2 <= sum mod 10;
		disp_num1 <= (sum) / 10;
		
		if (disp_num1 >= 10) then
			oms <= disp_num1(3 downto 0) mod 10;
			LED <= '1';
		else 
			oms <= disp_num1(3 downto 0);
			LED <= '0';
		end if;
		
		ols <= disp_num2(3 downto 0);
		
	end process;
	process(oms) is
		-- Declaration(s)
	begin
		-- Sequential Statement(s)
		case oms is
			 when "0000" => HEX1 <= "1000000";  -- display 0 on HEX
			 when "0001" => HEX1 <= "1111001";  -- display 1 on HEX
			 when "0010" => HEX1 <= "0100100";  -- display 2 on HEX
			 when "0011" => HEX1 <= "0110000";  -- display 3 on HEX
			 when "0100" => HEX1 <= "0011001";  -- display 4 on HEX
			 when "0101" => HEX1 <= "0010010";  -- display 5 on HEX
			 when "0110" => HEX1 <= "0000010";  -- display 6 on HEX
			 when "0111" => HEX1 <= "1111000";  -- display 7 on HEX
			 when "1000" => HEX1 <= "0000000";  -- display 8 on HEX
			 when "1001" => HEX1 <= "0011000";  -- display 9 on HEX
			 when others => HEX1 <= "1111111";  -- display blank on HEX
		end case;
	end process;
	process(ols) is
		-- Declaration(s)
	begin
		-- Sequential Statement(s)
		case ols is
			 when "0000" => HEX0 <= "1000000";  -- display 0 on HEX
			 when "0001" => HEX0 <= "1111001";  -- display 1 on HEX
			 when "0010" => HEX0 <= "0100100";  -- display 2 on HEX
			 when "0011" => HEX0 <= "0110000";  -- display 3 on HEX
			 when "0100" => HEX0 <= "0011001";  -- display 4 on HEX
			 when "0101" => HEX0 <= "0010010";  -- display 5 on HEX
			 when "0110" => HEX0 <= "0000010";  -- display 6 on HEX
			 when "0111" => HEX0 <= "1111000";  -- display 7 on HEX
			 when "1000" => HEX0 <= "0000000";  -- display 8 on HEX
			 when "1001" => HEX0 <= "0011000";  -- display 9 on HEX
			 when others => HEX0 <= "1111111";  -- display blank on HEX
		end case;
	end process;

end part2arch;