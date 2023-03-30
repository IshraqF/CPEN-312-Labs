LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;


entity clock is

	port
	(
		CLK_50, KEY0, KEY1, KEY2, KEY3 : in std_logic;
		msd, lsd : in std_logic_vector(3 downto 0);
		SW9 : in std_logic;
		LEDR9, LEDR0 : out std_logic;
		msds, lsds, msdm, lsdm, msdh, lsdh : out std_logic_vector(0 to 6)
	);
end clock;

architecture a of clock is

	signal ClkFlag : std_logic;
	signal internal_count : std_logic_vector(28 downto 0);
	signal hs, ls, hm, lm, hh, lh : std_logic_vector(3 downto 0);
	signal ms_seg : std_logic_vector(0 to 6) := "0000001";
	signal ls_seg : std_logic_vector(0 to 6) := "0000001";
	signal mm_seg : std_logic_vector(0 to 6) := "0000001";
	signal lm_seg : std_logic_vector(0 to 6) := "0000001";
	signal mh_seg : std_logic_vector(0 to 6) := "0000001";
	signal lh_seg : std_logic_vector(0 to 6) := "1001111";
	signal am_pm : std_logic :='0';
	signal ams, als, amm, alm, amh, alh : std_logic_vector(3 downto 0);
	signal a_am_pm : std_logic :='0';

