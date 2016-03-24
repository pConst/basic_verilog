                    ;KCPSM3 Program - SPI Control of Amplifier and A/D converter on Spartan-3E Starter Kit.
                    ;
                    ;
                    ;Ken Chapman - Xilinx Ltd
                    ;
                    ;Version v1.00 - 21th December 2005
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
                    CONSTANT SPI_control_port, 08       ;SPI clock and chip selects
                    CONSTANT SPI_sck, 01                ;                  SCK - bit0
                    CONSTANT SPI_rom_cs, 02             ;    serial rom select - bit1
                    CONSTANT SPI_spare_control, 04      ;                spare - bit2
                    CONSTANT SPI_amp_cs, 08             ;     amplifier select - bit3
                    CONSTANT SPI_adc_conv, 10           ;          A/D convert - bit4
                    CONSTANT SPI_dac_cs, 20             ;           D/A select - bit5
                    CONSTANT SPI_amp_shdn, 40           ;       amplifier SHDN - bit6
                    CONSTANT SPI_dac_clr, 80            ;            D/A clear - bit7
                    ;
                    CONSTANT SPI_output_port, 04        ;SPI data output
                    CONSTANT SPI_sdo, 80                ;   SDO - bit7
                    ;
                    CONSTANT SPI_input_port, 01         ;SPI data input
                    CONSTANT SPI_sdi, 80                ;             SDI - bit7
                    CONSTANT SPI_amp_sdi, 40            ;   amplifier SDI - bit6
                    ;
                    ;
                    CONSTANT LED_port, 80               ;8 simple LEDs
                    CONSTANT LED0, 01                   ;     LED 0 - bit0
                    CONSTANT LED1, 02                   ;         1 - bit1
                    CONSTANT LED2, 04                   ;         2 - bit2
                    CONSTANT LED3, 08                   ;         3 - bit3
                    CONSTANT LED4, 10                   ;         4 - bit4
                    CONSTANT LED5, 20                   ;         5 - bit5
                    CONSTANT LED6, 40                   ;         6 - bit6
                    CONSTANT LED7, 80                   ;         7 - bit7
                    ;
                    ;
                    CONSTANT switch_port, 00            ;Read switches and press buttons
                    CONSTANT BTN_north, 01              ;  Buttons     North - bit0
                    CONSTANT BTN_east, 02               ;               East - bit1
                    CONSTANT BTN_south, 04              ;              South - bit2
                    CONSTANT BTN_west, 08               ;               West - bit3
                    CONSTANT switch0, 10                ;  Switches        0 - bit4
                    CONSTANT switch1, 20                ;                  1 - bit5
                    CONSTANT switch2, 40                ;                  2 - bit6
                    CONSTANT switch3, 80                ;                  3 - bit7
                    ;
                    ;LCD interface ports
                    ;
                    ;The master enable signal is not used by the LCD display itself
                    ;but may be required to confirm that LCD communication is active.
                    ;This is required on the Spartan-3E Starter Kit if the StrataFLASH
                    ;is used because it shares the same data pins and conflicts must be avoided.
                    ;
                    CONSTANT LCD_output_port, 40        ;LCD character module output data and control
                    CONSTANT LCD_E, 01                  ;   active High Enable        E - bit0
                    CONSTANT LCD_RW, 02                 ;   Read=1 Write=0           RW - bit1
                    CONSTANT LCD_RS, 04                 ;   Instruction=0 Data=1     RS - bit2
                    CONSTANT LCD_drive, 08              ;   Master enable (active High) - bit3
                    CONSTANT LCD_DB4, 10                ;   4-bit              Data DB4 - bit4
                    CONSTANT LCD_DB5, 20                ;   interface          Data DB5 - bit5
                    CONSTANT LCD_DB6, 40                ;                      Data DB6 - bit6
                    CONSTANT LCD_DB7, 80                ;                      Data DB7 - bit7
                    ;
                    ;
                    CONSTANT LCD_input_port, 02         ;LCD character module input data
                    CONSTANT LCD_read_spare0, 01        ;    Spare bits               - bit0
                    CONSTANT LCD_read_spare1, 02        ;    are zero                 - bit1
                    CONSTANT LCD_read_spare2, 04        ;                             - bit2
                    CONSTANT LCD_read_spare3, 08        ;                             - bit3
                    CONSTANT LCD_read_DB4, 10           ;    4-bit           Data DB4 - bit4
                    CONSTANT LCD_read_DB5, 20           ;    interface       Data DB5 - bit5
                    CONSTANT LCD_read_DB6, 40           ;                    Data DB6 - bit6
                    CONSTANT LCD_read_DB7, 80           ;                    Data DB7 - bit7
                    ;
                    ;
                    ;
                    ;
                    ;Special Register usage
                    ;
                    ;
                    ;
                    ;Scratch Pad Memory Locations
                    ;
                    ;Values read from the A/D converter
                    ;
                    CONSTANT ADC0_lsb, 00               ;ADC Channel 0 value LS-Byte
                    CONSTANT ADC0_msb, 01               ;                    MS-Byte
                    ;
                    CONSTANT ADC1_lsb, 02               ;ADC Channel 1 value LS-Byte
                    CONSTANT ADC1_msb, 03               ;                    MS-Byte
                    ;
                    ;Amplifier gain settings.
                    ;
                    ;Stored value is the 4-bit code for gain setting
                    ;  Code  1   2   3    4     5    6     7
                    ;  Gain -1  -2  -5  -10   -20  -50  -100
                    CONSTANT amp_A_gain, 04             ;Amplifier A gain value
                    CONSTANT amp_B_gain, 05             ;Amplifier B gain value
                    ;
                    ;Sample counter used to give activity indication on LEDs
                    ;
                    CONSTANT sample_count, 06           ;8-bit counter LS-Byte
                    ;
                    CONSTANT decimal0, 07               ;5 digit decimal value
                    CONSTANT decimal1, 08
                    CONSTANT decimal2, 09
                    CONSTANT decimal3, 0A
                    CONSTANT decimal4, 0B
                    ;
                    ;
                    ;
                    ;
                    ;Useful data constants
                    ;
                    CONSTANT VREF_lsb, 72               ;Reference voltage in milli-volts
                    CONSTANT VREF_msb, 06               ;Nominal value 1.65v so value is 1650 (0672 hex)
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
                    ;ASCII table
                    ;
                    CONSTANT character_a, 61
                    CONSTANT character_b, 62
                    CONSTANT character_c, 63
                    CONSTANT character_d, 64
                    CONSTANT character_e, 65
                    CONSTANT character_f, 66
                    CONSTANT character_g, 67
                    CONSTANT character_h, 68
                    CONSTANT character_i, 69
                    CONSTANT character_j, 6A
                    CONSTANT character_k, 6B
                    CONSTANT character_l, 6C
                    CONSTANT character_m, 6D
                    CONSTANT character_n, 6E
                    CONSTANT character_o, 6F
                    CONSTANT character_p, 70
                    CONSTANT character_q, 71
                    CONSTANT character_r, 72
                    CONSTANT character_s, 73
                    CONSTANT character_t, 74
                    CONSTANT character_u, 75
                    CONSTANT character_v, 76
                    CONSTANT character_w, 77
                    CONSTANT character_x, 78
                    CONSTANT character_y, 79
                    CONSTANT character_z, 7A
                    CONSTANT character_A, 41
                    CONSTANT character_B, 42
                    CONSTANT character_C, 43
                    CONSTANT character_D, 44
                    CONSTANT character_E, 45
                    CONSTANT character_F, 46
                    CONSTANT character_G, 47
                    CONSTANT character_H, 48
                    CONSTANT character_I, 49
                    CONSTANT character_J, 4A
                    CONSTANT character_K, 4B
                    CONSTANT character_L, 4C
                    CONSTANT character_M, 4D
                    CONSTANT character_N, 4E
                    CONSTANT character_O, 4F
                    CONSTANT character_P, 50
                    CONSTANT character_Q, 51
                    CONSTANT character_R, 52
                    CONSTANT character_S, 53
                    CONSTANT character_T, 54
                    CONSTANT character_U, 55
                    CONSTANT character_V, 56
                    CONSTANT character_W, 57
                    CONSTANT character_X, 58
                    CONSTANT character_Y, 59
                    CONSTANT character_Z, 5A
                    CONSTANT character_0, 30
                    CONSTANT character_1, 31
                    CONSTANT character_2, 32
                    CONSTANT character_3, 33
                    CONSTANT character_4, 34
                    CONSTANT character_5, 35
                    CONSTANT character_6, 36
                    CONSTANT character_7, 37
                    CONSTANT character_8, 38
                    CONSTANT character_9, 39
                    CONSTANT character_colon, 3A
                    CONSTANT character_stop, 2E
                    CONSTANT character_semi_colon, 3B
                    CONSTANT character_minus, 2D
                    CONSTANT character_divide, 2F       ;'/'
                    CONSTANT character_plus, 2B
                    CONSTANT character_comma, 2C
                    CONSTANT character_less_than, 3C
                    CONSTANT character_greater_than, 3E
                    CONSTANT character_equals, 3D
                    CONSTANT character_space, 20
                    CONSTANT character_CR, 0D           ;carriage return
                    CONSTANT character_question, 3F     ;'?'
                    CONSTANT character_dollar, 24
                    CONSTANT character_exclaim, 21      ;'!'
                    CONSTANT character_BS, 08           ;Back Space command character
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;
                    ;Initialise the system
                    ;
                    ;
        cold_start: CALL SPI_init                       ;initialise SPI bus ports
                    CALL LCD_reset                      ;initialise LCD display
                    ;
                    ;Write welcome message to LCD display
                    ;
                    LOAD s5, 10                         ;Line 1 position 0
                    CALL LCD_cursor
                    CALL disp_PicoBlaze                 ;Display 'PicoBlaze Inside'
                    LOAD s5, 23                         ;Line 2 position 3
                    CALL LCD_cursor
                    CALL disp_ADC_Control
                    CALL delay_1s                       ;wait 5 seconds
                    CALL delay_1s
                    CALL delay_1s
                    CALL delay_1s
                    CALL delay_1s
                    CALL LCD_clear                      ;Clear display
                    ;
                    LOAD s0, 00                         ;clear event counter
                    STORE s0, sample_count
                    ;
                    ;
                    ;
                    ;
                    LOAD s0, 01                         ;set initial amplifier gain to 1 on both channels
                    STORE s0, amp_A_gain
                    STORE s0, amp_B_gain
                    JUMP new_gain_set                   ;set, display the initial gain and enable interrupts
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
        warm_start: LOAD sF, FF                         ;flag set and wait for interrupt to be serviced
                    ENABLE INTERRUPT                    ;normal operation
          wait_int: INPUT sE, switch_port               ;test for button press changes to amplifier gain
                    TEST sE, BTN_north                  ;sE used as this in not effected by ISR
                    JUMP NZ, gain_increase
                    TEST sE, BTN_south
                    JUMP NZ, gain_decrease
                    COMPARE sF, FF                      ;wait for interrupt
                    JUMP Z, wait_int                    ;interrupt clears the flag
                    ;
                    ;
                    ;
                    ;Drive LEDs with simple binary count of the samples to indicate
                    ;that the design is active.
                    ;
                    FETCH s0, sample_count              ;increment counter
                    ADD s0, 01
                    STORE s0, sample_count
                    OUTPUT s0, LED_port                 ;count increments at 1Hz
                    ;
                    ;
                    ;Display the A/D Channel 0 value as hex on LCD
                    ;
                    LOAD s5, 2C                         ;Line 2 position 12
                    CALL LCD_cursor
                    FETCH s0, ADC0_msb
                    CALL disp_hex_byte
                    FETCH s0, ADC0_lsb
                    CALL disp_hex_byte
                    ;
                    ;
                    ;
                    ;Convert A/D channel 0 value to decimal voltage
                    ;
                    ;The 14-bit signed value from the A/D (sign extended to 16-bits)
                    ;relates to a voltage in the range -1.25v to +1.25v at the input
                    ;to the A/D converter relative to the 1.65v mid-rail reference point.
                    ;
                    ;The 14-bit value can be translated into the -1.25v to +1.25v using the
                    ;simple equation...
                    ;
                    ;   ADin = AD_value x 1.25/8192
                    ;
                    ;It is possible to scale the AD_value by 1.25/8192 using a fixed point
                    ;representation.
                    ;
                    ;However, it is also possible to scale it by another factor at the
                    ;same time which nicely converts to a binary value which is readily
                    ;converted to decimal. This can be achieved by example...
                    ;
                    ;For an input to the A/D converter of +1.25v relative to the reference,
                    ;the A/D will output the maximum conversion of 1FFF (+8191).
                    ;
                    ;In this case we would like to have the result value +1.250v which can be represented
                    ;by the integer value +1250 with appropiate positioning of the decimal point.
                    ;The constant to achieve this conversion is +1250/8191=+0.152606...
                    ;Also a number requiring fixed point representation but how many bits to use?
                    ;
                    ;The way to resolve this is to realise that a multiplication will be
                    ;performed and it would be nice if the +1250 result ended up in a register pair.
                    ;So if we perform a 16x16-bit multiplication such that the upper 16-bits of
                    ;the 32-bit result is the required value, then everything will resolve itself.
                    ;
                    ;Hence the constant required is actually (1250x(2^16))/8191=+10001 (2711 hex).
                    ;
                    ;Using the example 1FFF x 2711 = 04E1F8EF
                    ;   of which the upper 16-bits = 04E1 (+1249 decimal)
                    ;
                    ;Likewise the other limit case is E000 x 2711 = FB1DE000
                    ;   of which the upper 16-bits = FB1D (-1251 decimal)
                    ;
                    ;The values can be made perfect by rounding before truncation
                    ;
                    FETCH s2, ADC0_lsb                  ;Read A/D channel 0 value
                    FETCH s3, ADC0_msb
                    LOAD s0, 11                         ;scaling value for input to A/D converter
                    LOAD s1, 27
                    CALL mult_16x16s                    ;[s7,s6,s5,s4]=[s3,s2]x[s1,s0]
                    SL0 s5                              ;round value before truncation
                    ADDCY s6, 00
                    ADDCY s7, 00
                    ;
                    ;The register pair [s7,s6] now holds the binary value
                    ;representing the input level to the A/D converter in milli-volts.
                    ;This is now displayed on the LCD. Negative values need to be converted to
                    ;signed magnitude for display.
                    ;
                    LOAD s5, 20                         ;Line 2 position 0
                    CALL LCD_cursor
                    CALL disp_AD                        ;display A/D=
                    TEST s7, 80                         ;test sign bit of value
                    JUMP NZ, neg_AD
                    LOAD s5, character_plus
                    JUMP AD_sign
            neg_AD: XOR s6, FF                          ;complement [s7,s6] to make positive
                    XOR s7, FF
                    ADD s6, 01
                    ADDCY s7, 00
                    LOAD s5, character_minus
           AD_sign: CALL LCD_write_data                 ;display sign of value
                    CALL disp_volts                     ;display 4 digit value as X.XXXv
                    ;
                    ;Convert A/D channel 0 value to display the VINA decimal voltage
                    ;
                    ;The same fundamental technique can be used to convert the 14-bit
                    ;A/D value into the level at the VINA input except that two more factors
                    ;must be considered.
                    ;
                    ;The first is that the amplifier inverts and has gain. Therefore the
                    ;VINA input level is opposite polarity and could be a smaller deviation
                    ;from the mid rail 1.65v reference.
                    ;
                    ;Secondly, to display the actual voltage level at the VINA terminal
                    ;the 1.65v offset must be added.
                    ;
                    ;The voltage at the VINA input is therefore...
                    ;
                    ;   VINA = [AD_value x (1.25/(8192 x G))]+1.65
                    ;
                    ;Following the same methodology as for the A/D value, it means that there
                    ;is a set of scaling factors to deal with the negative gain values.
                    ;
                    ; K = (+1250 x (2^16)) / (8191 x G)
                    ;
                    ;        G             K     (K Hex)
                    ;       -1          -10001   (D8EF)
                    ;       -2           -5001   (EC77)
                    ;       -5           -2000   (F830)
                    ;      -10           -1000   (FC18)
                    ;      -20            -500   (FE0C)
                    ;      -50            -200   (FF38)
                    ;     -100            -100   (FF9C)
                    ;
                    FETCH s2, ADC0_lsb                  ;Read A/D channel 0 value
                    FETCH s3, ADC0_msb
                    FETCH s4, amp_A_gain                ;read A gain and select appropiate gain setting
                    LOAD s0, EF                         ;scaling value for amplifier gain of -1
                    LOAD s1, D8
                    COMPARE s4, 01
                    JUMP Z, mult_VINA
                    LOAD s0, 77                         ;scaling value for amplifier gain of -2
                    LOAD s1, EC
                    COMPARE s4, 02
                    JUMP Z, mult_VINA
                    LOAD s0, 30                         ;scaling value for amplifier gain of -5
                    LOAD s1, F8
                    COMPARE s4, 03
                    JUMP Z, mult_VINA
                    LOAD s0, 18                         ;scaling value for amplifier gain of -10
                    LOAD s1, FC
                    COMPARE s4, 05
                    JUMP Z, mult_VINA
                    LOAD s0, 0C                         ;scaling value for amplifier gain of -20
                    LOAD s1, FE
                    COMPARE s4, 06
                    JUMP Z, mult_VINA
                    LOAD s0, 38                         ;scaling value for amplifier gain of -50
                    LOAD s1, FF
                    COMPARE s4, 01
                    JUMP Z, mult_VINA
                    LOAD s0, 9C                         ;scaling value for amplifier gain of -100
                    LOAD s1, FF
         mult_VINA: CALL mult_16x16s                    ;[s7,s6,s5,s4]=[s3,s2]x[s1,s0]
                    SL0 s5                              ;round value before truncation
                    ADDCY s6, 00
                    ADDCY s7, 00
                    ADD s6, VREF_lsb                    ;add 1.65v offset represented at 1650 (0672 hex)
                    ADDCY s7, VREF_msb
                    ;
                    ;The register pair [s7,s6] now holds the binary value
                    ;representing the VINA input level in milli-volts.
                    ;This must be a positive value due to the offset of 1.65v
                    ;being greater than the maximum relative range of -1.25v to +1.25v.
                    ;This binary value can now be converted to a decimal digits
                    ;and displayed on the LCD.
                    ;
                    ;If the A/D value is maximum negative (E000) or maximum positive (1FFF)
                    ;then an indication of the actual value being applied being greater or
                    ;less than that computed will be made.
                    ;
                    LOAD s5, 17                         ;Line 1 position 7
                    CALL LCD_cursor
                    CALL disp_VA                        ;display VA=
                    FETCH s2, ADC0_lsb                  ;Read A/D channel 0 value
                    FETCH s3, ADC0_msb
                    COMPARE s3, E0                      ;test for maximum negative
                    JUMP NZ, test_max_pos
                    COMPARE s2, 00
                    JUMP NZ, test_max_pos
                    LOAD s5, character_greater_than     ;display >
                    CALL LCD_write_data
                    JUMP disp_VINA_volts
      test_max_pos: COMPARE s3, 1F                      ;test for maximum positive
                    JUMP NZ, disp_VINA_volts
                    COMPARE s2, FF
                    JUMP NZ, disp_VINA_volts
                    LOAD s5, character_less_than        ;display <
                    CALL LCD_write_data
   disp_VINA_volts: CALL disp_volts                     ;display 4 digit value as X.XXXv
                    JUMP warm_start
                    ;
                    ;
                    ;**************************************************************************************
                    ;Display voltage level at in the form X.XXX on the LCD at current cursor position
                    ;**************************************************************************************
                    ;
                    ;Value to be displayed must be unsigned (positive) in the
                    ;[s7,s6] register pair. Only the lower 4 digits are displayed.
                    ;
        disp_volts: CALL integer16_to_BCD               ;convert [s7,s6] to BCD in scratch pad memory
                    FETCH s5, decimal3
                    ADD s5, 30                          ;convert to ASCII
                    CALL LCD_write_data
                    LOAD s5, character_stop
                    CALL LCD_write_data
                    FETCH s5, decimal2
                    ADD s5, 30                          ;convert to ASCII
                    CALL LCD_write_data
                    FETCH s5, decimal1
                    ADD s5, 30                          ;convert to ASCII
                    CALL LCD_write_data
                    FETCH s5, decimal0
                    ADD s5, 30                          ;convert to ASCII
                    CALL LCD_write_data
                    LOAD s5, character_space            ;ensure next position is cleared
                    CALL LCD_write_data
                    RETURN
                    ;
                    ;**************************************************************************************
                    ;Changing amplifier gain using press buttons
                    ;**************************************************************************************
                    ;
                    ;Possible gain values are
                    ;   Gain   Amplifier
                    ;            code
                    ;    -1        1
                    ;    -2        2
                    ;    -5        3
                    ;   -10        4
                    ;   -20        5
                    ;   -50        6
                    ;  -100        7
                    ;
     gain_increase: DISABLE INTERRUPT                   ;stop normal operation
                    FETCH s0, amp_A_gain                ;read current gain
                    ADD s0, 01
                    COMPARE s0, 08                      ;test for too big
                    JUMP NZ, new_gain_set
                    LOAD s0, 07                         ;maximum gain
                    JUMP new_gain_set
     gain_decrease: DISABLE INTERRUPT                   ;stop normal operation
                    FETCH s0, amp_A_gain                ;read current gain
                    SUB s0, 01
                    JUMP NZ, new_gain_set
                    LOAD s0, 01                         ;minimum gain
      new_gain_set: STORE s0, amp_A_gain                ;store new value
                    FETCH s2, amp_B_gain                ;form the amplifier control byte
                    SL0 s2                              ;B amplifier set by upper 4 bits
                    SL0 s2
                    SL0 s2
                    SL0 s2
                    OR s2, s0                           ;A amplifier set by lower
                    CALL set_amp                        ;set SPI amplifier
                    ;display gain setting on LCD
                    LOAD s5, 10                         ;Line 1 position 0
                    CALL LCD_cursor
                    LOAD s5, character_G
                    CALL LCD_write_data
                    LOAD s5, character_equals
                    CALL LCD_write_data
                    LOAD s5, character_minus
                    CALL LCD_write_data
                    FETCH s0, amp_A_gain                ;read A gain setting
                    COMPARE s0, 01                      ;determine actual gain value
                    JUMP NZ, test_A2
                    LOAD s5, character_1                ;gain is -1
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    JUMP wait_no_press
           test_A2: COMPARE s0, 02
                    JUMP NZ, test_A3
                    LOAD s5, character_2                ;gain is -2
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    JUMP wait_no_press
           test_A3: COMPARE s0, 03
                    JUMP NZ, test_A4
                    LOAD s5, character_5                ;gain is -5
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    JUMP wait_no_press
           test_A4: COMPARE s0, 04
                    JUMP NZ, test_A5
                    LOAD s5, character_1                ;gain is -10
                    CALL LCD_write_data
                    LOAD s5, character_0
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    JUMP wait_no_press
           test_A5: COMPARE s0, 05
                    JUMP NZ, test_A6
                    LOAD s5, character_2                ;gain is -20
                    CALL LCD_write_data
                    LOAD s5, character_0
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    JUMP wait_no_press
           test_A6: COMPARE s0, 06
                    JUMP NZ, gain_A7
                    LOAD s5, character_5                ;gain is -50
                    CALL LCD_write_data
                    LOAD s5, character_0
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    JUMP wait_no_press
           gain_A7: LOAD s5, character_1                ;gain is -100
                    CALL LCD_write_data
                    LOAD s5, character_0
                    CALL LCD_write_data
                    LOAD s5, character_0
                    CALL LCD_write_data
     wait_no_press: CALL delay_20ms                     ;delay to help avoid switch bounce
                    INPUT s0, switch_port               ;check for release of press buttons
                    TEST s0, 05                         ;north and south buttons
                    JUMP NZ, wait_no_press
                    JUMP warm_start
                    ;
                    ;**************************************************************************************
                    ;16-bit by 16-bit Signed multiplier
                    ;**************************************************************************************
                    ;
                    ;16 bit signed multiplication using shift and add technique.
                    ;The full precision 32-bit product is returned.
                    ;
                    ;The key to signed multiplication is to think of all bits of the second operand
                    ;[s1,s0] as being positive except for the most significant bit. This means that
                    ;the first operand is added to the result in all cases when there is a '1' in the
                    ;second operand except for the MSB case when the first operand is subtracted if there
                    ;is a '1'.
                    ;
                    ;[s7,s6,s5,s4]=[s3,s2]x[s1,s0]
                    ;
                    ;Registers used s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,sA
                    ;
       mult_16x16s: LOAD s7, 00                         ;clear accumulator
                    LOAD s6, 00
                    LOAD s5, 00                         ;Set bit 14 to act as a bit shift counter
                    LOAD s4, 00
                    LOAD s8, 00                         ;sign extend [s3,s2] to form [s9,s8,s3,s2]
                    TEST s3, 80                         ;test sign of first operand
                    JUMP Z, m16s_pos
                    LOAD s8, FF
          m16s_pos: LOAD s9, s8                         ;[s9,s8,s3,s2]=0000xxxx or FFFFxxxx as required
                    LOAD sA, 0F                         ;15 positive shift and add operations to perform
         m16s_loop: SR0 s1                              ;shift right operand [s1,s0]
                    SRA s0
                    JUMP NC, m16s_noadd                 ;test for a '1'
                    ADD s4, s2                          ;32-bit addition [s7,s6,s5,s4]=[s7,s6,s5,s4]+[s9,s8,s3,s2]
                    ADDCY s5, s3
                    ADDCY s6, s8
                    ADDCY s7, s9
        m16s_noadd: SL0 s2                              ;multiply first operand by 2
                    SLA s3
                    SLA s8
                    SLA s9
                    SUB sA, 01
                    JUMP NZ, m16s_loop                  ;move to next unsigned bit
                    TEST s0, 01                         ;test sign bit of operand [s1,s0]
                    JUMP NC, m16s_nosub
                    SUB s4, s2                          ;32-bit subtraction [s7,s6,s5,s4]=[s7,s6,s5,s4]-[s9,s8,s3,s2]
                    SUBCY s5, s3
                    SUBCY s6, s8
                    SUBCY s7, s9
        m16s_nosub: RETURN
                    ;
                    ;
                    ;
                    ;**************************************************************************************
                    ;16-bit positive integer to 5 digit decimal conversion
                    ;**************************************************************************************
                    ;
                    ;Convert the 16 bit value in register set [s7,s6]
                    ;into the BCD decimal equivalent located in the scratch pad memory
                    ;locations 'decimal0' to 'decimal4' which must be in ascending locations.
                    ;
                    ;Register set [s9,s8,s7,s6] are preserved.
                    ;
                    ;
                    ;Each digit is formed in turn starting with the least significant.
                    ;
                    ;Registers used s0,s1,s2,s3,s4,s5,s6,s7,s8
                    ;
  integer16_to_BCD: LOAD s0, 05                         ;5 digits to be formed from value up to 65535
                    LOAD s8, decimal0                   ;pointer for LS-Digit
   int_to_BCD_loop: CALL divide_16bit_by_10             ;[s7,s6]=[s7,s6]/10  with remainder in s4
                    STORE s4, (s8)                      ;remainder becomes digit value
                    ADD s8, 01                          ;move to next most significant digit
                    SUB s0, 01                          ;one less digit to compute
                    JUMP NZ, int_to_BCD_loop
                    RETURN
                    ;
                    ;Divide 16-bit binary integer by 10
                    ;
                    ;The value to be divided is held in register set [s7,s6]
                    ;and this is where the result is returned to.
                    ;
                    ;At then end of the integer division the remainder in the range 0 to 9
                    ;will be in register s4.
                    ;
                    ;Registers used s1,s2,s3,s4,s5,s6,s7
                    ;Other registers are used but are preserved
                    ;
