quartus_map --family=stratixii --optimize=speed carry_and_speed_test | tee q.log
quartus_fit --fmax=1ghz carry_and_speed_test | tee f.log
quartus_tan carry_and_speed_test | tee t.log
grep "Longest register to register delay" t.log