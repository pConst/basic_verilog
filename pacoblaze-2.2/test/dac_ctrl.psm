                  ;KCPSM3 Program - SPI Control of D/A converter on Spartan-3E Starter Kit.
                  ;
                  ;
                  ;Ken Chapman - Xilinx Ltd
                  ;
                  ;Version v1.00 - 24th November 2005
                  ;
                  ;This program uses an 8KHz interrupt to generate test waveforms on the
                  ;4 analogue outputs provided by the Linear Technology LTC2624 device.
                  ;
                  ;As well as the port connections vital to communication with the UART and the SPI
                  ;FLASH memory, there are additional port connections used to disable the other
                  ;devices sharing the SPI bus on the Starter Kit board. Although these could have been
                  ;controlled at the hardware level, they are included in this code to aid
                  ;future investigations of communication with the other SPI devices using PicoBlaze.
                  ;
                  ;Connections to the LEDs, switches and press buttons are provided to aid
                  ;development and enable further experiments. Otherwise know as having fun!
                  ;
                  ;Port definitions
                  ;
                  ;
                  CONSTANT SPI_control_port, 08   ;SPI clock and chip selects
                  CONSTANT SPI_sck, 01            ;                  SCK - bit0
                  CONSTANT SPI_rom_cs, 02         ;    serial rom select - bit1
                  CONSTANT SPI_spare_control, 04  ;                spare - bit2
                  CONSTANT SPI_amp_cs, 08         ;     amplifier select - bit3
                  CONSTANT SPI_adc_conv, 10       ;          A/D convert - bit4
                  CONSTANT SPI_dac_cs, 20         ;           D/A select - bit5
                  CONSTANT SPI_amp_shdn, 40       ;       amplifier SHDN - bit6
                  CONSTANT SPI_dac_clr, 80        ;            D/A clear - bit7
                  ;
                  CONSTANT SPI_output_port, 04    ;SPI data output
                  CONSTANT SPI_sdo, 80            ;   SDO - bit7
                  ;
                  CONSTANT SPI_input_port, 01     ;SPI data input
                  CONSTANT SPI_sdi, 80            ;             SDI - bit7
                  CONSTANT SPI_amp_sdi, 40        ;   amplifier SDI - bit6
                  ;
                  ;
                  CONSTANT LED_port, 80           ;8 simple LEDs
                  CONSTANT LED0, 01               ;     LED 0 - bit0
                  CONSTANT LED1, 02               ;         1 - bit1
                  CONSTANT LED2, 04               ;         2 - bit2
                  CONSTANT LED3, 08               ;         3 - bit3
                  CONSTANT LED4, 10               ;         4 - bit4
                  CONSTANT LED5, 20               ;         5 - bit5
                  CONSTANT LED6, 40               ;         6 - bit6
                  CONSTANT LED7, 80               ;         7 - bit7
                  ;
                  ;
                  CONSTANT switch_port, 00        ;Read switches and press buttons
                  CONSTANT BTN_north, 01          ;  Buttons     North - bit0
                  CONSTANT BTN_east, 02           ;               East - bit1
                  CONSTANT BTN_south, 04          ;              South - bit2
                  CONSTANT BTN_west, 08           ;               West - bit3
                  CONSTANT switch0, 10            ;  Switches        0 - bit4
                  CONSTANT switch1, 20            ;                  1 - bit5
                  CONSTANT switch2, 40            ;                  2 - bit6
                  CONSTANT switch3, 80            ;                  3 - bit7
                  ;
                  ;
                  ;
                  ;
                  ;Special Register usage
                  ;
                  ;
                  ;Useful data constants
                  ;
                  ;
                  ;Constant to define a software delay of 1us. This must be adjusted to reflect the
                  ;clock applied to KCPSM3. Every instruction executes in 2 clock cycles making the
                  ;calculation highly predictable. The '6' in the following equation even allows for
                  ;'CALL delay_1us' instruction in the initiating code.
                  ;
                  ; delay_1us_constant =  (clock_rate - 6)/4       Where 'clock_rate' is in MHz
                  ;
                  ;Example: For a 50MHz clock the constant value is (10-6)/4 = 11  (0B Hex).
                  ;For clock rates below 10MHz the value of 1 must be used and the operation will
                  ;become lower than intended.
                  ;
                  CONSTANT delay_1us_constant, 0B
                  ;
                  ;
                  ;
                  ;
                  ;
                  ;
                  ;Scratch Pad Memory Locations
                  ;
                  ;Values to be written to the D/A converter
                  ;
                  ;
                  CONSTANT chan_A_lsb, 00         ;Channel A value LS-Byte
                  CONSTANT chan_A_msb, 01         ;                MS-Byte
                  ;
                  CONSTANT chan_B_lsb, 02         ;Channel B value LS-Byte
                  CONSTANT chan_B_msb, 03         ;                MS-Byte
                  ;
                  CONSTANT chan_C_lsb, 04         ;Channel C value LS-Byte
                  CONSTANT chan_C_msb, 05         ;                MS-Byte
                  ;
                  CONSTANT chan_D_lsb, 06         ;Channel D value LS-Byte
                  CONSTANT chan_D_msb, 07         ;                MS-Byte
                  ;
                  ;
                  ;Value used to synthesise a triangle wave
                  ;
                  CONSTANT triangle_up_down, 08   ;Determines up or down slope
                  ;
                  ;Value used to synthesise a square wave
                  ;
                  CONSTANT square_count, 09       ;Counts samples in square wave
                  ;
                  ;
                  ;Values used to synthesise a sine wave
                  ;
                  CONSTANT sine_y_lsb, 10         ;Sine wave value LS-Byte
                  CONSTANT sine_y_msb, 11         ;                 MS-Byte
                  CONSTANT sine_y1_lsb, 12        ;Sine wave delayed LS-Byte
                  CONSTANT sine_y1_msb, 13        ;                  MS-Byte
                  CONSTANT sine_k_lsb, 14         ;Sine constant LS-Byte
                  CONSTANT sine_k_msb, 15         ;              MS-Byte
                  ;
                  ;
                  ;Sample counter used to give activity indication on LEDs
                  ;
                  CONSTANT sample_count_lsb, 20   ;16-bit counter LS-Byte
                  CONSTANT sample_count_msb, 21   ;               MS-Byte
                  ;
                  ;Initialise the system
                  ;
                  ;
      cold_start: CALL SPI_init                   ;initialise SPI bus ports
                  CALL init_sine_wave             ;initialise sine wave synthesis values
                  CALL delay_1s                   ;bus settling delay
                  LOAD s0, 00                     ;clear all internal D/A values
                  STORE s0, chan_A_lsb
                  STORE s0, chan_A_msb
                  STORE s0, chan_B_lsb
                  STORE s0, chan_B_msb
                  STORE s0, chan_C_lsb
                  STORE s0, chan_C_msb
                  STORE s0, chan_D_lsb
                  STORE s0, chan_D_msb
                  STORE s0, triangle_up_down      ;initial slope is up
                  CALL dac_reset                  ;reset D/A converter on all channels
                  ENABLE INTERRUPT                ;Interrupts define 8KHz sample rate
                  ;
                  ;
                  ;The program is interrupt driven to maintain an 8KHz sample rate. The main body
                  ;of the program waits for an interrupt to occur. The interrupt updates all four
                  ;analogue outputs with values stored in scratch pad memory. This takes approximately
                  ;58us of the 125us available between interrupts. The main program then prepares
                  ;new values for the analogue outputs (in less than 67us) before waiting for the
                  ;next interrupt.
                  ;
                  ;
      warm_start: LOAD sF, FF                     ;flag set and wait for interrupt to be serviced
        wait_int: COMPARE sF, FF
                  JUMP Z, wait_int                ;interrupt clears the flag
                  ;
                  ;
                  ;Channel A is a square wave of 2KHz.
                  ;
                  ;This is formed from the 2KHz square wave on channel C and demonstrates that the
                  ;D/A converter echoes the previously sent 32-bit command word.
                  ;
                  ;Following the interrupt service routine (ISR), the register set [s9,s8,s7,s6]
                  ;will contain the command which was last sent for the setting of channel C. The
                  ;12-bit sample value is extracted from this word and stored in the location for
                  ;channel A. This should mean that channel A is one sample behind channel C. In this
                  ;version that does not mean a lag of 90 degrees because each output is updated
                  ;sequentially and that takes approximatly 14.5us per channel.
                  ;
                  ;This will also demonstrate that the reference voltage on channels A and B is 3.3v
                  ;compared with 2.5v on channels C and D. So whilst the square wave on channel C is
                  ;set for 0.50v to 2.00v, it should be 0.66v to 2.64v on channel A.
                  ;
                  SR0 s7                          ; shift 12-bit value right 4 places
                  SRA s6
                  SR0 s7
                  SRA s6
                  SR0 s7
                  SRA s6
                  SR0 s7
                  SRA s6
                  STORE s7, chan_A_msb            ;store value for D/A output
                  STORE s6, chan_A_lsb
                  ;
                  ;
                  ;
                  ;
                  ;Channel B is a triangle waveform of 200Hz.
                  ;
                  ;Given the sample rate of 8KHz, there are 40 samples per waveform period.
                  ;To achieve close to full scale deflection, the waveform needs to increase or
                  ;decrease by 204 each sample so that over the first 20 samples it rises from
                  ;0 to 4080 and then over the next 20 samples it reduces back to zero.
                  ;
                  FETCH s0, chan_B_lsb            ;load current value into [s1,s0]
                  FETCH s1, chan_B_msb
                  FETCH s2, triangle_up_down      ;read current slope direction
                  COMPARE s2, 00                  ;determine current direction
                  JUMP NZ, slope_down
                  ADD s0, CC                      ;add 204 (00CC hex) to current value
                  ADDCY s1, 00
                  COMPARE s1, 0F                  ;test for peak value of 4080 (0FF0 hex)
                  JUMP NZ, store_channel_B
                  COMPARE s0, F0
                  JUMP NZ, store_channel_B
                  LOAD s2, 01                     ;change to slope down next time
                  STORE s2, triangle_up_down
                  JUMP store_channel_B
      slope_down: SUB s0, CC                      ;subtract 204 (00CC hex) from current value
                  SUBCY s1, 00
                  COMPARE s1, 00                  ;test for zero (0000 hex)
                  JUMP NZ, store_channel_B
                  COMPARE s0, 00
                  JUMP NZ, store_channel_B
                  LOAD s2, 00                     ;change to slope up next time
                  STORE s2, triangle_up_down
 store_channel_B: STORE s0, chan_B_lsb            ;store value for D/A output
                  STORE s1, chan_B_msb
                  ;
                  ;
                  ;Channel C is a square wave of 2KHz.
                  ;
                  ;Since the sample rate is 8KHz, this square wave is formed of two samples at a
                  ;low level and two samples at a high level. This is used to demonstrate when the
                  ;D/A converter output actually changes and how to determine the voltage levels.
                  ;It is also used indirectly to form the signal for channel A.
                  ;
                  ;The low level voltage is 0.50v.
                  ;   The 12-bit value is therefore 4096 x 0.5 / 2.5 = 819 (333 hex)
                  ;
                  ;The high level voltage is 2.00v.
                  ;   The 12-bit value is therefore 4096 x 2.0 / 2.5 = 3277 (CCD hex)
                  ;
                  ;
                  FETCH s2, square_count          ;read sample counter
                  TEST s2, 02                     ;bit 1 has correct frequency
                  JUMP NZ, square_high
                  LOAD s1, 03                     ;Set low level
                  LOAD s0, 33
                  JUMP store_channel_C
     square_high: LOAD s1, 0C                     ;Set high level
                  LOAD s0, CD
 store_channel_C: STORE s0, chan_C_lsb            ;store value for D/A output
                  STORE s1, chan_C_msb
                  ADD s2, 01                      ;increment sampel count
                  STORE s2, square_count          ;store new sample count
                  ;
                  ;Sine wave for channel D
                  ;
                  ;A synthesis algorithm is used to generate a stable 770Hz sine wave
                  ;which is one of the 8 tines used in DTMF telephone dialing.
                  ;
                  CALL calc_next_sine
                  SR0 s9                          ;reduce value to 12-bits
                  SRA s8
                  SR0 s9
                  SRA s8
                  SR0 s9
                  SRA s8
                  ADD s9, 08                      ;Scale signed number to mid-rail of unsigned output
                  STORE s9, chan_D_msb            ;store value for D/A output
                  STORE s8, chan_D_lsb
                  ;
                  ;
                  ;Drive LEDs with simple binary count of the samples to indicate
                  ;that the design is active.
                  ;
                  FETCH s0, sample_count_lsb      ;read sample counter
                  FETCH s1, sample_count_msb
                  ADD s0, 01                      ;increment counter
                  ADDCY s1, 00
                  STORE s0, sample_count_lsb      ;store new value
                  STORE s1, sample_count_msb
                  OUTPUT s1, LED_port             ;upper bits are 31.25Hz and lower
                  ;
                  JUMP warm_start                 ;wait for next interrupt
                  ;
                  ;**************************************************************************************
                  ;Sine wave synthesis algorithm
                  ;**************************************************************************************
                  ;
                  ;This example is set to generate 770Hz at a sample rate of 8KHz. 770Hz is one of
                  ;the eight DTMF frequences. Please see design documentation for more details.
                  ;
  init_sine_wave: LOAD s0, 24                     ;initial value 9216 (2400 hex)
                  STORE s0, sine_y_msb
                  LOAD s0, 00
                  STORE s0, sine_y_lsb
                  LOAD s0, 00                     ;initial delayed value 0 (0000 hex)
                  STORE s0, sine_y1_msb
                  STORE s0, sine_y1_lsb
                  LOAD s0, D2                     ;Coefficient for 770Hz is UFIX_16_15 value 53913/32768 = 1.64529
                  STORE s0, sine_k_msb
                  LOAD s0, 99
                  STORE s0, sine_k_lsb
                  RETURN
                  ;
                  ;
                  ;Calculate a new output sample for a single tone.
                  ;
                  ;The tone sample is generated as a 16-bit signed integer.
                  ;The waveform is virtually full scale deflection for a 15-bit integer
                  ;such that the addition of two tones for DTMF will not exceed the 16-bits
                  ;provided by two registers.
                  ;
                  ;Obtain current values from wscratch pad memory
                  ;
  calc_next_sine: FETCH sF, sine_y_msb            ;[sF,sE] is Y
                  FETCH sE, sine_y_lsb
                  FETCH sD, sine_y1_msb           ;[sD,sC] is Y1
                  FETCH sC, sine_y1_lsb
                  FETCH sB, sine_k_msb            ;[sB,sA] is K
                  FETCH sA, sine_k_lsb
                  ;
                  ;16-bit signed by 16-bit unsigned multiplication. [s9,s8]=[sB,sA]x[sF,sE]
                  ;
                  ;The unsigned number is of format UFIX_16_15 resulting
                  ;in a FIX_32_15 product. Since only the integer part of the
                  ;product is to be retained as a 16-bit value, their is no
                  ;shift of the result on the last cycle of the multiplication.
                  ;Execution requires a maximum of 145 instructions.
                  ;
                  LOAD s9, 00                     ;clear temporary result registers [s9,s8]
                  LOAD s8, 00
                  LOAD s0, 10                     ;16 bit multiply
       mult_loop: SRX s9                          ;signed divide result by 2
                  SRA s8
                  SR0 sB                          ;shift coefficient
                  SRA sA
                  JUMP NC, no_mult_add            ;test for active bit
                  ADD s8, sE                      ;16-bit signed addition
                  ADDCY s9, sF
     no_mult_add: SUB s0, 01                      ;test for 16 cycles
                  JUMP NZ, mult_loop
                  ;
                  ;Subtract of delayed sample
                  ;
                  SUB s8, sC                      ;16-bit signed subtract
                  SUBCY s9, sD
                  ;
                  ;Update scratch pad memory with new sample values
                  ;
                  STORE sF, sine_y1_msb           ;delayed sample gets previous output
                  STORE sE, sine_y1_lsb
                  STORE s9, sine_y_msb            ;new current sample
                  STORE s8, sine_y_lsb
                  RETURN
                  ;
                  ;
                  ;**************************************************************************************
                  ;SPI communication routines for D/A Converter
                  ;**************************************************************************************
                  ;
                  ;These routines will work with two output ports and one input port which should be
                  ;defined as follows using CONSTANT directives.
                  ;   (replace 'pp' with appropriate port address in each case)
                  ;In the list of CONSTANT directives, only the ones marked with a * are really required
                  ;for the D/A Converter system. The other directives are to control (disable) or
                  ;communicate with the other SPI components on the same SPI bus of the Spartan-3E Starter Kit.
                  ;
                  ;
                  ;
                  ;CONSTANT SPI_control_port, pp       ;SPI clock and chip selects     *
                  ;CONSTANT SPI_sck, 01                ;                  SCK - bit0   *
                  ;CONSTANT SPI_rom_cs, 02             ;    serial rom select - bit1
                  ;CONSTANT SPI_spare_control, 04      ;                spare - bit2
                  ;CONSTANT SPI_amp_cs, 08             ;     amplifier select - bit3
                  ;CONSTANT SPI_adc_conv, 10           ;          A/D convert - bit4
                  ;CONSTANT SPI_dac_cs, 20             ;           D/A select - bit5   *
                  ;CONSTANT SPI_amp_shdn, 40           ;       amplifier SHDN - bit6
                  ;CONSTANT SPI_dac_clr, 80            ;            D/A clear - bit7   *
                  ;
                  ;CONSTANT SPI_output_port, pp        ;SPI data output                *
                  ;CONSTANT SPI_sdo, 80                ;   SDO - bit7                  *
                  ;
                  ;CONSTANT SPI_input_port, pp         ;SPI data input                 *
                  ;CONSTANT SPI_sdi, 80                ;             SDI - bit7        *
                  ;CONSTANT SPI_amp_sdi, 40            ;   amplifier SDI - bit6
                  ;
                  ;
                  ;
                  ;
                  ;Initialise SPI bus
                  ;
                  ;This routine should be used to initialise the SPI bus.
                  ;The SCK clock is made low.
                  ;Device selections are made inactive as follows
                  ;   SPI_sck      = 0      Clock is Low (required)
                  ;   SPI_rom_cs   = 1      Deselect ROM
                  ;   spare        = 1      spare control bit
                  ;   SPI_amp_cs   = 1      Deselect amplifier
                  ;   SPI_adc_conv = 0      A/D convert ready to apply positive pulse
                  ;   SPI_dac_cs   = 1      Deselect D/A
                  ;   SPI_amp_shdn = 0      Amplifier active and available
                  ;   SPI_dac_clr  = 1      D/A clear off
                  ;
        SPI_init: LOAD s0, AE                     ;normally AE
                  OUTPUT s0, SPI_control_port
                  RETURN
                  ;
                  ;
                  ;
                  ;Send and receive one byte to and from the SPI D/A converter.
                  ;
                  ;The data supplied in register 's2' is transmitted to the SPI bus and
                  ;at the same time the received byte is used to replace the value in 's2'.
                  ;The SCK clock is generated by software and results in a communication rate of
                  ;2.5Mbit/s with a 50MHz clock.
                  ;
                  ;Note that you must have previously selected the required device on the bus
                  ;before attempting communication and you must subsequently deselect the device
                  ;when appropriate.
                  ;
                  ;Entry to this routine assumes that register s0 defines the state of the SPI
                  ;control signals including SCK which should be Low. The easiest way to achieve this is
                  ;to use the SPI_init routine before calling this one for the first time.
                  ;
                  ;As a 'master' the signal sequence is as follows..
                  ;   Transmit data bit on SDO line
                  ;   Drive SCK transition from low to high
                  ;   Receive data bit from SDI line (D/A transmits on previous falling edge)
                  ;   Drive SCK transition from high to low.
                  ;
                  ;Important note
                  ;   The received data bit must be captured some time before SCK goes low.
                  ;   However the combination of relatively slow clock to output time of the
                  ;   LTC2624 combined with the low drive strength of its SDO output means that
                  ;   the received bit needs maximum time to settle. Therefore this routine
                  ;   schedules the read as late as it can.
                  ;
   SPI_dac_tx_rx: LOAD s1, 08                     ;8-bits to transmit and receive
