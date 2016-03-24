                 ; KCPSM3 Program - Automatic Pulse Width Modulation (PWM) Control on the Spartan-3E Starter Kit.
                 ;
                 ; Ken Chapman - Xilinx Ltd
                 ;
                 ; Version v1.00 - 24th May 2006
                 ;
                 ; Automatically sequences the LEDs on the board using PWM to change intensity.
                 ;
                 ;**************************************************************************************
                 ; Port definitions
                 ;**************************************************************************************
                 ;
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
                 CONSTANT simple_port, 40            ;4 simple outputs
                 CONSTANT simple_IO9, 01             ;  Header  IO9  - bit0
                 CONSTANT simple_IO10, 02            ;          IO10 - bit1
                 CONSTANT simple_IO11, 04            ;          IO11 - bit2
                 CONSTANT simple_IO12, 08            ;          IO12 - bit3
                 ;
                 ;
                 ;
                 CONSTANT status_port, 00            ;UART status input
                 CONSTANT tx_half_full, 01           ;  Transmitter     half full - bit0
                 CONSTANT tx_full, 02                ;    FIFO               full - bit1
                 CONSTANT rx_data_present, 04        ;  Receiver     data present - bit2
                 CONSTANT rx_half_full, 08           ;    FIFO          half full - bit3
                 CONSTANT rx_full, 10                ;                   full - bit4
                 CONSTANT spare1, 20                 ;                  spare '0' - bit5
                 CONSTANT spare2, 40                 ;                  spare '0' - bit6
                 CONSTANT spare3, 80                 ;                  spare '0' - bit7
                 ;
                 CONSTANT UART_read_port, 01         ;UART Rx data input
                 ;
                 CONSTANT UART_write_port, 20        ;UART Tx data output
                 ;
                 ;
                 ;
                 ;**************************************************************************************
                 ; Special Register usage
                 ;**************************************************************************************
                 ;
                 NAMEREG sF, UART_data               ;used to pass data to and from the UART
                 ;
                 ;
                 ;
                 ;**************************************************************************************
                 ;Scratch Pad Memory Locations
                 ;**************************************************************************************
                 ;
                 CONSTANT PWM_duty_counter, 00       ;Duty Counter 0 to 255 within 1KHz period (1ms)
                 CONSTANT PWM_channel0, 01           ;PWM settings for each channel
                 CONSTANT PWM_channel1, 02           ; Channels 0 to 7 = LEDs 0 to 7
                 CONSTANT PWM_channel2, 03           ; Channels 8 to 11 = IO9 to IO12
                 CONSTANT PWM_channel3, 04
                 CONSTANT PWM_channel4, 05
                 CONSTANT PWM_channel5, 06
                 CONSTANT PWM_channel6, 07
                 CONSTANT PWM_channel7, 08
                 CONSTANT PWM_channel8, 09
                 CONSTANT PWM_channel9, 0A
                 CONSTANT PWM_channel10, 0B
                 CONSTANT PWM_channel11, 0C
                 CONSTANT ISR_preserve_s0, 0D        ;preserve register contents during Interrupt Service Routine
                 CONSTANT ISR_preserve_s1, 0E
                 CONSTANT ISR_preserve_s2, 0F
                 ;
                 ;
                 CONSTANT LED0_sequence, 10          ;LED sequence values
                 CONSTANT LED1_sequence, 11
                 CONSTANT LED2_sequence, 12
                 CONSTANT LED3_sequence, 13
                 CONSTANT LED4_sequence, 14
                 CONSTANT LED5_sequence, 15
                 CONSTANT LED6_sequence, 16
                 CONSTANT LED7_sequence, 17
                 ;
                 ;
                 ;
                 ;**************************************************************************************
                 ;Useful data constants
                 ;**************************************************************************************
                 ;
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
                 ;**************************************************************************************
                 ;Initialise the system
                 ;**************************************************************************************
                 ;
                 ; All PWM channels initialise to off (zero).
                 ; Simple I/O outputs will remain off at all times.
                 ;
     cold_start: LOAD s0, 00
                 LOAD s1, PWM_channel0
     clear_loop: STORE s0, (s1)
                 COMPARE s1, PWM_channel11
                 JUMP Z, enable_int
                 ADD s1, 01
                 JUMP clear_loop
                 ;
     enable_int: ENABLE INTERRUPT                    ;interrupts used to drive servo
                 ;
                 CALL send_welcome                   ;Write welcome message to UART
                 CALL send_OK
                 ;
                 ;
                 ; Initialise LED pattern sequence
                 ;
                 LOAD s0, 01                         ;trigger to start wave pattern
                 STORE s0, LED0_sequence
                 LOAD s0, 00
                 STORE s0, LED1_sequence
                 STORE s0, LED2_sequence
                 STORE s0, LED3_sequence
                 STORE s0, LED4_sequence
                 STORE s0, LED5_sequence
                 STORE s0, LED6_sequence
                 STORE s0, LED7_sequence
                 ;
                 ;**************************************************************************************
                 ; Main program
                 ;**************************************************************************************
                 ;
                 ; Provides a pattern of interest on the LEDs :-)
                 ;
                 ; Each LED increases intensity in 8 steps and then decreases intensity in 8 steps until it is off.
                 ; The middle LEDs (LD2 to LD5) each start to turn on when either neighbour is turned half on and increasing
                 ; to provide the effect of a passing a 'wave' of light passing from side to side. The pair of LEDs at each
                 ; (LD0, Ld1 and LD6, LD7) are required to reflect the 'wave' so that the pattern continues.
                 ;
                 ; I'm sure this code cold be written in more elegant way, but I leave that as an exercise to you :-)
                 ;
     warm_start: LOAD s2, 03                         ;simple delay loop (time will be increased by ISR processing)
  delay_s2_loop: LOAD s1, FF
  delay_s1_loop: LOAD s0, FF
  delay_s0_loop: SUB s0, 01
                 JUMP NC, delay_s0_loop
                 SUB s1, 01
                 JUMP NC, delay_s1_loop
                 SUB s2, 01
                 JUMP NC, delay_s2_loop
                 ;
                 ;Pattern generation
                 ;
                 FETCH s0, LED0_sequence             ;read sequence for LED0
                 COMPARE s0, 00
                 JUMP Z, test_LED0_start
                 SUB s0, 20                          ;Count longer to ensure end stops then reset count if maximum
                 JUMP Z, update_LED0
                 ADD s0, 20
       inc_LED0: ADD s0, 01                          ;increment counter
                 JUMP update_LED0
