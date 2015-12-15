// Copyright 2007 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

module approx_fp_sqrt_tb();

reg [32*100*3-1:0] test_stim  =
{
	32'h3cbd2e88,32'h3e10b83c,32'h3e268164, // sqrt(0.0231) = 0.1520
	32'h3fe16596,32'h3f9df721,32'h3fb5bebd, // sqrt(1.7609) = 1.3270
	32'h411e97f4,32'h403b63c3,32'h40579951, // sqrt(9.9121) = 3.1483
	32'h3f70e360,32'h3f66f235,32'h3f84db2a, // sqrt(0.9410) = 0.9700
	32'h3eb20fc3,32'h3f0c66e4,32'h3f2189a6, // sqrt(0.3478) = 0.5897
	32'h3f9471b8,32'h3f8031ce,32'h3f937e1e, // sqrt(1.1597) = 1.0769
	32'h3fd18fc5,32'h3f9850bd,32'h3faf3e9d, // sqrt(1.6372) = 1.2795
	32'h3f7937da,32'h3f6ae7c1,32'h3f872239, // sqrt(0.9735) = 0.9867
	32'h3fa40d0e,32'h3f86c3dc,32'h3f9b0d64, // sqrt(1.2816) = 1.1321
	32'h40bbf643,32'h4010409a,32'h4025f7c0, // sqrt(5.8738) = 2.4236
	32'h3e3582c7,32'h3ec878e4,32'h3ee6a69e, // sqrt(0.1773) = 0.4210
	32'h3f2f7ae8,32'h3f451d1d,32'h3f62c969, // sqrt(0.6855) = 0.8279
	32'h3f73128b,32'h3f67fda6,32'h3f857503, // sqrt(0.9495) = 0.9744
	32'h3fcd1249,32'h3f96acbd,32'h3fad5b63, // sqrt(1.6021) = 1.2657
	32'h3f726959,32'h3f67acda,32'h3f854689, // sqrt(0.9469) = 0.9731
	32'h403c595c,32'h3fcc36ae,32'h3feaf497, // sqrt(2.9430) = 1.7155
	32'h3dcfe73f,32'h3e97b628,32'h3eae8cc2, // sqrt(0.1015) = 0.3186
	32'h3f1749ff,32'h3f3705ff,32'h3f529349, // sqrt(0.5910) = 0.7687
	32'h3f1fb0f5,32'h3f3c097d,32'h3f5857fe, // sqrt(0.6238) = 0.7898
	32'h3f831dec,32'h3f70f616,32'h3f8a9e15, // sqrt(1.0244) = 1.0121
	32'h3fee0570,32'h3fa25431,32'h3fbac3f7, // sqrt(1.8595) = 1.3636
	32'h3f4e0272,32'h3f5592b9,32'h3f75b953, // sqrt(0.8047) = 0.8971
	32'h40500233,32'h3fd69b5a,32'h3ff6e9ca, // sqrt(3.2501) = 1.8028
	32'h405dda8d,32'h3fdda24a,32'h3ffeff8a, // sqrt(3.4665) = 1.8618
	32'h3fd83c51,32'h3f9ab8c9,32'h3fb20365, // sqrt(1.6893) = 1.2997
	32'h3fa7ebef,32'h3f88587b,32'h3f9cdeec, // sqrt(1.3119) = 1.1454
	32'h3eeb19e5,32'h3f21547f,32'h3f399dc7, // sqrt(0.4592) = 0.6776
	32'h3f7e083d,32'h3f6d29c7,32'h3f886ebe, // sqrt(0.9923) = 0.9961
	32'h4055a1b7,32'h3fd97cfd,32'h3ffa3a79, // sqrt(3.3380) = 1.8270
	32'h3f96360b,32'h3f80f48a,32'h3f945e2b, // sqrt(1.1735) = 1.0833
	32'h3d399097,32'h3e4ab2d7,32'h3e69365d, // sqrt(0.0453) = 0.2128
	32'h3f269d81,32'h3f401202,32'h3f5cfbf2, // sqrt(0.6508) = 0.8067
	32'h3ec23238,32'h3f12a005,32'h3f28b29b, // sqrt(0.3793) = 0.6159
	32'h3f195ac3,32'h3f3844c0,32'h3f540207, // sqrt(0.5990) = 0.7740
	32'h405638c2,32'h3fd9c9d2,32'h3ffa92de, // sqrt(3.3472) = 1.8295
	32'h4041433a,32'h3fcedc33,32'h3fee0019, // sqrt(3.0197) = 1.7377
	32'h4020f41d,32'h3fbcc760,32'h3fd93276, // sqrt(2.5149) = 1.5858
	32'h3dfa860b,32'h3ea6899f,32'h3ebf9b96, // sqrt(0.1223) = 0.3498
	32'h3e820099,32'h3eefef59,32'h3f0a06f0, // sqrt(0.2539) = 0.5039
	32'h3f6f12f7,32'h3f66132a,32'h3f845adb, // sqrt(0.9339) = 0.9664
	32'h3f82de7e,32'h3f70bbc6,32'h3f8a7c89, // sqrt(1.0224) = 1.0111
	32'h3f184a26,32'h3f37a0af,32'h3f534542, // sqrt(0.5949) = 0.7713
	32'h3e59ca9a,32'h3edb986e,32'h3efca71f, // sqrt(0.2127) = 0.4612
	32'h3e06eca3,32'h3eacd76f,32'h3ec6dc57, // sqrt(0.1318) = 0.3630
	32'h3fa9a393,32'h3f890a83,32'h3f9dabc1, // sqrt(1.3253) = 1.1512
	32'h3ff83871,32'h3fa5c533,32'h3fbeb998, // sqrt(1.9392) = 1.3926
	32'h3d5a96f9,32'h3e5bff5e,32'h3e7d1d8e, // sqrt(0.0534) = 0.2310
	32'h3eb3746d,32'h3f0cf33b,32'h3f222b1d, // sqrt(0.3505) = 0.5920
	32'h3fa8b1f8,32'h3f88a8ca,32'h3f9d3b50, // sqrt(1.3179) = 1.1480
	32'h3f2fa554,32'h3f4534ef,32'h3f62e4d1, // sqrt(0.6861) = 0.8283
	32'h3e55a3bd,32'h3ed97e05,32'h3efa3ba9, // sqrt(0.2086) = 0.4568
	32'h3e1254d8,32'h3eb3ffeb,32'h3ecf18ad, // sqrt(0.1429) = 0.3780
	32'h3fe9eadd,32'h3fa0ec65,32'h3fb92600, // sqrt(1.8275) = 1.3518
	32'h3fb3a76e,32'h3f8d0742,32'h3fa24228, // sqrt(1.4035) = 1.1847
	32'h3efd47ee,32'h3f27739a,32'h3f40a8ca, // sqrt(0.4947) = 0.7033
	32'h3f7d85eb,32'h3f6cecea,32'h3f884bbb, // sqrt(0.9903) = 0.9952
	32'h3f92a333,32'h3f7ed2f6,32'h3f9297a3, // sqrt(1.1456) = 1.0703
	32'h3fa3542a,32'h3f8677d6,32'h3f9ab5eb, // sqrt(1.2760) = 1.1296
	32'h3ed7285e,32'h3f1a55f0,32'h3f3191ab, // sqrt(0.4202) = 0.6483
	32'h3fb2ec1b,32'h3f8cbda8,32'h3fa1ed7a, // sqrt(1.3978) = 1.1823
	32'h3ed19371,32'h3f185213,32'h3f2f4027, // sqrt(0.4093) = 0.6398
	32'h3daf3735,32'h3e8b4680,32'h3ea03dd8, // sqrt(0.0856) = 0.2925
	32'h3ccc2177,32'h3e16542b,32'h3e2cf57b, // sqrt(0.0249) = 0.1579
	32'h3fab1701,32'h3f89a039,32'h3f9e57ff, // sqrt(1.3366) = 1.1561
	32'h3e9a49b7,32'h3f02b188,32'h3f165e26, // sqrt(0.3013) = 0.5489
	32'h3f95f7bc,32'h3f80d9c8,32'h3f943f62, // sqrt(1.1716) = 1.0824
	32'h3f82c01e,32'h3f709fd4,32'h3f8a6c76, // sqrt(1.0215) = 1.0107
	32'h3f2bce3e,32'h3f430a01,32'h3f606659, // sqrt(0.6711) = 0.8192
	32'h3d64e9aa,32'h3e6121e2,32'h3e8182fa, // sqrt(0.0559) = 0.2364
	32'h3f18f355,32'h3f380692,32'h3f53ba7c, // sqrt(0.5975) = 0.7730
	32'h3f06741a,32'h3f2c8a29,32'h3f46836f, // sqrt(0.5252) = 0.7247
	32'h3fe0c84f,32'h3f9dbffb,32'h3fb57f4a, // sqrt(1.7561) = 1.3252
	32'h3fa80f68,32'h3f8866e1,32'h3f9cef7d, // sqrt(1.3130) = 1.1458
	32'h3ebe8d4b,32'h3f113e28,32'h3f271b78, // sqrt(0.3722) = 0.6101
	32'h3e2868be,32'h3ec11a00,32'h3ede2bad, // sqrt(0.1645) = 0.4055
	32'h3f9639a4,32'h3f80f615,32'h3f945ff1, // sqrt(1.1736) = 1.0833
	32'h409d04bc,32'h4003d84b,32'h4017b149, // sqrt(4.9068) = 2.2151
	32'h3f6752a8,32'h3f62507e,32'h3f82310e, // sqrt(0.9036) = 0.9506
	32'h3cc685de,32'h3e143fe0,32'h3e2a910f, // sqrt(0.0242) = 0.1557
	32'h400cf678,32'h3fb0aab9,32'h3fcb430b, // sqrt(2.2025) = 1.4841
	32'h40adcbe1,32'h400ab5ce,32'h401f975e, // sqrt(5.4311) = 2.3305
	32'h4102eca1,32'h402a429c,32'h4043e408, // sqrt(8.1828) = 2.8606
	32'h3f92ed70,32'h3f7f136f,32'h3f92bcba, // sqrt(1.1479) = 1.0714
	32'h3f086231,32'h3f2dc60e,32'h3f47eee2, // sqrt(0.5327) = 0.7299
	32'h3ed2099f,32'h3f187cff,32'h3f2f7189, // sqrt(0.4102) = 0.6405
	32'h3e8fd399,32'h3efc5eae,32'h3f112e35, // sqrt(0.2809) = 0.5300
	32'h3f169b28,32'h3f369c1f,32'h3f521979, // sqrt(0.5883) = 0.7670
	32'h3f6c912e,32'h3f64dd8a,32'h3f83a8bc, // sqrt(0.9241) = 0.9613
	32'h3fa6f39d,32'h3f87f386,32'h3f9c6ac4, // sqrt(1.3043) = 1.1421
	32'h3ea8d32c,32'h3f08b63c,32'h3f1d4aca, // sqrt(0.3297) = 0.5742
	32'h3f21f90f,32'h3f3d6029,32'h3f59e240, // sqrt(0.6327) = 0.7954
	32'h3f294a40,32'h3f419b1e,32'h3f5ec03b, // sqrt(0.6613) = 0.8132
	32'h3fba9322,32'h3f8fb814,32'h3fa55aac, // sqrt(1.4576) = 1.2073
	32'h3fa7bf44,32'h3f884658,32'h3f9cca0d, // sqrt(1.3105) = 1.1448
	32'h3f81d4a9,32'h3f6fc6c9,32'h3f89ef9b, // sqrt(1.0143) = 1.0071
	32'h3fc8eede,32'h3f95258e,32'h3fab9951, // sqrt(1.5698) = 1.2529
	32'h3fc8dec7,32'h3f951f95,32'h3fab9272, // sqrt(1.5693) = 1.2527
	32'h402c699a,32'h3fc3621c,32'h3fe0cbb8, // sqrt(2.6939) = 1.6413
	32'h41d9e8ca,32'h409b51c8,32'h40b2b36c, // sqrt(27.2387) = 5.2191
	32'h3ed3a355,32'h3f191171,32'h3f301c53 // sqrt(0.4134) = 0.6429

};

wire [31:0] in, sqrt_in, min_err, max_err;
assign {in,min_err,max_err} = test_stim [3*32-1:0];

// DUT
approx_fp_sqrt asq (.in(in),.out(sqrt_in));

integer n;
reg fail;

initial begin
	fail = 0;
	for (n=0; n<100; n=n+1) 
	begin : tst
		#5 if (sqrt_in < min_err) begin
			$display ("Mismatch - less than lowest acceptable value");
			fail = 1'b1;
		end
		if (sqrt_in > max_err) begin
			$display ("Mismatch - more than highest acceptable value");
			fail = 1'b1;
		end
		#100
		test_stim = test_stim >> (3*32);
	end
	if (!fail) $display ("PASS");
	$stop();
end

endmodule