begin
	
	msds<=ms_seg;
	lsds<=ls_seg;
	msdm<=mm_seg;
	lsdm<=lm_seg;
	msdh<=mh_seg;
	lsdh<=lh_seg;
	LEDR9<=am_pm;
	
	--divide the 50mhz to 0.5hz
	process(CLK_50)
	begin
		if(CLK_50'event and CLK_50='1') then
			if internal_count<25000000 then
				internal_count<=internal_count+1;
			else
				internal_count<=(others => '0');
				ClkFlag<=not ClkFlag;
			end if;
		end if;
	end process;
	
	--set seconds
	process(ClkFlag, KEY0, SW9)
	begin
			if(SW9='0' and KEY0='0') then
				ls<=lsd;
				hs<=msd;
			elsif(ClkFlag'event and ClkFlag='1') then
				if(ls=9) then
					ls<="0000";
					if(hs=5) then
						hs<="0000";
					else hs<=hs+1;
					end if;
				else
					ls<=ls+1;
				end if;
			end if;
	end process;
	
	--set minute
	process(KEY1, ClkFlag, SW9)
	begin
			if(SW9='0' and KEY1='0') then
				lm<=lsd;
				hm<=msd;
			elsif(ClkFlag'event and ClkFlag='1') then
				if(ls=9 and hs=5) then
					if(lm=9) then
						lm<="0000";
						if(hm=5) then
							hm<="0000";
						else hm<=hm+1;
						end if;
					else
						lm<=lm+1;
					end if;
				end if;
			end if;
	end process;
	
	--set hour
	process(KEY2, ClkFlag, SW9)
	begin
			if(SW9='0' and KEY2='0') then
				lh<=lsd;
				hh<=msd;
			elsif(ClkFlag'event and ClkFlag='1') then
				if(lm=9 and hm=5 and ls=9 and hs=5) then
					if(hh=1 and lh=2) then
						lh<="0001";
						hh<="0000";
					else
						if(lh=9) then
							lh<="0000";
							hh<=hh+1;
						else lh<=lh+1;
						end if;
					end if;
				end if;
			end if;
	end process;
	
	--set am/pm
	process(KEY3, SW9)
	begin
			if(SW9='0' and KEY3='0') then
				am_pm<=lsd(0);
			else
				if(ls=9 and hs=5 and lm=9 and hm=5 and hh=1 and lh=1) then
					am_pm<= not am_pm;
				end if;
			end if;
	end process;
	
	--set alarm
	process(SW9, KEY0, KEY1, KEY2, KEY3)
	begin
		if(SW9='1') then
			if(KEY0='0') then
				als<=lsd;
				ams<=msd;
			elsif(KEY1='0') then
				alm<=lsd;
				amm<=msd;
			elsif(KEY2='0') then
				alh<=lsd;
				amh<=msd;
			else
				if(KEY3='0') then
					a_am_pm<=lsd(0);
				end if;
			end if;
		end if;
	end process;
	
	--compare alarm and time
	process(SW9)
	begin
		if(SW9='1' and hm=amm and lm=alm and hh=amh and lh=alh and am_pm=a_am_pm) then
			LEDR0<='1';
		else LEDR0<='0';
		end if;
	end process;
	
	--display time
	process(hs, ls, hm, lm, hh, lh)
	begin
		case hs is
			when "0000" => ms_seg <= "0000001";
			when "0001" => ms_seg <= "1001111";
			when "0010" => ms_seg <= "0010010";
			when "0011" => ms_seg <= "0000110";
			when "0100" => ms_seg <= "1001100";
			when "0101" => ms_seg <= "0100100";
			when "0110" => ms_seg <= "0100000";
			when "0111" => ms_seg <= "0001111";
			when "1000" => ms_seg <= "0000000";
			when "1001" => ms_seg <= "0000100";
			when others => ms_seg <= "1111111";
		end case;
		
		case ls is
			when "0000" => ls_seg <= "0000001";
			when "0001" => ls_seg <= "1001111";
			when "0010" => ls_seg <= "0010010";
			when "0011" => ls_seg <= "0000110";
			when "0100" => ls_seg <= "1001100";
			when "0101" => ls_seg <= "0100100";
			when "0110" => ls_seg <= "0100000";
			when "0111" => ls_seg <= "0001111";
			when "1000" => ls_seg <= "0000000";
			when "1001" => ls_seg <= "0000100";
			when others => ls_seg <= "1111111";
		end case;
		
		case hm is
			when "0000" => mm_seg <= "0000001";
			when "0001" => mm_seg <= "1001111";
			when "0010" => mm_seg <= "0010010";
			when "0011" => mm_seg <= "0000110";
			when "0100" => mm_seg <= "1001100";
			when "0101" => mm_seg <= "0100100";
			when "0110" => mm_seg <= "0100000";
			when "0111" => mm_seg <= "0001111";
			when "1000" => mm_seg <= "0000000";
			when "1001" => mm_seg <= "0000100";
			when others => mm_seg <= "1111111";
		end case;
		
		case lm is
			when "0000" => lm_seg <= "0000001";
			when "0001" => lm_seg <= "1001111";
			when "0010" => lm_seg <= "0010010";
			when "0011" => lm_seg <= "0000110";
			when "0100" => lm_seg <= "1001100";
			when "0101" => lm_seg <= "0100100";
			when "0110" => lm_seg <= "0100000";
			when "0111" => lm_seg <= "0001111";
			when "1000" => lm_seg <= "0000000";
			when "1001" => lm_seg <= "0000100";
			when others => lm_seg <= "1111111";
		end case;
		
		case hh is
			when "0000" => mh_seg <= "0000001";
			when "0001" => mh_seg <= "1001111";
			when "0010" => mh_seg <= "0010010";
			when "0011" => mh_seg <= "0000110";
			when "0100" => mh_seg <= "1001100";
			when "0101" => mh_seg <= "0100100";
			when "0110" => mh_seg <= "0100000";
			when "0111" => mh_seg <= "0001111";
			when "1000" => mh_seg <= "0000000";
			when "1001" => mh_seg <= "0000100";
			when others => mh_seg <= "1111111";
		end case;
		
		case lh is
			when "0000" => lh_seg <= "0000001";
			when "0001" => lh_seg <= "1001111";
			when "0010" => lh_seg <= "0010010";
			when "0011" => lh_seg <= "0000110";
			when "0100" => lh_seg <= "1001100";
			when "0101" => lh_seg <= "0100100";
			when "0110" => lh_seg <= "0100000";
			when "0111" => lh_seg <= "0001111";
			when "1000" => lh_seg <= "0000000";
			when "1001" => lh_seg <= "0000100";
			when others => lh_seg <= "1111111";
		end case;
	end process;
				
end a;