test_LED0_start: FETCH s1, LED1_sequence             ;start LED0 if LED1 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED0
    update_LED0: STORE s0, LED0_sequence
                 CALL LED_to_duty
                 STORE s1, PWM_channel0
                 ;
                 FETCH s1, LED0_sequence             ; refresh LED1 if LED0 = 11 (0B hex) to reflect wave
                 COMPARE s1, 0B
                 JUMP NZ, normal_LED1
                 LOAD s0, 04
                 JUMP update_LED1
    normal_LED1: FETCH s0, LED1_sequence             ;read sequence for LED1
                 COMPARE s0, 00
                 JUMP Z, test_LED1_start
                 SUB s0, 10                          ;reset count if maximum
                 JUMP Z, update_LED1
                 ADD s0, 10
       inc_LED1: ADD s0, 01                          ;increment counter
                 JUMP update_LED1
test_LED1_start: FETCH s1, LED0_sequence             ;start LED1 if LED0 = 11 (0B hex) to reflect wave
                 COMPARE s1, 0B
                 JUMP Z, inc_LED1
                 FETCH s1, LED2_sequence             ;start LED1 if LED2 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED1
    update_LED1: STORE s0, LED1_sequence
                 CALL LED_to_duty
                 STORE s1, PWM_channel1
                 ;
                 FETCH s0, LED2_sequence             ;read sequence for LED2
                 COMPARE s0, 00
                 JUMP Z, test_LED2_start
                 SUB s0, 10                          ;reset count if maximum
                 JUMP Z, update_LED2
                 ADD s0, 10
       inc_LED2: ADD s0, 01                          ;increment counter
                 JUMP update_LED2
