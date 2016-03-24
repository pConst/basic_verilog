                      ; KCPSM3 Program - LED control with Pulse Width Modulation (PWM).
                      ;
                      ; Design provided for use with the design 'low_cost_design_authentication_for_spartan_3e.vhd'
                      ; and the Spartan-3E Starter Kit. This design provides the token 'real' application to be
                      ; protected by design authentication.
                      ;
                      ; Ken Chapman - Xilinx Ltd
                      ;
                      ; Version v1.00 - 9th November 2006
                      ;
                      ; This code automatically sequences the LEDs on the board using PWM to change intensity.
                      ; It also checks for correct design authentication and will perform a different sequence if
                      ; the design is not authorised.
                      ;
                      ;
                      ;**************************************************************************************
                      ; NOTICE:
                      ;
                      ; Copyright Xilinx, Inc. 2006.   This code may be contain portions patented by other
                      ; third parties.  By providing this core as one possible implementation of a standard,
                      ; Xilinx is making no representation that the provided implementation of this standard
                      ; is free from any claims of infringement by any third party.  Xilinx expressly
                      ; disclaims any warranty with respect to the adequacy of the implementation, including
                      ; but not limited to any warranty or representation that the implementation is free
                      ; from claims of any third party.  Furthermore, Xilinx is providing this core as a
                      ; courtesy to you and suggests that you contact all third parties to obtain the
                      ; necessary rights to use this implementation.
                      ;
                      ;
                      ;**************************************************************************************
                      ; Port definitions
                      ;**************************************************************************************
                      ;
                      ;
                      ;
                      CONSTANT LED_port, 80               ;8 simple LEDs
                      CONSTANT LED0, 01                   ;       LD0 - bit0
                      CONSTANT LED1, 02                   ;       LD1 - bit1
                      CONSTANT LED2, 04                   ;       LD2 - bit2
                      CONSTANT LED3, 08                   ;       LD3 - bit3
                      CONSTANT LED4, 10                   ;       LD4 - bit4
                      CONSTANT LED5, 20                   ;       LD5 - bit5
                      CONSTANT LED6, 40                   ;       LD6 - bit6
                      CONSTANT LED7, 80                   ;       LD7 - bit7
                      ;
                      CONSTANT LED_read_port, 00          ;read back of current LED drive values
                      ;
                      ;
                      CONSTANT security_request_port, 40  ;Port to stimulate security KCPSM3 processor
                      CONSTANT security_interrupt, 01     ; interrupt - bit0
                      ;
                      ;
                      ;A FIFO buffer links the security KCPSM3 processor to the application KCPSM3 processor.
                      ;  This application processor controls and reads the FIFO.
                      ;  The security processor writes to the FIFO.
                      ;
                      CONSTANT link_fifo_control_port, 20 ;FIFO control
                      CONSTANT link_fifo_reset, 01        ;     reset - bit0
                      ;
                      CONSTANT link_FIFO_status_port, 01  ;FIFO status input
                      CONSTANT link_FIFO_data_present, 01 ;      half full - bit0
                      CONSTANT link_FIFO_half_full, 02    ;           full - bit1
                      CONSTANT link_FIFO_full, 04         ;   data present - bit2
                      ;
                      CONSTANT link_FIFO_read_port, 02    ;read FIFO data
                      ;
                      ;
                      ;
                      ;**************************************************************************************
                      ; Special Register usage
                      ;**************************************************************************************
                      ;
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
                      CONSTANT PWM_channel2, 03
                      CONSTANT PWM_channel3, 04
                      CONSTANT PWM_channel4, 05
                      CONSTANT PWM_channel5, 06
                      CONSTANT PWM_channel6, 07
                      CONSTANT PWM_channel7, 08
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
                      COMPARE s1, PWM_channel7
                      JUMP Z, enable_int
                      ADD s1, 01
                      JUMP clear_loop
                      ;
          enable_int: ENABLE INTERRUPT                    ;interrupts used to set PWM frequency
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
                      ;
                      ; Reset authentication check counter
                      ;
                      LOAD sF, 00
                      ;
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
                      ;
                      ; Using a simple software counter (implemented by register sF) the design occasionally requests an
                      ; authorisation message from the authentication processor. If it receives a PASS message it continues
                      ; normally but if it receives a FAIL message the LED pattern is changed.
                      ;
                      ;
                      ;
          warm_start: ADD sF, 01                          ;authentication check timer
                      JUMP C, authentication_check        ;Check made approximately every 8 seconds.
                      ;
 normal_LED_sequence: LOAD s2, 03                         ;simple delay loop (delay will be increased by ISR processing)
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
                      ;
                      ;
                      ;**************************************************************************************
                      ; Authentication Check and fail procedure
                      ;**************************************************************************************
                      ;
                      ; The authentication check is performed by issuing and interrupt to the authentication
                      ; processor and then observing the simple text string that it returns via the link FIFO
                      ; buffer.
                      ;
                      ; PASS - Design is authorised to work.
                      ; FAIL - Design is not authorised and should stop working normally.
                      ;
                      ;
                      ;ASCII character values that are used in messages
                      ;
                      CONSTANT character_A, 41
                      CONSTANT character_F, 46
                      CONSTANT character_I, 49
                      CONSTANT character_L, 4C
                      CONSTANT character_P, 50
                      CONSTANT character_S, 53
                      ;
                      ;