divide_16bit_by_10: LOAD s4, s6                         ;copy input value to [s5,s4]
                    LOAD s5, s7
                    LOAD s6, 00                         ;clear result
                    LOAD s7, 00
                    LOAD s2, 00                         ;initialise '10' value into msb's of set [s3,s2]
                    LOAD s3, A0
                    LOAD s1, 0D                         ;13 subtract and shift iterations to be performed
        div10_loop: SUB s4, s2                          ;perform 16-bit subtract [s5,s4]-[s3,s2]
                    SUBCY s5, s3
                    JUMP C, div10_restore
                    SL1 s6                              ;shift '1' into result because subtract was possible
                    JUMP div10_shifts
     div10_restore: ADD s4, s2                          ;perform 32-bit addition [s5,s4]+[s3,s2]
                    ADDCY s5, s3                        ;to restore value
                    SL0 s6                              ;shift '0' into result because subtract was not possible
      div10_shifts: SLA s7                              ;complete 16-bit shift left
                    SR0 s3                              ;divide '10' value by 2 (shift right 1 place)
                    SRA s2
                    SUB s1, 01                          ;count iterations
                    JUMP NZ, div10_loop
                    RETURN
                    ;
                    ;
                    ;**************************************************************************************
                    ;SPI communication routines for Spartan-3E Starter Kit
                    ;**************************************************************************************
                    ;
                    ;These routines will work with two output ports and one input port which should be
                    ;defined as follows using CONSTANT directives.
                    ;   (replace 'pp' with appropriate port address in each case)
                    ;In the list of CONSTANT directives, there are ports associated with all the SPI devices
                    ;provided on the board. Even if some devices are not used, it is vital that the remaining
                    ;devices are disabled. Leaving all signals connected and use of these routines will ensure
                    ;that all other devices are disabled when communicating with a particular device.
                    ;
                    ;
                    ;
                    ;CONSTANT SPI_control_port, pp       ;SPI clock and chip selects
                    ;CONSTANT SPI_sck, 01                ;                  SCK - bit0
                    ;CONSTANT SPI_rom_cs, 02             ;    serial rom select - bit1
                    ;CONSTANT SPI_spare_control, 04      ;                spare - bit2
                    ;CONSTANT SPI_amp_cs, 08             ;     amplifier select - bit3
                    ;CONSTANT SPI_adc_conv, 10           ;          A/D convert - bit4
                    ;CONSTANT SPI_dac_cs, 20             ;           D/A select - bit5
                    ;CONSTANT SPI_amp_shdn, 40           ;       amplifier SHDN - bit6
                    ;CONSTANT SPI_dac_clr, 80            ;            D/A clear - bit7
                    ;
                    ;CONSTANT SPI_output_port, pp        ;SPI data output
                    ;CONSTANT SPI_sdo, 80                ;   SDO - bit7
                    ;
                    ;CONSTANT SPI_input_port, pp         ;SPI data input
                    ;CONSTANT SPI_sdi, 80                ;             SDI - bit7
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
          SPI_init: LOAD s0, AE                         ;normally AE
                    OUTPUT s0, SPI_control_port
                    RETURN
                    ;
                    ;
                    ;
                    ;
                    ;**************************************************************************************
                    ;SPI communication routines for Programmable Amplifier
                    ;**************************************************************************************
                    ;
                    ;
                    ;Set the A and B channel gain of the Dual Amplifier (LTC6912-1).
                    ;
                    ;The gain value should be provided in the s2 register with the upper nibble
                    ;defining the gain for the B channel and lower nibble the gain for the A channel.
                    ; 0000 = 0 hex = Gain  0 with input hi-Z and output driving
                    ; 0001 = 1 hex = Gain -1
                    ; 0010 = 2 hex = Gain -2
                    ; 0011 = 3 hex = Gain -5
                    ; 0100 = 4 hex = Gain -10
                    ; 0101 = 5 hex = Gain -20
                    ; 0110 = 6 hex = Gain -50
                    ; 0111 = 7 hex = Gain -100
                    ; 1000 = 8 hex = software shutdown (power on default). Hi-Z output.
                    ;
                    ;On return, the s2, register will contain the response from the LTC6912-1 amplifier.
                    ;This will be the same format and indicate the previous setting of the amplifier.
                    ;The response is obtained from the dedicated AMP_SDI signal since the LTC6912 output
                    ;is always active and can not be on a shared SPI bus.
                    ;
           set_amp: CALL SPI_init                       ;ensure known state of bus and s0 register
                    XOR s0, SPI_amp_cs                  ;select low on Amplifier chip select
                    OUTPUT s0, SPI_control_port
                    LOAD s1, 08                         ;8-bits to transmit and receive
  next_amp_SPI_bit: OUTPUT s2, SPI_output_port          ;output data bit
                    XOR s0, SPI_sck                     ;clock High (bit0)
                    OUTPUT s0, SPI_control_port         ;drive clock High
                    INPUT s3, SPI_input_port            ;read input bit
                    TEST s3, SPI_amp_sdi                ;detect state of received bit
                    SLA s2                              ;shift new data into result and move to next transmit bit
                    XOR s0, SPI_sck                     ;clock Low (bit0)
                    OUTPUT s0, SPI_control_port         ;drive clock Low
                    SUB s1, 01                          ;count bits
                    JUMP NZ, next_amp_SPI_bit           ;repeat until finished
                    XOR s0, SPI_amp_cs                  ;deselect the amplifier
                    OUTPUT s0, SPI_control_port
                    RETURN
                    ;
                    ;
                    ;
                    ;**************************************************************************************
                    ;SPI communication routines for A/D Converter
                    ;**************************************************************************************
                    ;
                    ;
                    ;
                    ;Sample A/D converter (LTC1407A-1) and return results.
                    ;
                    ;Note there is a latency of one read to obtain the value. Each read results in the
                    ;the analogue inputs being sampled and converted but this value will only be transmitted
                    ;during the next read and conversion cycle.
                    ;
                    ;The results are returned as follows.
                    ;   Channel 0 in registers [s9,s8]
                    ;   Channel 1 in registers [s7,s6]
                    ;Where each is a 14-bit twos complement value sign extended to 16-bits.
                    ;
                    ;Each 14-bit value represents the analogue voltage in the range -1.25v to +1.25v
                    ;relative to the reference voltage of 1.65v (3.3v/2). Hence the actual input voltage
                    ;range is 0.4v to 2.9v. Since the input to the A/D is supplied via the programmable
                    ;amplifier, the VINA and VINB inputs are inverted and may cover a smaller range if                       ;
                    ;desired.
                    ;
                    ;Examples
                    ;   VINA = 0.65v with gain=-1 means input to A/D = 2.65v
                    ;      This is equivalent to +1.00v which is value (8192/1.25)*1 = 6553 (1999 hex)
                    ;
                    ;   VINA = 2.65v with gain=-1 means input to A/D = 0.65v
                    ;      This is equivalent to -1.00v which is value (2048/1.25)*-1 = -6553 (E667 hex)
                    ;
                    ;
                    ;Although the A/D converter claims to be an SPI device, it really
                    ;does not conform to the normal specification of the 4-wire interface.
                    ;
                    ;Firstly the CONV signal is only pulsed High and does not behave like
                    ;a normal active low select signal. Secondly, the communication is
                    ;34 bits which does not fit a byte boundary, and thirdly, the data output
                    ;to its SDO pin changes as a result of rising edges of SCK clock which
                    ;is not the same as the falling edge used by other devices.
                    ;
          adc_read: CALL SPI_init                       ;ensure known state of bus and s0 register
                    XOR s0, SPI_adc_conv                ;Pulse AD-CONV High to take sample and start
                    OUTPUT s0, SPI_control_port         ;  conversion and transmission of data.
                    XOR s0, SPI_adc_conv                ;AD-CONV Low
                    OUTPUT s0, SPI_control_port
                    LOAD s1, 22                         ;34 clocks to read all data
      next_adc_bit: XOR s0, SPI_sck                     ;clock High (bit0)
                    OUTPUT s0, SPI_control_port         ;drive clock High
                    XOR s0, SPI_sck                     ;clock Low (bit0)
                    OUTPUT s0, SPI_control_port         ;drive clock Low
                    INPUT s3, SPI_input_port            ;read input bit
                    TEST s3, SPI_sdi                    ;detect state of received bit
                    SLA s6                              ;shift new data into result registers
                    SLA s7
                    SLA s8
                    SLA s9
                    SUB s1, 01                          ;count bits
                    JUMP NZ, next_adc_bit               ;repeat until finished
                    SRX s9                              ;sign extend 14-bit result in [s9,s8]
                    SRA s8
                    SRX s9
                    SRA s8
                    SRX s7                              ;sign extend 14-bit result in [s7,s6]
                    SRA s6
                    SRX s7
                    SRA s6
                    RETURN
                    ;
                    ;
                    ;**************************************************************************************
                    ;LCD text messages
                    ;**************************************************************************************
                    ;
                    ;
                    ;Display 'PicoBlaze' on LCD at current cursor position
                    ;
                    ;
    disp_PicoBlaze: LOAD s5, character_P
                    CALL LCD_write_data
                    LOAD s5, character_i
                    CALL LCD_write_data
                    LOAD s5, character_c
                    CALL LCD_write_data
                    LOAD s5, character_o
                    CALL LCD_write_data
                    LOAD s5, character_B
                    CALL LCD_write_data
                    LOAD s5, character_l
                    CALL LCD_write_data
                    LOAD s5, character_a
                    CALL LCD_write_data
                    LOAD s5, character_z
                    CALL LCD_write_data
                    LOAD s5, character_e
                    CALL LCD_write_data
                    RETURN
                    ;
                    ;
                    ;Display 'ADC Control' on LCD at current cursor position
                    ;
                    ;
  disp_ADC_Control: LOAD s5, character_A
                    CALL LCD_write_data
                    LOAD s5, character_D
                    CALL LCD_write_data
                    LOAD s5, character_C
                    CALL LCD_write_data
                    LOAD s5, character_space
                    CALL LCD_write_data
                    LOAD s5, character_C
                    CALL LCD_write_data
                    LOAD s5, character_o
                    CALL LCD_write_data
                    LOAD s5, character_n
                    CALL LCD_write_data
                    LOAD s5, character_t
                    CALL LCD_write_data
                    LOAD s5, character_r
                    CALL LCD_write_data
                    LOAD s5, character_o
                    CALL LCD_write_data
                    LOAD s5, character_l
                    CALL LCD_write_data
                    RETURN
                    ;
                    ;
                    ;Display 'VA=' on LCD at current cursor position
                    ;
                    ;
           disp_VA: LOAD s5, character_V
                    CALL LCD_write_data
                    LOAD s5, character_A
                    CALL LCD_write_data
                    LOAD s5, character_equals
                    CALL LCD_write_data
                    RETURN
                    ;
                    ;
                    ;Display 'A/D' on LCD at current cursor position
                    ;
                    ;
           disp_AD: LOAD s5, character_A
                    CALL LCD_write_data
                    LOAD s5, character_divide
                    CALL LCD_write_data
                    LOAD s5, character_D
                    CALL LCD_write_data
                    LOAD s5, character_equals
                    CALL LCD_write_data
                    RETURN
                    ;
                    ;
                    ;
                    ;**************************************************************************************
                    ;Value to ASCII Conversions and LCD display
                    ;**************************************************************************************
                    ;
                    ;Convert hexadecimal value provided in register s0 into ASCII characters
                    ;
                    ;The value provided must can be any value in the range 00 to FF and will be converted into
                    ;two ASCII characters.
                    ;     The upper nibble will be represented by an ASCII character returned in register s2.
                    ;     The lower nibble will be represented by an ASCII character returned in register s1.
                    ;
                    ;The ASCII representations of '0' to '9' are 30 to 39 hexadecimal which is simply 30 hex
                    ;added to the actual decimal value. The ASCII representations of 'A' to 'F' are 41 to 46
                    ;hexadecimal requiring a further addition of 07 to the 30 already added.
                    ;
                    ;Registers used s0, s1 and s2.
                    ;
 hex_byte_to_ASCII: LOAD s1, s0                         ;remember value supplied
                    SR0 s0                              ;isolate upper nibble
                    SR0 s0
                    SR0 s0
                    SR0 s0
                    CALL hex_to_ASCII                   ;convert
                    LOAD s2, s0                         ;upper nibble value in s2
                    LOAD s0, s1                         ;restore complete value
                    AND s0, 0F                          ;isolate lower nibble
                    CALL hex_to_ASCII                   ;convert
                    LOAD s1, s0                         ;lower nibble value in s1
                    RETURN
                    ;
                    ;Convert hexadecimal value provided in register s0 into ASCII character
                    ;
                    ;Register used s0
                    ;
      hex_to_ASCII: SUB s0, 0A                          ;test if value is in range 0 to 9
                    JUMP C, number_char
                    ADD s0, 07                          ;ASCII char A to F in range 41 to 46
       number_char: ADD s0, 3A                          ;ASCII char 0 to 9 in range 30 to 40
                    RETURN
                    ;
                    ;
                    ;Display the two character HEX value of the register contents 's0' on
                    ;the LCD display at the current cursor position.
                    ;
                    ;Registers used s0, s1, s2, s4, s5, s6
                    ;
     disp_hex_byte: CALL hex_byte_to_ASCII
                    LOAD s6, s1                         ;remember lower hex character
                    LOAD s5, s2                         ;display upper hex character
                    CALL LCD_write_data
                    LOAD s5, s6                         ;display lower hex character
                    CALL LCD_write_data
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
        delay_40us: LOAD s1, 28                         ;40 x 1us = 40us
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
         delay_1ms: LOAD s2, 19                         ;25 x 40us = 1ms
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
        delay_20ms: LOAD s3, 14                         ;20 x 1ms = 20ms
         wait_20ms: CALL delay_1ms
                    SUB s3, 01
                    JUMP NZ, wait_20ms
                    RETURN
                    ;
                    ;Delay of approximately 1 second.
                    ;
                    ;Registers used s0, s1, s2, s3, s4
                    ;
          delay_1s: LOAD s4, 32                         ;50 x 20ms = 1000ms
           wait_1s: CALL delay_20ms
                    SUB s4, 01
                    JUMP NZ, wait_1s
                    RETURN
                    ;
                    ;
                    ;
                    ;**************************************************************************************
                    ;LCD Character Module Routines
                    ;**************************************************************************************
                    ;
                    ;LCD module is a 16 character by 2 line display but all displays are very similar
                    ;The 4-wire data interface will be used (DB4 to DB7).
                    ;
                    ;The LCD modules are relatively slow and software delay loops are used to slow down
                    ;KCPSM3 adequately for the LCD to communicate. The delay routines are provided in
                    ;a different section (see above in this case).
                    ;
                    ;
                    ;Pulse LCD enable signal 'E' high for greater than 230ns (1us is used).
                    ;
                    ;Register s4 should define the current state of the LCD output port.
                    ;
                    ;Registers used s0, s4
                    ;
       LCD_pulse_E: XOR s4, LCD_E                       ;E=1
                    OUTPUT s4, LCD_output_port
                    CALL delay_1us
                    XOR s4, LCD_E                       ;E=0
                    OUTPUT s4, LCD_output_port
                    RETURN
                    ;
                    ;Write 4-bit instruction to LCD display.
                    ;
                    ;The 4-bit instruction should be provided in the upper 4-bits of register s4.
                    ;Note that this routine does not release the master enable but as it is only
                    ;used during initialisation and as part of the 8-bit instruction write it
                    ;should be acceptable.
                    ;
                    ;Registers used s4
                    ;
   LCD_write_inst4: AND s4, F8                          ;Enable=1 RS=0 Instruction, RW=0 Write, E=0
                    OUTPUT s4, LCD_output_port          ;set up RS and RW >40ns before enable pulse
                    CALL LCD_pulse_E
                    RETURN
                    ;
                    ;
                    ;Write 8-bit instruction to LCD display.
                    ;
                    ;The 8-bit instruction should be provided in register s5.
                    ;Instructions are written using the following sequence
                    ; Upper nibble
                    ; wait >1us
                    ; Lower nibble
                    ; wait >40us
                    ;
                    ;Registers used s0, s1, s4, s5
                    ;
   LCD_write_inst8: LOAD s4, s5
                    AND s4, F0                          ;Enable=0 RS=0 Instruction, RW=0 Write, E=0
                    OR s4, LCD_drive                    ;Enable=1
                    CALL LCD_write_inst4                ;write upper nibble
                    CALL delay_1us                      ;wait >1us
                    LOAD s4, s5                         ;select lower nibble with
                    SL1 s4                              ;Enable=1
                    SL0 s4                              ;RS=0 Instruction
                    SL0 s4                              ;RW=0 Write
                    SL0 s4                              ;E=0
                    CALL LCD_write_inst4                ;write lower nibble
                    CALL delay_40us                     ;wait >40us
                    LOAD s4, F0                         ;Enable=0 RS=0 Instruction, RW=0 Write, E=0
                    OUTPUT s4, LCD_output_port          ;Release master enable
                    RETURN
                    ;
                    ;
                    ;
                    ;Write 8-bit data to LCD display.
                    ;
                    ;The 8-bit data should be provided in register s5.
                    ;Data bytes are written using the following sequence
                    ; Upper nibble
                    ; wait >1us
                    ; Lower nibble
                    ; wait >40us
                    ;
                    ;Registers used s0, s1, s4, s5
                    ;
    LCD_write_data: LOAD s4, s5
                    AND s4, F0                          ;Enable=0 RS=0 Instruction, RW=0 Write, E=0
                    OR s4, 0C                           ;Enable=1 RS=1 Data, RW=0 Write, E=0
                    OUTPUT s4, LCD_output_port          ;set up RS and RW >40ns before enable pulse
                    CALL LCD_pulse_E                    ;write upper nibble
                    CALL delay_1us                      ;wait >1us
                    LOAD s4, s5                         ;select lower nibble with
                    SL1 s4                              ;Enable=1
                    SL1 s4                              ;RS=1 Data
                    SL0 s4                              ;RW=0 Write
                    SL0 s4                              ;E=0
                    OUTPUT s4, LCD_output_port          ;set up RS and RW >40ns before enable pulse
                    CALL LCD_pulse_E                    ;write lower nibble
                    CALL delay_40us                     ;wait >40us
                    LOAD s4, F0                         ;Enable=0 RS=0 Instruction, RW=0 Write, E=0
                    OUTPUT s4, LCD_output_port          ;Release master enable
                    RETURN
                    ;
                    ;
                    ;
                    ;
                    ;Read 8-bit data from LCD display.
                    ;
                    ;The 8-bit data will be read from the current LCD memory address
                    ;and will be returned in register s5.
                    ;It is advisable to set the LCD address (cursor position) before
                    ;using the data read for the first time otherwise the display may
                    ;generate invalid data on the first read.
                    ;
                    ;Data bytes are read using the following sequence
                    ; Upper nibble
                    ; wait >1us
                    ; Lower nibble
                    ; wait >40us
                    ;
                    ;Registers used s0, s1, s4, s5
                    ;
    LCD_read_data8: LOAD s4, 0E                         ;Enable=1 RS=1 Data, RW=1 Read, E=0
                    OUTPUT s4, LCD_output_port          ;set up RS and RW >40ns before enable pulse
                    XOR s4, LCD_E                       ;E=1
                    OUTPUT s4, LCD_output_port
                    CALL delay_1us                      ;wait >260ns to access data
                    INPUT s5, LCD_input_port            ;read upper nibble
                    XOR s4, LCD_E                       ;E=0
                    OUTPUT s4, LCD_output_port
                    CALL delay_1us                      ;wait >1us
                    XOR s4, LCD_E                       ;E=1
                    OUTPUT s4, LCD_output_port
                    CALL delay_1us                      ;wait >260ns to access data
                    INPUT s0, LCD_input_port            ;read lower nibble
                    XOR s4, LCD_E                       ;E=0
                    OUTPUT s4, LCD_output_port
                    AND s5, F0                          ;merge upper and lower nibbles
                    SR0 s0
                    SR0 s0
                    SR0 s0
                    SR0 s0
                    OR s5, s0
                    LOAD s4, 04                         ;Enable=0 RS=1 Data, RW=0 Write, E=0
                    OUTPUT s4, LCD_output_port          ;Stop reading 5V device and release master enable
                    CALL delay_40us                     ;wait >40us
                    RETURN
                    ;
                    ;
                    ;Reset and initialise display to communicate using 4-bit data mode
                    ;Includes routine to clear the display.
                    ;
                    ;Requires the 4-bit instructions 3,3,3,2 to be sent with suitable delays
                    ;following by the 8-bit instructions to set up the display.
                    ;
                    ;  28 = '001' Function set, '0' 4-bit mode, '1' 2-line, '0' 5x7 dot matrix, 'xx'
                    ;  06 = '000001' Entry mode, '1' increment, '0' no display shift
                    ;  0C = '00001' Display control, '1' display on, '0' cursor off, '0' cursor blink off
                    ;  01 = '00000001' Display clear
                    ;
                    ;Registers used s0, s1, s2, s3, s4
                    ;
         LCD_reset: CALL delay_20ms                     ;wait more that 15ms for display to be ready
                    LOAD s4, 30
                    CALL LCD_write_inst4                ;send '3'
                    CALL delay_20ms                     ;wait >4.1ms
                    CALL LCD_write_inst4                ;send '3'
                    CALL delay_1ms                      ;wait >100us
                    CALL LCD_write_inst4                ;send '3'
                    CALL delay_40us                     ;wait >40us
                    LOAD s4, 20
                    CALL LCD_write_inst4                ;send '2'
                    CALL delay_40us                     ;wait >40us
                    LOAD s5, 28                         ;Function set
                    CALL LCD_write_inst8
                    LOAD s5, 06                         ;Entry mode
                    CALL LCD_write_inst8
                    LOAD s5, 0C                         ;Display control
                    CALL LCD_write_inst8
         LCD_clear: LOAD s5, 01                         ;Display clear
                    CALL LCD_write_inst8
                    CALL delay_1ms                      ;wait >1.64ms for display to clear
                    CALL delay_1ms
                    RETURN
                    ;
                    ;Position the cursor ready for characters to be written.
                    ;The display is formed of 2 lines of 16 characters and each
                    ;position has a corresponding address as indicated below.
                    ;
                    ;                   Character position
                    ;           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
                    ;
                    ; Line 1 - 80 81 82 83 84 85 86 87 88 89 8A 8B 8C 8D 8E 8F
                    ; Line 2 - C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 CA CB CC CD CE CF
                    ;
                    ;This routine will set the cursor position using the value provided
                    ;in register s5. The upper nibble will define the line and the lower
                    ;nibble the character position on the line.
                    ; Example s5 = 2B will position the cursor on line 2 position 11
                    ;
                    ;Registers used s0, s1, s2, s3, s4
                    ;
        LCD_cursor: TEST s5, 10                         ;test for line 1
                    JUMP Z, set_line2
                    AND s5, 0F                          ;make address in range 80 to 8F for line 1
                    OR s5, 80
                    CALL LCD_write_inst8                ;instruction write to set cursor
                    RETURN
         set_line2: AND s5, 0F                          ;make address in range C0 to CF for line 2
                    OR s5, C0
                    CALL LCD_write_inst8                ;instruction write to set cursor
                    RETURN
                    ;
                    ;
                    ;**************************************************************************************
                    ;Interrupt Service Routine (ISR)
                    ;**************************************************************************************
                    ;
                    ;Interrupts occur at 1 second intervals.
                    ;
                    ;Each interrupt is used to take analogue samples and store them in scratch pad memory.
                    ;The interrupt clears a 'flag' in register sF so that the main program can advance.
                    ;
               ISR: CALL adc_read                       ;read A/D Converter
                    STORE s8, ADC0_lsb                  ;store ADC Channel 0
                    STORE s9, ADC0_msb
                    STORE s6, ADC1_lsb                  ;store ADC Channel 1
                    STORE s7, ADC1_msb
                    ;
                    LOAD sF, 00                         ;clear flag
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