test_LED2_start: FETCH s1, LED1_sequence             ;start LED2 if LED1 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED2
                 FETCH s1, LED3_sequence             ;start LED2 if LED3 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED2
    update_LED2: STORE s0, LED2_sequence
                 CALL LED_to_duty
                 STORE s1, PWM_channel2
                 ;
                 ;
                 FETCH s0, LED3_sequence             ;read sequence for LED3
                 COMPARE s0, 00
                 JUMP Z, test_LED3_start
                 SUB s0, 10                          ;reset count if maximum
                 JUMP Z, update_LED3
                 ADD s0, 10
       inc_LED3: ADD s0, 01                          ;increment counter
                 JUMP update_LED3
test_LED3_start: FETCH s1, LED2_sequence             ;start LED3 if LED2 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED3
                 FETCH s1, LED4_sequence             ;start LED3 if LED4 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED3
    update_LED3: STORE s0, LED3_sequence
                 CALL LED_to_duty
                 STORE s1, PWM_channel3
                 ;
                 FETCH s0, LED4_sequence             ;read sequence for LED4
                 COMPARE s0, 00
                 JUMP Z, test_LED4_start
                 SUB s0, 10                          ;reset count if maximum
                 JUMP Z, update_LED4
                 ADD s0, 10
       inc_LED4: ADD s0, 01                          ;increment counter
                 JUMP update_LED4
test_LED4_start: FETCH s1, LED3_sequence             ;start LED4 if LED3 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED4
                 FETCH s1, LED5_sequence             ;start LED4 if LED5 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED4
    update_LED4: STORE s0, LED4_sequence
                 CALL LED_to_duty
                 STORE s1, PWM_channel4
                 ;
                 FETCH s0, LED5_sequence             ;read sequence for LED5
                 COMPARE s0, 00
                 JUMP Z, test_LED5_start
                 SUB s0, 10                          ;reset count if maximum
                 JUMP Z, update_LED5
                 ADD s0, 10
       inc_LED5: ADD s0, 01                          ;increment counter
                 JUMP update_LED5
test_LED5_start: FETCH s1, LED4_sequence             ;start LED5 if LED4 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED5
                 FETCH s1, LED6_sequence             ;start LED5 if LED6 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED5
    update_LED5: STORE s0, LED5_sequence
                 CALL LED_to_duty
                 STORE s1, PWM_channel5
                 ;
                 FETCH s1, LED7_sequence             ; refresh LED6 if LED7 = 11 (0B hex) to reflect wave
                 COMPARE s1, 0B
                 JUMP NZ, normal_LED6
                 LOAD s0, 04
                 JUMP update_LED6
    normal_LED6: FETCH s0, LED6_sequence             ;read sequence for LED6
                 COMPARE s0, 00
                 JUMP Z, test_LED6_start
                 SUB s0, 10                          ;reset count if maximum
                 JUMP Z, update_LED6
                 ADD s0, 10
       inc_LED6: ADD s0, 01                          ;increment counter
                 JUMP update_LED6
test_LED6_start: FETCH s1, LED5_sequence             ;start LED6 if LED5 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED6
    update_LED6: STORE s0, LED6_sequence
                 CALL LED_to_duty
                 STORE s1, PWM_channel6
                 ;
                 FETCH s0, LED7_sequence             ;read sequence for LED7
                 COMPARE s0, 00
                 JUMP Z, test_LED7_start
                 SUB s0, 20                          ;Count longer to ensure end stops then reset count if maximum
                 JUMP Z, update_LED7
                 ADD s0, 20
       inc_LED7: ADD s0, 01                          ;increment counter
                 JUMP update_LED7
