	component jtag_io is
		port (
			reset_reset_n : in  std_logic                     := 'X';             -- reset_n
			clk_clk       : in  std_logic                     := 'X';             -- clk
			out0_export   : out std_logic_vector(31 downto 0);                    -- export
			out1_export   : out std_logic_vector(31 downto 0);                    -- export
			in0_export    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export
			in1_export    : in  std_logic_vector(31 downto 0) := (others => 'X')  -- export
		);
	end component jtag_io;

	u0 : component jtag_io
		port map (
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			out0_export   => CONNECTED_TO_out0_export,   --  out0.export
			out1_export   => CONNECTED_TO_out1_export,   --  out1.export
			in0_export    => CONNECTED_TO_in0_export,    --   in0.export
			in1_export    => CONNECTED_TO_in1_export     --   in1.export
		);