authentication_check: LOAD s0, link_fifo_reset            ;clear link FIFO to ensure no unexpected characters
                      OUTPUT s0, link_fifo_control_port
                      LOAD s0, 00
                      OUTPUT s0, link_fifo_control_port
                      ;
                      LOAD s0, security_interrupt         ;generate interrupt to authentication processor
                      OUTPUT s0, security_request_port
                      LOAD s0, 00
                      OUTPUT s0, security_request_port
                      ;
                      CALL read_link_FIFO                 ;read each character and compare
                      COMPARE s0, character_P
                      JUMP NZ, fail_confirm
                      CALL read_link_FIFO
                      COMPARE s0, character_A
                      JUMP NZ, fail_confirm
                      CALL read_link_FIFO
                      COMPARE s0, character_S
                      JUMP NZ, fail_confirm
                      CALL read_link_FIFO
                      COMPARE s0, character_S
                      JUMP NZ, fail_confirm
                      JUMP normal_LED_sequence            ;Continue normal operation for PASS message
                      ;
                      ;
                      ; To confirm that the authentication is really a FAIL message
                      ; another request is made to the authentication processor and tested.
                      ;
        fail_confirm: LOAD s0, FF                         ;short delay to ensure authentication processor is ready
       request_delay: SUB s0, 01                          ;   to respond to new interrupt request
                      JUMP NZ, request_delay
                      ;
                      LOAD s0, link_fifo_reset            ;clear link FIFO to ensure no unexpected characters
                      OUTPUT s0, link_fifo_control_port
                      LOAD s0, 00
                      OUTPUT s0, link_fifo_control_port
                      ;
                      LOAD s0, security_interrupt         ;generate interrupt to authentication processor
                      OUTPUT s0, security_request_port
                      LOAD s0, 00
                      OUTPUT s0, security_request_port
                      ;
                      CALL read_link_FIFO                 ;read each character and compare
                      COMPARE s0, character_F
                      JUMP NZ, normal_LED_sequence
                      CALL read_link_FIFO
                      COMPARE s0, character_A
                      JUMP NZ, normal_LED_sequence
                      CALL read_link_FIFO
                      COMPARE s0, character_I
                      JUMP NZ, normal_LED_sequence
                      CALL read_link_FIFO
                      COMPARE s0, character_L
                      JUMP NZ, normal_LED_sequence
                      ;
                      ;
                      ; When the design fails to authenticate the LEDs will appear to
                      ; turn on and then slowly fade to off using PWM.
                      ;
 failed_LED_sequence: LOAD s0, FF                         ;maximum intensity on all LEDs
                      LOAD s4, 00                         ;reset fade rate control
        all_LED_fade: LOAD s1, PWM_channel0
   all_LED_fade_loop: STORE s0, (s1)
                      COMPARE s1, PWM_channel7
                      JUMP Z, decay_LEDs
                      ADD s1, 01
                      JUMP all_LED_fade_loop
          decay_LEDs: LOAD s1, s4                         ;software delay starts quickly and slows down because LEDs are non-linear.
             wait_s1: LOAD s2, 18
             wait_s2: LOAD s3, FF
             wait_s3: SUB s3, 01
                      JUMP NZ, wait_s3
                      SUB s2, 01
                      JUMP NZ, wait_s2
                      SUB s1, 01
                      JUMP NZ, wait_s1
                      COMPARE s0, 00                      ;test for fully off
                      JUMP Z, stop_completely
                      SUB s0, 01                          ;fade LEDs
                      ADD s4, 01                          ;slow fade rate as intensity decreases
                      JUMP all_LED_fade
                      ;
     stop_completely: JUMP stop_completely
                      ;
                      ;**************************************************************************************
                      ; Read Byte from Link FIFO
                      ;**************************************************************************************
                      ;
                      ; The routine first tests the FIFO buffer to see if data is present.
                      ; If the FIFO is empty, the routine waits until there is a character to read.
                      ; the read value is returned in register s0.
                      ;
                      ;
      read_link_FIFO: INPUT s0, link_FIFO_status_port     ;test FIFO buffer
                      TEST s0, link_FIFO_data_present     ;wait if empty
                      JUMP Z, read_link_FIFO
                      INPUT s0, link_FIFO_read_port       ;read data from FIFO
                      RETURN
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
                      ; locations are used to determine the desired duty factor for each of 8 channels.
                      ;
                      ; Note that an interrupt is generated every 196 clock cycles. This means that there is
                      ; only time to execute 98 instructions between each interrupt. This ISR is 35 instructions
                      ; long. A further 3 instructions are also consumed by the interrupt process
                      ; (abandoned instruction, virtual CALL to 3FF and the interrupt vector JUMP) and hence
                      ; PicoBlaze has approximately 63% of its time available for other tasks in the main program.
                      ;
                      ; Although a loop would normal be employed in software to process each of 8 channels,
                      ; the implementation of a loop would increase the number of instructions which needed to
                      ; be executed significantly reduce the time available for the main program to operate.
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