test_LED7_start: FETCH s1, LED6_sequence             ;start LED7 if LED6 = 4
                 COMPARE s1, 04
                 JUMP Z, inc_LED7
    update_LED7: STORE s0, LED7_sequence
                 CALL LED_to_duty
                 STORE s1, PWM_channel7
                 JUMP warm_start
                 ;
                 ;
                 ; Convert LED sequence number into PWM intensity figure
                 ;
                 ; LEDs duty cycle values are 0,1,2,4,8,16,32 and 64 because they appear to give what
                 ; appears to be a fairly liner change in intensity and provides a simple way to set
                 ; the duty value.
                 ;
                 ; Provide sequence value in register s0 and intensity will be
                 ; returned in register s1.
                 ;
                 ; s0   s1
                 ; 00   00
                 ; 01   01
                 ; 02   02
                 ; 03   04
                 ; 04   08
                 ; 05   10
                 ; 06   20
                 ; 07   40
                 ; 08   80
                 ; 09   40
                 ; 0A   20
                 ; 0B   10
                 ; 0C   08
                 ; 0D   04
                 ; 0E   02
                 ; 0F   01
                 ; 10   00  and zero for all larger values of s0
                 ;
    LED_to_duty: LOAD s1, 00
                 COMPARE s0, 00                      ;test for zero
                 RETURN Z
                 LOAD s1, 01                         ;inject '1'
     go_up_loop: SUB s0, 01
                 RETURN Z
                 SL0 s1                              ;multiply by 2
                 JUMP C, go_down
                 JUMP go_up_loop
        go_down: LOAD s1, 40
   go_down_loop: SUB s0, 01
                 RETURN Z
                 SR0 s1                              ;divide by 2
                 JUMP go_down_loop
                 ;
                 ;**************************************************************************************
                 ; UART communication routines
                 ;**************************************************************************************
                 ;
                 ; Read one character from the UART
                 ;
                 ; Character read will be returned in a register called 'UART_data'.
                 ;
                 ; The routine first tests the receiver FIFO buffer to see if data is present.
                 ; If the FIFO is empty, the routine waits until there is a character to read.
                 ; As this could take any amount of time the wait loop could include a call to a
                 ; subroutine which performs a useful function.
                 ;
                 ;
                 ; Registers used s0 and UART_data
                 ;
 read_from_UART: INPUT s0, status_port               ;test Rx_FIFO buffer
                 TEST s0, rx_data_present            ;wait if empty
                 JUMP NZ, read_character
                 JUMP read_from_UART
 read_character: INPUT UART_data, UART_read_port     ;read from FIFO
                 RETURN
                 ;
                 ;
                 ;
                 ; Transmit one character to the UART
                 ;
                 ; Character supplied in register called 'UART_data'.
                 ;
                 ; The routine first tests the transmit FIFO buffer to see if it is full.
                 ; If the FIFO is full, then the routine waits until it there is space.
                 ;
                 ; Registers used s0
                 ;
   send_to_UART: INPUT s0, status_port               ;test Tx_FIFO buffer
                 TEST s0, tx_full                    ;wait if full
                 JUMP Z, UART_write
                 JUMP send_to_UART
     UART_write: OUTPUT UART_data, UART_write_port
                 RETURN
                 ;
                 ;
                 ;
                 ;**************************************************************************************
                 ; Text messages
                 ;**************************************************************************************
                 ;
                 ;
                 ; Send Carriage Return to the UART
                 ;
        send_CR: LOAD UART_data, character_CR
                 CALL send_to_UART
                 RETURN
                 ;
                 ; Send a space to the UART
                 ;
     send_space: LOAD UART_data, character_space
                 CALL send_to_UART
                 RETURN
                 ;
                 ;
                 ;
                 ; Send 'PicoBlaze Servo Control' string to the UART
                 ;
   send_welcome: CALL send_CR
                 CALL send_CR
                 LOAD UART_data, character_P
                 CALL send_to_UART
                 LOAD UART_data, character_i
                 CALL send_to_UART
                 LOAD UART_data, character_c
                 CALL send_to_UART
                 LOAD UART_data, character_o
                 CALL send_to_UART
                 LOAD UART_data, character_B
                 CALL send_to_UART
                 LOAD UART_data, character_l
                 CALL send_to_UART
                 LOAD UART_data, character_a
                 CALL send_to_UART
                 LOAD UART_data, character_z
                 CALL send_to_UART
                 LOAD UART_data, character_e
                 CALL send_to_UART
                 CALL send_space
                 LOAD UART_data, character_A
                 CALL send_to_UART
                 LOAD UART_data, character_u
                 CALL send_to_UART
                 LOAD UART_data, character_t
                 CALL send_to_UART
                 LOAD UART_data, character_o
                 CALL send_to_UART
                 CALL send_space
                 LOAD UART_data, character_P
                 CALL send_to_UART
                 LOAD UART_data, character_W
                 CALL send_to_UART
                 LOAD UART_data, character_M
                 CALL send_to_UART
                 CALL send_space
                 LOAD UART_data, character_A
                 CALL send_to_UART
                 LOAD UART_data, character_c
                 CALL send_to_UART
                 LOAD UART_data, character_t
                 CALL send_to_UART
                 LOAD UART_data, character_i
                 CALL send_to_UART
                 LOAD UART_data, character_v
                 CALL send_to_UART
                 LOAD UART_data, character_e
                 CALL send_to_UART
                 CALL send_CR
                 CALL send_CR
                 RETURN
                 ;
                 ;
                 ;Send 'OK' to the UART
                 ;
        send_OK: CALL send_CR
                 LOAD UART_data, character_O
                 CALL send_to_UART
                 LOAD UART_data, character_K
                 CALL send_to_UART
                 JUMP send_CR
                 ;
                 ;
                 ;**************************************************************************************
                 ; Interrupt Service Routine (ISR)
                 ;**************************************************************************************
                 ;
                 ; Interrupts occur at 3.92us intervals and are used to generate the PWM pulses generated
                 ; at a PRF of 1KHz. The 3.92us interrupt rate corresponds with a resolution of 256 steps
                 ; over the 1ms associated with the 1KHz PRF.
                 ;
                 ; The ISR is self contained and all registers used are preserved. Scratch pad memory
                 ; locations are used to determine the desired duty factor for each of 12 channels.
                 ;
                 ; Note that an interrupt is generated every 196 clock cycles. This means that there is
                 ; only time to execute 98 instructions between each interrupt. This ISR is 48 instructions
                 ; long. A further 3 instructions are also consumed by the interrupt process
                 ; (abandoned instruction, virtual CALL to 3FF and the interrupt vector JUMP) and hence
                 ; PicoBlaze has approximately half of its time available for other tasks in the main program.
                 ;
                 ; Although a loop would normal be employed in software to process each of 12 channels,
                 ; the implementation of a loop would increase the number of instructions which needed to
                 ; be executed to such an extent that this 12 channel implementation would not be possible.
                 ; Consequently the code is written out in a linear fashion which consumes more program
                 ; space but which executes faster.
                 ;
            ISR: STORE s0, ISR_preserve_s0           ;preserve registers to be used
                 STORE s1, ISR_preserve_s1
                 STORE s2, ISR_preserve_s2
                 ;Determine the number of steps currently through the 1ms PWM cycle
                 FETCH s1, PWM_duty_counter          ;read 8-bit counter of steps
                 ADD s1, 01                          ;increment counter (will roll over to zero)
                 STORE s1, PWM_duty_counter          ;update count value in memory for next interrupt.
                 ;Read duty factor for each channel and compare it with the duty counter and set or
                 ;reset a bit in register s2 accordingly.
                 FETCH s0, PWM_channel11             ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel10             ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel9              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel8              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 OUTPUT s2, simple_port              ;drive pins on connector J4
                 FETCH s0, PWM_channel7              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel6              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel5              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel4              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel3              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel2              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel1              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 FETCH s0, PWM_channel0              ;read desired setting of pulse width
                 COMPARE s1, s0                      ;set carry flag if duty factor > duty counter
                 SLA s2                              ;shift carry into register s2
                 OUTPUT s2, LED_port                 ;drive LEDs
                 FETCH s0, ISR_preserve_s0           ;restore register values
                 FETCH s1, ISR_preserve_s1
                 FETCH s2, ISR_preserve_s2
                 RETURNI ENABLE
                 ;
                 ;
                 ;**************************************************************************************
                 ; Interrupt Vector
                 ;**************************************************************************************
                 ;
                 ADDRESS 3FF
                 JUMP ISR
                 ;
                 ;