next_SPI_dac_bit: OUTPUT s2, SPI_output_port      ;output data bit ready to be used on rising edge
                  XOR s0, SPI_sck                 ;clock High (bit0)
                  OUTPUT s0, SPI_control_port     ;drive clock High
                  XOR s0, SPI_sck                 ;prepare clock Low (bit0)
                  INPUT s3, SPI_input_port        ;read input bit
                  TEST s3, SPI_sdi                ;detect state of received bit
                  SLA s2                          ;shift new data into result and move to next transmit bit
                  OUTPUT s0, SPI_control_port     ;drive clock Low
                  SUB s1, 01                      ;count bits
                  JUMP NZ, next_SPI_dac_bit       ;repeat until finished
                  RETURN
                  ;
                  ;
                  ;
                  ;Set a voltage on one of the LTC2624 D/A converter outputs
                  ;
                  ;The D/A converter has 4 channels. Specify which channel is to be set using
                  ;register sC as follows....
                  ;   sC     Channel                 Nominal Voltage Range
                  ;   00        A                       0 to 3.30v (or VREFAB)
                  ;   01        B                       0 to 3.30v (or VREFAB)
                  ;   02        C                       0 to 2.50v (or VREFCD)
                  ;   03        D                       0 to 2.50v (or VREFCD)
                  ;   0F        All channels            various as above.
                  ;
                  ;The analogue level is a 12-bit value to be supplied in lower 12-bits of register
                  ;pair [sB,sA]. If this value is called 'k' and is in the range 0 to 4095 (000 to FFF)
                  ;then
                  ;      Vout = (k/4096) * VREFx
                  ;Hence it is not possible to reach the absolute level of the reference.
                  ;
                  ;Here are some useful values..
                  ;    Voltage    A or B    C or D
                  ;      0.0       000       000
                  ;      0.5       26D       333
                  ;      0.65      327               A/D reference -1.00v
                  ;      1.0       4D9       666
                  ;      1.5       746       99A
                  ;      1.65      800       A8F     converter reference = 3.3/2 = 1.65v
                  ;      2.0       9B2       CCD
                  ;      2.5       C1F       FFF
                  ;      2.65      CD9               A/D reference +1.00v
                  ;      3.0       E8C       n/a
                  ;      3.3       FFF       n/a
                  ;
                  ;Note that the full scale deflection of FFF will result in different output
                  ;voltages due to different reference voltages for each pair of channels.
                  ;
                  ;SPI communication with the DAC only requires a 24-bit word to be transmitted.
                  ;However, the device internally contains a 32-bit shift register. When writing
                  ;a command word, the previous contents are shifted out and can be observed by
                  ;the master (Spartan-3E in this case). If you do not use a 32-bit format, then
                  ;the read back is confusing. Hence this routine uses a 32-bit format by transmitting
                  ;a dummy byte first.
                  ;
                  ;  Byte 1 = 00   8 dummy bits
                  ;  Byte 2 = 3c   Command nibble (3=write and update) and channel selection
                  ;  Byte 3 = dd   Upper 8-bits of the 12-bit voltage value
                  ;  Byte 4 = d0   lower 4-bits of the 12-bit voltage value and 4 dummy bits.
                  ;
                  ;At the end of this communication, the register set [s9,s8,s7,s6] will contain the
                  ;data received back from the D/A converter which should be the previous command.
                  ;
         set_dac: CALL SPI_init                   ;ensure known state of bus and s0 register
                  XOR s0, SPI_dac_cs              ;select low on D/A converter
                  OUTPUT s0, SPI_control_port
                  LOAD s2, 00                     ;Write dummy byte to DAC
                  CALL SPI_dac_tx_rx
                  LOAD s9, s2                     ;capture response
                  LOAD s2, sC                     ;Select channel for update
                  AND s2, 0F                      ;isolate channel bits to be certain of correct command
                  OR s2, 30                       ;Use immediate Write and Update command is "0011"
                  CALL SPI_dac_tx_rx
                  LOAD s8, s2                     ;capture response
                  SL0 sA                          ;data shift bits into correct position
                  SLA sB                          ;with 4 dummy bits ('0') in the least significant bits.
                  SL0 sA
                  SLA sB
                  SL0 sA
                  SLA sB
                  SL0 sA
                  SLA sB
                  LOAD s2, sB                     ;Write 12 bit value followed by 4 dummy bits
                  CALL SPI_dac_tx_rx
                  LOAD s7, s2                     ;capture response
                  LOAD s2, sA
                  CALL SPI_dac_tx_rx
                  LOAD s6, s2                     ;capture response
                  XOR s0, SPI_dac_cs              ;deselect the D/A converter to execute
                  OUTPUT s0, SPI_control_port
                  RETURN
                  ;
                  ;Perform a hard reset of the D/A converter
                  ;
       dac_reset: CALL SPI_init                   ;ensure known state of bus and s0 register
                  XOR s0, SPI_dac_clr             ;pulse the clear signal.
                  OUTPUT s0, SPI_control_port
                  XOR s0, SPI_dac_clr
                  OUTPUT s0, SPI_control_port
                  RETURN
                  ;
                  ;
                  ;**************************************************************************************
                  ;Software delay routines
                  ;**************************************************************************************
                  ;
                  ;
                  ;
                  ;Delay of 1us.
                  ;
                  ;Constant value defines reflects the clock applied to KCPSM3. Every instruction
                  ;executes in 2 clock cycles making the calculation highly predictable. The '6' in
                  ;the following equation even allows for 'CALL delay_1us' instruction in the initiating code.
                  ;
                  ; delay_1us_constant =  (clock_rate - 6)/4       Where 'clock_rate' is in MHz
                  ;
                  ;Registers used s0
                  ;
       delay_1us: LOAD s0, delay_1us_constant
        wait_1us: SUB s0, 01
                  JUMP NZ, wait_1us
                  RETURN
                  ;
                  ;Delay of 40us.
                  ;
                  ;Registers used s0, s1
                  ;
      delay_40us: LOAD s1, 28                     ;40 x 1us = 40us
       wait_40us: CALL delay_1us
                  SUB s1, 01
                  JUMP NZ, wait_40us
                  RETURN
                  ;
                  ;
                  ;Delay of 1ms.
                  ;
                  ;Registers used s0, s1, s2
                  ;
       delay_1ms: LOAD s2, 19                     ;25 x 40us = 1ms
        wait_1ms: CALL delay_40us
                  SUB s2, 01
                  JUMP NZ, wait_1ms
                  RETURN
                  ;
                  ;Delay of 20ms.
                  ;
                  ;Delay of 20ms used during initialisation.
                  ;
                  ;Registers used s0, s1, s2, s3
                  ;
      delay_20ms: LOAD s3, 14                     ;20 x 1ms = 20ms
       wait_20ms: CALL delay_1ms
                  SUB s3, 01
                  JUMP NZ, wait_20ms
                  RETURN
                  ;
                  ;Delay of approximately 1 second.
                  ;
                  ;Registers used s0, s1, s2, s3, s4
                  ;
        delay_1s: LOAD s4, 14                     ;50 x 20ms = 1000ms
         wait_1s: CALL delay_20ms
                  SUB s4, 01
                  JUMP NZ, wait_1s
                  RETURN
                  ;
                  ;
                  ;
                  ;**************************************************************************************
                  ;Interrupt Service Routine (ISR)
                  ;**************************************************************************************
                  ;
                  ;Interrupts occur at a rate of 8KHz.
                  ;
                  ;Each interrupt is the fundamental timing trigger used to set the sample rate and
                  ;it is therefore use to set the D/A outputs by copying the values stored in
                  ;scratch pad memory and outputting them to the D/A converter using the SPI bus.
                  ;
                  ;Because the SPI communication is in itself a predictable process, the sample rate
                  ;is preserved without sample jitter. All variable activities are left to the main
                  ;program.
                  ;
                  ;Each time PicoBlaze transmits a 32-bit command word to the D/A converter, the
                  ;D/A responds with the last command it was sent. So as the end of this service routine
                  ;the register set [s9,s8,s7,s6] will contain the command which has just been sent
                  ;for the setting of channel C.
                  ;
                  ;Set channel A
                  ;
             ISR: LOAD sC, 00                     ;channel A
                  FETCH sB, chan_A_msb            ;12-bit value
                  FETCH sA, chan_A_lsb
                  CALL set_dac
                  ;
                  ;Set channel B
                  ;
                  LOAD sC, 01                     ;channel B
                  FETCH sB, chan_B_msb            ;12-bit value
                  FETCH sA, chan_B_lsb
                  CALL set_dac
                  ;
                  ;Set channel C
                  ;
                  LOAD sC, 02                     ;channel C
                  FETCH sB, chan_C_msb            ;12-bit value
                  FETCH sA, chan_C_lsb
                  CALL set_dac
                  ;
                  ;Set channel A
                  ;
                  LOAD sC, 03                     ;channel D
                  FETCH sB, chan_D_msb            ;12-bit value
                  FETCH sA, chan_D_lsb
                  CALL set_dac
                  ;
                  LOAD sF, 00                     ;clear flag
                  RETURNI ENABLE
                  ;
                  ;
                  ;**************************************************************************************
                  ;Interrupt Vector
                  ;**************************************************************************************
                  ;
                  ADDRESS 3FF
                  JUMP ISR
                  ;
                  ;
