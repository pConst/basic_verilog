                           ; KCPSM3 Program - Implementation of the SHA-1 algorithm for use with the
                           ;                  DS2432 secure memory on the Spartan-3E Starter Kit.
                           ;
                           ; Ken Chapman - Xilinx Ltd
                           ;
                           ; Version v1.00 - 19th April 2006
                           ;
                           ;
                           ; IMPORTANT - This design builds on the reference design called "PicoBlaze
                           ;             DS2432 communicator". It is highly recommend that you look at that
                           ;             design before proceeding with this one.
                           ;
                           ;
                           ; This program uses a 9600 baud UART connection to allow communication with the
                           ; 1-wire interface of the DS2432 memory device from Dallas Semiconductor.
                           ;
                           ; The program only supports a limited number of the DS2432 commands to focus on
                           ; those aspects which use the SHA-1 algorithm.
                           ;
                           ; Note that the code performing the SHA-1 algorithm interacts with the hardware of
                           ; this complete reference design. The hardware provides a 16 word (32-bit) buffer
                           ; combined used in the initialisation of the algorithm and subsequent computation
                           ; of the Wt words.
                           ;
                           ;
                           ; The DS2432 should be programmed with a 64-bit secret. The following constants
                           ; define the secret which will be used. Obviously this would be be changed in a
                           ; real application and further measures taken to prevent it easily being found.
                           ; The secret is 64-bits formed of 8 bytes. 'secret0' would be stored at address
                           ; 0080 of the DS2432 and 'secret7' at address 0087. The write buffer and load
                           ; first secret commands allow you to set any secret into the DS2432 device but
                           ; this program always uses the secret defined in these constants such that you can
                           ; experiment with secrets which do and do not match.
                           ;
                           ;
                           CONSTANT secret0, 01
                           CONSTANT secret1, 23
                           CONSTANT secret2, 45
                           CONSTANT secret3, 67
                           CONSTANT secret4, 89
                           CONSTANT secret5, AB
                           CONSTANT secret6, CD
                           CONSTANT secret7, EF
                           ;
                           ;
                           ; Bytes 4, 5 and 6 of the DS2432 scratch pad memory are used in the SHA-1 algorithm.
                           ; These should be set using the write scratchpad memory command before using the
                           ; read authenticated page command. HOWEVER, it is also important that you also use
                           ; the read scratchpad command BEFORE using the read authenticated page command. This
                           ; is because this program only copies the bytes 4, 5 and 6 during a read such that
                           ; they are can be used by the PicoBlaze SHA-1 algorithm. This limitation is deliberate
                           ; so that you can experiment and prove that the SHA-1 results will not match if
                           ; the same 'challenge' bytes are not used.
                           ;
                           ;
                           ;**************************************************************************************
                           ; Port definitions
                           ;**************************************************************************************
                           ;
                           ;
                           CONSTANT status_port, 40                ;UART status input
                           CONSTANT tx_half_full, 01               ;  Transmitter     half full - bit0
                           CONSTANT tx_full, 02                    ;    FIFO               full - bit1
                           CONSTANT rx_data_present, 04            ;  Receiver     data present - bit2
                           CONSTANT rx_half_full, 08               ;    FIFO          half full - bit3
                           CONSTANT rx_full, 10                    ;                   full - bit4
                           CONSTANT spare1, 20                     ;                  spare '0' - bit5
                           CONSTANT spare2, 40                     ;                  spare '0' - bit6
                           CONSTANT spare3, 80                     ;                  spare '0' - bit7
                           ;
                           CONSTANT UART_read_port, 80             ;UART Rx data input
                           ;
                           CONSTANT UART_write_port, 04            ;UART Tx data output
                           ;
                           ;
                           CONSTANT DS_wire_in_port, C0            ;Read signal from DS2432 device
                           CONSTANT DS_wire_out_port, 08           ;Drive signal to DS2432 device (open collector)
                           CONSTANT DS_wire, 01                    ;       Signal is bit0 in both cases
                           ;
                           ;
                           ;
                           ; The following ports access the 'Wt' word buffer. This buffer holds 16 words
                           ; of 32-bits organised as a 64-byte shift register. Hence each word is stored
                           ; by writing 4 bytes. As each byte is written, all bytes shift along such that
                           ; older Wt values can be read from consistent port addresses.
                           ;
                           CONSTANT W_word_write_port, 10          ;Write byte to Wt buffer
                           ;
                           CONSTANT Wt_minus3_byte0_read_port, 08  ;Read of Wt-3
                           CONSTANT Wt_minus3_byte1_read_port, 09
                           CONSTANT Wt_minus3_byte2_read_port, 0A
                           CONSTANT Wt_minus3_byte3_read_port, 0B
                           ;
                           CONSTANT Wt_minus8_byte0_read_port, 1C  ;Read of Wt-8
                           CONSTANT Wt_minus8_byte1_read_port, 1D
                           CONSTANT Wt_minus8_byte2_read_port, 1E
                           CONSTANT Wt_minus8_byte3_read_port, 1F
                           ;
                           CONSTANT Wt_minus14_byte0_read_port, 34 ;Read of Wt-14
                           CONSTANT Wt_minus14_byte1_read_port, 35
                           CONSTANT Wt_minus14_byte2_read_port, 36
                           CONSTANT Wt_minus14_byte3_read_port, 37
                           ;
                           CONSTANT Wt_minus16_byte0_read_port, 3C ;Read of Wt-16
                           CONSTANT Wt_minus16_byte1_read_port, 3D
                           CONSTANT Wt_minus16_byte2_read_port, 3E
                           CONSTANT Wt_minus16_byte3_read_port, 3F
                           ;
                           ;
                           ;**************************************************************************************
                           ; Special Register usage
                           ;**************************************************************************************
                           ;
                           NAMEREG sF, UART_data                   ;used to pass data to and from the UART
                           ;
                           ;
                           ;**************************************************************************************
                           ; Scratch Pad Memory Locations
                           ;**************************************************************************************
                           ;
                           ; Scratch pad memory provides 64 bytes in the address range 00 to 3F hex.
                           ;
                           ;
                           ; Locations for device family code, serial number and 8-bit CRC value
                           ;
                           CONSTANT family_code, 00
                           CONSTANT serial_number0, 01             ;48-bit serial number LS-Byte first
                           CONSTANT serial_number1, 02
                           CONSTANT serial_number2, 03
                           CONSTANT serial_number3, 04
                           CONSTANT serial_number4, 05
                           CONSTANT serial_number5, 06
                           CONSTANT read_ROM_CRC, 07               ;8-bit CRC
                           ;
                           ;
                           ; Locations for variables used in SHA-1 algorithm.
                           ; Each variable is 32-bits and requires 4 bytes to store.
                           ; '0' indicates the least significant byte and '3' the most significant byte.
                           ;
                           ; Note that the concatenation of 'A', 'B', 'C', 'D' and 'E' will be the 160-bit MAC.
                           ;
                           CONSTANT var_A0, 08                     ;Variable 'A'
                           CONSTANT var_A1, 09
                           CONSTANT var_A2, 0A
                           CONSTANT var_A3, 0B
                           ;
                           CONSTANT var_B0, 0C                     ;Variable 'B'
                           CONSTANT var_B1, 0D
                           CONSTANT var_B2, 0E
                           CONSTANT var_B3, 0F
                           ;
                           CONSTANT var_C0, 10                     ;Variable 'C'
                           CONSTANT var_C1, 11
                           CONSTANT var_C2, 12
                           CONSTANT var_C3, 13
                           ;
                           CONSTANT var_D0, 14                     ;Variable 'D'
                           CONSTANT var_D1, 15
                           CONSTANT var_D2, 16
                           CONSTANT var_D3, 17
                           ;
                           CONSTANT var_E0, 18                     ;Variable 'E'
                           CONSTANT var_E1, 19
                           CONSTANT var_E2, 1A
                           CONSTANT var_E3, 1B
                           ;
                           ;
                           ; Copy of data in the scratchpad memory of the DS2432.
                           ; This is only updated by the read scratchpad memory command.
                           ; '0' indicates the data in the least significant location.
                           ;
                           CONSTANT scratchpad0, 1C
                           CONSTANT scratchpad1, 1D
                           CONSTANT scratchpad2, 1E
                           CONSTANT scratchpad3, 1F
                           CONSTANT scratchpad4, 20
                           CONSTANT scratchpad5, 21
                           CONSTANT scratchpad6, 22
                           CONSTANT scratchpad7, 23
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; Useful data constants
                           ;**************************************************************************************
                           ;
                           ; Constant to define a software delay of 1us. This must be adjusted to reflect the
                           ; clock applied to KCPSM3. Every instruction executes in 2 clock cycles making the
                           ; calculation highly predictable. The '6' in the following equation even allows for
                           ; 'CALL delay_1us' instruction in the initiating code.
                           ;
                           ; delay_1us_constant =  (clock_rate - 6)/4       Where 'clock_rate' is in MHz
                           ;
                           ; Example: For a 50MHz clock the constant value is (10-6)/4 = 11  (0B Hex).
                           ; For clock rates below 10MHz the value of 1 must be used and the operation will
                           ; become lower than intended.
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
                           CONSTANT character_fullstop, 2E
                           CONSTANT character_semi_colon, 3B
                           CONSTANT character_minus, 2D
                           CONSTANT character_plus, 2B
                           CONSTANT character_comma, 2C
                           CONSTANT character_less_than, 3C        ;'<'
                           CONSTANT character_greater_than, 3E     ;'>'
                           CONSTANT character_open, 28             ;'('
                           CONSTANT character_close, 29            ;')'
                           CONSTANT character_divide, 2F           ;'/'
                           CONSTANT character_equals, 3D
                           CONSTANT character_space, 20
                           CONSTANT character_CR, 0D               ;carriage return
                           CONSTANT character_LF, 0A               ;line feed
                           CONSTANT character_question, 3F         ;'?'
                           CONSTANT character_dollar, 24
                           CONSTANT character_exclaim, 21          ;'!'
                           CONSTANT character_BS, 08               ;Back Space command character
                           CONSTANT character_XON, 11              ;Flow control ON
                           CONSTANT character_XOFF, 13             ;Flow control OFF
                           ;
                           ;
                           ;**************************************************************************************
                           ; Initialise the system and welcome message
                           ;**************************************************************************************
                           ;
               cold_start: CALL DS_wire_init                       ;Ensure DS_wire is not driven (pulled High)
                           CALL delay_1s                           ;Allow everything to settle!
            welcome_start: CALL send_welcome                       ;start up message and version number
                           ;
                           ;
                           ;**************************************************************************************
                           ; Reset Main menu and command selection
                           ;**************************************************************************************
                           ;
                           ; The main program allows you to use four of the DS2432 memory and SHA function
                           ; commands. A simple menu is displayed and you are guided to enter more information
                           ; when required. All the communication and protocol required to get the DS2432 ready
                           ; to receive memory and SHA function commands has been automated although information
                           ; is displayed to indicate the procedures being executed.
                           ;
                           ; Before any memory and function commands are available a master reset and read ROM
                           ; command must be issued.
                           ;
               warm_start: CALL send_CR
                           CALL send_CR
                           CALL DS_init_regular_mode               ;master reset
                           JUMP C, warm_start                      ;repeat reset if no presence pulse detected
                           CALL read_ROM_command                   ;read ROM command and display results
                           ;
                           ; After a valid ROM command the DS2432 specific memory commands and SHA-1
                           ; functions become accessible. This program assumes that the ROM command did
                           ; 'Pass' so you will need to check yourself. If this program automatically
                           ; reset the DS2432 and tried again and there was a fault it would just cause
                           ; the display to roll continuously and not be very informative!
                           ;
                           ; Each of the DS2432 commands selected from the menu will require the master reset
                           ; and read ROM command to be repeated before being able to proceed with the next
                           ; memory or SHA-1 function. This is automated by the program.
                           ;
                           ;
              DS2432_menu: CALL send_DS2432_menu                   ;Menu and command selection
                           CALL send_CR
                           ;
            DS2432_prompt: CALL send_CR                            ;prompt for user input
                           CALL send_CR
                           LOAD UART_data, character_greater_than  ;prompt for input
                           CALL send_to_UART
                           CALL read_upper_case
                           COMPARE s0, character_1                 ;test for commands and execute as required
                           JUMP Z, write_scratchpad_command
                           COMPARE s0, character_2
                           JUMP Z, read_scratchpad_command
                           COMPARE s0, character_3
                           JUMP Z, load_first_secret_command
                           COMPARE s0, character_4
                           JUMP Z, read_auth_page_command
                           CALL send_CR                            ;no valid command input
                           LOAD UART_data, character_question      ;display ???
                           CALL send_to_UART
                           CALL send_to_UART
                           CALL send_to_UART
                           JUMP DS2432_prompt                      ;Try again!
                           ;
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; DS2432 Read ROM Command.
                           ;**************************************************************************************
                           ;
                           ; The read ROM command (33 hex) allows the 8-bit family code, 48-bit unique serial
                           ; number and 8-bit CRC to be read from the DS2432 device.
                           ;
                           ; This routine reads the values and places them in KCPSM3 scratch pad memory
                           ; locations for future reference. These locations should be defined with constants
                           ; as follows and MUST be in consecutive ascending locations.
                           ;
                           ;  family_code
                           ;     Location to store family code which should be 33 hex
                           ;  serial_number0 to serial_number5
                           ;     6 bytes to hold 48-bit serial number (LS-byte first).
                           ;  read_ROM_CRC
                           ;     8-bit CRC value for the above data.
                           ;
                           ;
                           ; The routine also displays the values read and performs a verification of the
                           ; 8-bit CRC displaying a 'Pass' or 'Fail' message as appropriate.
                           ;
         read_ROM_command: LOAD s3, 33                             ;Read ROM Command
                           CALL write_byte_slow                    ;transmit command
                           LOAD s5, family_code                    ;memory pointer
            read_ROM_loop: CALL read_byte_slow                     ;read response into s3
                           STORE s3, (s5)                          ;store value
                           COMPARE s5, read_ROM_CRC                ;8-bytes to read
                           JUMP Z, display_ROM
                           ADD s5, 01
                           JUMP read_ROM_loop
              display_ROM: CALL send_CR
                           CALL send_code                          ;'code=' to display family code
                           FETCH s0, family_code
                           CALL send_hex_byte
                           CALL send_CR
                           CALL send_sn                            ;'s/n=' to display family code
                           LOAD s5, serial_number5                 ;memory pointer starting MS-byte first
         disp_serial_loop: FETCH s0, (s5)
                           CALL send_hex_byte
                           COMPARE s5, serial_number0
                           JUMP Z, end_serial
                           SUB s5, 01
                           JUMP disp_serial_loop
               end_serial: CALL send_CR
                           CALL send_crc                           ;'CRC=' to display CRC value
                           FETCH s0, read_ROM_CRC
                           CALL send_hex_byte
                           CALL send_CR
                           CALL compute_CRC8                       ;compute CRC value in s0
                           FETCH s1, read_ROM_CRC                  ;compare with received value
                           COMPARE s0, s1
                           JUMP NZ, crc8_fail
                           CALL send_Pass
                           RETURN
                crc8_fail: CALL send_Fail
                           RETURN
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; DS2432 Load First Secret Command.
                           ;**************************************************************************************
                           ;
                           ; This command will only be valid if the write scratchpad memory command has previously
                           ; been used to define the new secret to be stored at address 0080.
                           ;
                           ; The Load First Secret Command (5A hex) will only copy the scratchpad contents into                           ;
                           ; the EEPROM array of the DS2432 if the address was correctly specified in the
                           ; write scratchpad command. This routine will assume that the address specified
                           ; was 0080. If everything is OK with the programming of the secret, the DS2432 responds
                           ; with 'AA' hex after the command and this routine will report 'Pass'. You can further
                           ; check using a read scratchpad command and look to see if E/S has changed from '5F'
                           ; to 'DF' which indicates the successful write.
                           ;
                           ; Note that this program defines the secret to be used by the PicoBlaze SHA-1 algorithm
                           ; in the constants 'secret0' through to 'secret7'. Only if you program the DS2432
                           ; with a matching secret will the read authenticated message command result in a
                           ; 'Pass' being reported for the MAC. This Load First Secret Command routine deliberately
                           ; does not update the secret used by the PicoBlaze SHA-1 algorithm so that you can
                           ; prove that only a DS2432 with the matching secret will generate matching MAC
                           ; responses.
                           ;
                           ;
                           ;
load_first_secret_command: LOAD s3, 5A                             ;Load First Secret Command
                           CALL write_byte_slow                    ;transmit command
                           LOAD s3, 80                             ;TA1 value for secret = 80 hex
                           CALL write_byte_slow
                           LOAD s3, 00                             ;TA2 value for secret = 00 hex
                           CALL write_byte_slow
                           LOAD s3, 5F                             ;E/S value before writing = 5F hex
                           CALL write_byte_slow
                           CALL delay_20ms                         ;write takes place in 10ms
                           CALL send_CR
                           CALL send_secret
                           CALL send_space
                           CALL read_byte_slow                     ;read data into s3
                           COMPARE s3, AA                          ;test response
                           JUMP Z, secret_pass
                           CALL send_Fail
                           JUMP warm_start
              secret_pass: CALL send_Pass
                           JUMP warm_start
                           ;
                           ;
                           ;**************************************************************************************
                           ; DS2432 Write Scratchpad Memory Command.
                           ;**************************************************************************************
                           ;
                           ; The write scratchpad memory command (0F hex) allows 8-bytes of data to be written
                           ; together with a target address for final storage in the main memory map. The
                           ; DS2432 scratch pad is also used to define a 3 byte 'challenge' used in the
                           ; SHA-1 algorithm.
                           ;
                           ; The DS2432 provides an initial confirmation of the write by returning a 16-bit CRC
                           ; value which KCPSM3 tests. The CRC is computed based on the command, address and
                           ; data transmitted (11 bytes). PicoBlaze also computes the CRC and and tests this
                           ; against the value received from the DS2432.
                           ;
                           ; This routine prompts the user to enter the 16-bit target address is to be loaded
                           ; into the target address registers TA2 and TA1 in the DS2432 device. Note that only
                           ; address values below 0090 hex are valid. If the address is too high, then the
                           ; DS2432 aborts the command and this routine will too.
                           ;
                           ; Also note that the address will be forced internally to the DS2432 to match an
                           ; 8-byte boundary address in which the least significant 3-bits are reset to '000'
                           ; regardless of the address provided. The CRC still reflects the transmitted address.
                           ;
                           ; After providing a valid address, the routine then prompts the user to enter
                           ; 8 bytes of data which are written to the DS2432.
                           ;
                           ;
                           ;
 write_scratchpad_command: CALL clear_CRC16                        ;prepare CRC registers [sE,sD]
                           LOAD s3, 0F                             ;write scratchpad memory Command
                           CALL write_byte_slow                    ;transmit command
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
            wsc_addr_loop: CALL send_address                       ;obtain 16-bit address 0000 to FFFF in [s5,s4]
                           CALL obtain_8bits
                           JUMP C, wsc_addr_loop                   ;bad input address
                           LOAD s5, s0
                           CALL obtain_8bits
                           JUMP C, wsc_addr_loop                   ;bad input address
                           LOAD s4, s0
                           LOAD s3, s4                             ;transmit target address TA1 (LS-Byte)
                           CALL write_byte_slow
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           LOAD s3, s5                             ;transmit target address TA2 (MS-Byte)
                           CALL write_byte_slow
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           COMPARE s5, 00                          ;check address less than 0090 hex
                           JUMP NZ, warm_start                     ;DS2432 aborts command and so do we!
                           COMPARE s4, 90                          ;no need to read data bytes.
                           JUMP NC, warm_start
                           LOAD s4, 00                             ;initialise byte counter
            wsc_data_loop: CALL send_data                          ;obtain a byte of data
                           LOAD UART_data, s4                      ;display which byte requested
                           ADD UART_data, character_0              ;convert to ASCII
                           CALL send_to_UART
                           CALL send_equals
                           CALL obtain_8bits
                           JUMP C, wsc_data_loop                   ;bad input data
                           LOAD s3, s0                             ;transmit byte
                           CALL write_byte_slow
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           ADD s4, 01                              ;count bytes
                           COMPARE s4, 08
                           JUMP NZ, wsc_data_loop
                           CALL send_CR
                           CALL read_send_test_CRC16               ;read, display and test CRC value
                           JUMP warm_start
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; DS2432 Read Scratchpad Memory Command.
                           ;**************************************************************************************
                           ;
                           ; The read scratchpad memory command (AA hex) allows the 8-bytes of data previously
                           ; to be written into the scratchpad memory to be read back for verification together with
                           ; the target address, a transfer status register (E/S) and a 16-bit CRC value.
                           ;
                           ; The 16-bit CRC is formed of the command byte, address TA1 and TA2, E/S byte and 8 data
                           ; bytes as transmitted (12 bytes). These may not be the same as the values provided
                           ; during a previous write to scratchpad memory. PicoBlaze also computes the CRC and
                           ; and tests this against the value received from the DS2432.
                           ;
                           ; The 8 bytes of data are also copied to PicoBlaze memory at locations defined by the
                           ; constants 'scratchpad0' to 'scratchpad7'. Three bytes are used as a 'challenge'
                           ; by the SHA-1 algorithm.
                           ;
                           ;
                           ;
  read_scratchpad_command: CALL clear_CRC16                        ;prepare CRC registers [sE,sD]
                           LOAD s3, AA                             ;read scratchpad memory Command
                           CALL write_byte_slow                    ;transmit command
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           CALL send_address                       ;display 'Address='
                           CALL read_byte_slow                     ;read address into [s5,s4]
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           LOAD s4, s3
                           CALL read_byte_slow
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           LOAD s5, s3
                           LOAD s0, s5                             ;display address
                           CALL send_hex_byte
                           LOAD s0, s4
                           CALL send_hex_byte
                           CALL send_ES                            ;display 'E/S='
                           CALL read_byte_slow                     ;read E/S register
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           LOAD s0, s3                             ;display value
                           CALL send_hex_byte
                           CALL send_data                          ;display 'Data='
                           CALL send_equals
                           LOAD s4, scratchpad0                    ;pointer to memory and byte counter
                 rsc_loop: CALL send_space
                           CALL read_byte_slow                     ;read data byte
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           STORE s3, (s4)                          ;store value in memory
                           LOAD s0, s3                             ;display value
                           CALL send_hex_byte
                           COMPARE s4, scratchpad7                 ;count bytes
                           JUMP Z, end_rsc_data_loop
                           ADD s4, 01
                           JUMP rsc_loop
        end_rsc_data_loop: CALL send_CR
                           CALL read_send_test_CRC16               ;read, display and test CRC value
                           JUMP warm_start
                           ;
                           ;
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; DS2432 Read Authenticated Page Command.
                           ;**************************************************************************************
                           ;
                           ; The read authenticated page command (A5 hex) allows the 8-byte secret to be tested
                           ; without it actually being read (which would obviously give away the secret!).
                           ;
                           ; This routine has been written to work with page 0 but could easily be changed and
                           ; is documented below. During the first part of the command, the 32 bytes
                           ; contained in the page are read back from the DS2432 and these are used in
                           ; the preparation of the table required for the for SHA-1 algorithm. Other values
                           ; stored in the table are the secret, serial number of the DS2432, family code, some
                           ; constants, 4-bits of the page address and a 3 byte 'challenge' currently set into
                           ; the DS2432 scratchpad memory.
                           ;
                           ; NOTE - The read scratchpad command must be executed before this routine in order
                           ; that the 3 byte 'challenge' of scratchpad memory is known to PicoBlaze.
                           ;
                           ; During this command, two 16-bit CRC values are generated which PicoBlaze also
                           ; computes and tests. The first is formed of the command byte, address TA1 and TA2,
                           ; all the bytes of the page read and an 'FF' byte. The second is formed of the 20
                           ; bytes of the 160-but message authentication code (MAC).
                           ;
                           ;
                           ; Preparing the table.
                           ;
                           ; The table is stored in the external 'Wt' buffer and must first be initialised with the
                           ; 16 'M' words (32-bit words each requiring 4 bytes). This is achieved by shifting in
                           ; each word in sequence. Storing each word most significant byte first is a natural
                           ; fit with the reading of the page data from the DS2432 and the way each 'M' word
                           ; is organised. Notice how this causes least significant bytes to be swapped with most
                           ; significant bytes!
                           ;
                           ;          [31:24]      [23:16]      [15:8]       [7:0]
                           ;
                           ;   M0 = [secret0    , secret1    , secret2    , secret3    ]
                           ;   M1 = [page_data0 , page_data1 , page_data2 , page_data3 ]
                           ;   M2 = [page_data4 , page_data5 , page_data6 , page_data7 ]
                           ;   M3 = [page_data8 , page_data9 , page_data10, page_data11]
                           ;   M4 = [page_data12, page_data13, page_data14, page_data15]
                           ;   M5 = [page_data16, page_data17, page_data18, page_data19]
                           ;   M6 = [page_data20, page_data21, page_data22, page_data23]
                           ;   M7 = [page_data24, page_data25, page_data26, page_data27]
                           ;   M8 = [page_data28, page_data29, page_data30, page_data31]
                           ;   M9 = [   FF      ,    FF      ,    FF      ,    FF      ]
                           ;  M10 = [   40      ,    33      , serial_num0, serial_num1]
                           ;  M11 = [serial_num2, serial_num3, serial_num4, serial_num5]
                           ;  M12 = [secret4    , secret5    , secret6    , secret7    ]
                           ;  M13 = [scratchpad4, scratchpad5, scratchpad6,    80      ]
                           ;  M14 = [   00      ,    00      ,    00      ,    00      ]
                           ;  M15 = [   00      ,    00      ,    01      ,    B8      ]
                           ;
                           ; In M10, the '33' is the family code and the '40' is made up of a constant bit
                           ; pattern '0100' and then bits [8:5] of the page address. This gives 4 possible values
                           ; for this byte during a Read Authenticated Page Command, but this routine is currently
                           ; fixed to work with page 0 only.
                           ;        40 - page 0
                           ;        41 - page 1
                           ;        42 - page 2
                           ;        43 - page 3
                           ;
                           ; M13 contains the 3 byte challenge from the scratch pad memory. This assumes that a
                           ; read scratchpad command has previously been used and the bytes held in the DS2432
                           ; scratchpad match those held in the PicoBlaze memory.
                           ;
                           ;
                           ; The 160-bit Message Authentication Code (MAC) is computed from the table using the SHA-1
                           ; algorithm. This algorithm actually results in 5 variables 'A', 'B', 'C', 'D' and 'E'
                           ; which are 32-bit values each formed of 4 bytes. The MAC is the concatenation of
                           ; the variables. To match the same order in which the Read Authenticated Page Command
                           ; sends the MAC, the variables must be read in the order 'E', 'D', 'C', 'B' and 'A' and
                           ; with the least significant byte of each variable first.
                           ;
                           ;
                           ;
                           ;
                           ;
   read_auth_page_command: LOAD s0, secret0                        ;store M0 (secret 0, 1, 2 and 3) in Wt buffer.
                           OUTPUT s0, W_word_write_port
                           LOAD s0, secret1
                           OUTPUT s0, W_word_write_port
                           LOAD s0, secret2
                           OUTPUT s0, W_word_write_port
                           LOAD s0, secret3
                           OUTPUT s0, W_word_write_port
                           ;
                           ;Start of DS2432 command
                           ;
                           CALL clear_CRC16                        ;prepare CRC registers [sE,sD]
                           LOAD s3, A5                             ;read authenticated page command
                           CALL write_byte_slow                    ;transmit command
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           LOAD s5, 00                             ;set address for page 0
                           LOAD s4, 00                             ;  [TA2,TA1]=0000 hex
                           LOAD s3, s4                             ;transmit TA1
                           CALL write_byte_slow
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           LOAD s3, s5                             ;transmit TA2
                           CALL write_byte_slow
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           ;
                           ;Read 32-bytes of data associated with page 0
                           ;Store these as M1 through to M8
                           ;
           rapc_line_loop: CALL send_CR
                           LOAD s0, s5                             ;display 16-bit address
                           CALL send_hex_byte
                           LOAD s0, s4
                           CALL send_hex_byte
                           CALL send_space
                           CALL send_space
           rapc_data_loop: CALL send_space
                           CALL read_byte_slow                     ;read data into s3
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           OUTPUT s3, W_word_write_port            ;store as 'M' word
                           LOAD s0, s3                             ;display byte
                           CALL send_hex_byte
                           ADD s4, 01                              ;increment address
                           ADDCY s5, 00
                           TEST s4, 07                             ;test for 8-byte boundary
                           JUMP NZ, rapc_data_loop
                           COMPARE s4, 20                          ;test for last address
                           JUMP NZ, rapc_line_loop
                           CALL send_CR
                           ;
                           ;Read one byte that should be value FF hex
                           ;
                           CALL read_byte_slow                     ;read data into s3
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           LOAD s0, s3                             ;display byte
                           CALL send_hex_byte
                           CALL send_CR
                           CALL read_send_test_CRC16               ;read, display and test CRC value
                           ;
                           ;Complete table by stroring M9 through to M15
                           ;
                           LOAD s0, FF                             ;W9 = FF FF FF FF
                           LOAD s1, 04
                 store_W9: OUTPUT s0, W_word_write_port
                           SUB s1, 01
                           JUMP NZ, store_W9
                           ;
                           LOAD s0, 40                             ;W10 begins with 40 for page 0
                           OUTPUT s0, W_word_write_port
                           ;
                           ;W10 ends with family code and serial number 0 and 1.
                           ;W11 is formed of serial number 2, 3, 4 and 5.
                           ;All of this information is in PicoBlaze memory having been read by the
                           ;read ROM command.
                           ;
                           LOAD s1, family_code                    ;pointer to memory
                           LOAD s2, 07                             ;7 bytes to read and store
             next_M10_M11: FETCH s0, (s1)
                           OUTPUT s0, W_word_write_port
                           ADD s1, 01                              ;increment pointer
                           SUB s2, 01
                           JUMP NZ, next_M10_M11
                           ;
                           LOAD s0, secret4                        ;store M12 (secret 4, 5, 6 and 7) in Wt buffer
                           OUTPUT s0, W_word_write_port
                           LOAD s0, secret5
                           OUTPUT s0, W_word_write_port
                           LOAD s0, secret6
                           OUTPUT s0, W_word_write_port
                           LOAD s0, secret7
                           OUTPUT s0, W_word_write_port
                           ;
                           FETCH s0, scratchpad4                   ;M13 uses scratchpad 4, 5, and 6 and '80' hex
                           OUTPUT s0, W_word_write_port
                           FETCH s0, scratchpad5
                           OUTPUT s0, W_word_write_port
                           FETCH s0, scratchpad6
                           OUTPUT s0, W_word_write_port
                           LOAD s0, 80
                           OUTPUT s0, W_word_write_port
                           ;
                           LOAD s0, 00                             ;W14 = 00 00 00 00   W15 = 00 00 01 B8
                           LOAD s1, 06
            store_W14_W15: OUTPUT s0, W_word_write_port
                           SUB s1, 01
                           JUMP NZ, store_W14_W15
                           LOAD s0, 01
                           OUTPUT s0, W_word_write_port
                           LOAD s0, B8
                           OUTPUT s0, W_word_write_port
                           ;
                           ;Compute the SHA-1 algorithm at the same time that the DS2432 is also computing (2ms).
                           ;
                           CALL compute_sha1
                           ;
                           ;The 160-bit Message Authentication Code is read from the DS2432 as 20 bytes
                           ;and compared with the concatenation of variables E, D, C, B and A in that order
                           ;with each variable received from the DS2432 least significant byte first.
                           ;Each received byte is also used to form a 16-bit CRC value which is tested to
                           ;reveal any communication errors.
                           ;
                           ;
                           CALL send_mac                           ;display 'mac='
                           CALL clear_CRC16                        ;prepare CRC registers [sE,sD]
                           LOAD sC, 00                             ;Clear byte match counter
                           LOAD sB, var_E0                         ;start match with LS-Byte of variable 'E'
            mac_match_var: LOAD sA, 04                             ;4 bytes to match in each variable
           mac_match_byte: FETCH s9, (sB)                          ;read variable byte from local SHA-1
                           CALL read_byte_slow                     ;read DS2432 byte into s3
                           CALL compute_CRC16                      ;compute CRC for value in 's3'
                           COMPARE s3, s9                          ;compare MAC values
                           JUMP NZ, display_mac_byte               ;count matching bytes
                           ADD sC, 01                              ;decrement match counter
         display_mac_byte: LOAD s0, s3                             ;display byte
                           CALL send_hex_byte
                           CALL send_space
                           SUB sA, 01                              ;counts bytes per variable
                           JUMP Z, next_mac_var
                           ADD sB, 01
                           JUMP mac_match_byte
             next_mac_var: COMPARE sB, var_A3                      ;test for last byte
                           JUMP Z, report_mac
                           SUB sB, 07                              ;point to next variable
                           JUMP mac_match_var
                           ;
                           ;MAC has passed if all 20 bytes matched
                           ;
               report_mac: CALL send_CR
                           COMPARE sC, 14                          ;20 bytes should have matched
                           JUMP NZ, mac_fail
                           CALL send_Pass
                           JUMP read_mac_CRC
                 mac_fail: CALL send_Fail
                           ;
                           ;Next two bytes received are the 16-bit CRC
                           ;Read 16-bit CRC into [s5,s4] and send value to UART
                           ;
             read_mac_CRC: CALL read_send_test_CRC16               ;read, display and test CRC value
                           ;
                           ;Read one byte that should be value AA hex.
                           ;  Would actually read AA hex continuously until master reset
                           ;
                           CALL read_byte_slow                     ;read data into s3
                           LOAD s0, s3                             ;display byte
                           CALL send_hex_byte
                           CALL send_CR
                           ;
                           JUMP warm_start
                           ;
                           ;
                           ;**************************************************************************************
                           ; Compute SHA-1 Algorithm.
                           ;**************************************************************************************
                           ;
                           ; Computes the SHA-1 algorithm based on the initial table of values (M0 through to M15)
                           ; which are stored in the external Wt buffer.
                           ;
                           ; The SHA-1 algorithms uses 5 variables called 'A', 'B', 'C', 'D' and 'E'. Each variable
                           ; is 32-bits and stored as 4 bytes in PicoBlaze scratch pad memory. The locations must
                           ; be defined using constants 'var_A0' thought to 'var_E3' in ascending locations.
                           ;
                           ; Constants must also be used to define access to the external Wt buffer.
                           ;
                           ; During this process, register 'sE' is used to count iterations from 0 to 79 (4F hex).
                           ; Other registers are consistently grouped as follows to support 32-bit operations.
                           ;
                           ; Register set [s5,s4,s3,s2] is used as a temporary 32-bit word
                           ; Register set [s9,s8,s7,s6] is used as a temporary 32-bit word
                           ; Register set [sD,sC,sB,sA] is used as a temporary 32-bit word
                           ;
                           ;
                           ; Initialise the 32-bit variables
                           ;
                           ;
             compute_sha1: LOAD s0, 01                             ;A=67452301
                           STORE s0, var_A0
                           LOAD s0, 23
                           STORE s0, var_A1
                           LOAD s0, 45
                           STORE s0, var_A2
                           LOAD s0, 67
                           STORE s0, var_A3
                           LOAD s0, 89                             ;B=EFCDAB89
                           STORE s0, var_B0
                           LOAD s0, AB
                           STORE s0, var_B1
                           LOAD s0, CD
                           STORE s0, var_B2
                           LOAD s0, EF
                           STORE s0, var_B3
                           LOAD s0, FE                             ;C=98BADCFE
                           STORE s0, var_C0
                           LOAD s0, DC
                           STORE s0, var_C1
                           LOAD s0, BA
                           STORE s0, var_C2
                           LOAD s0, 98
                           STORE s0, var_C3
                           LOAD s0, 76                             ;D=10325476
                           STORE s0, var_D0
                           LOAD s0, 54
                           STORE s0, var_D1
                           LOAD s0, 32
                           STORE s0, var_D2
                           LOAD s0, 10
                           STORE s0, var_D3
                           LOAD s0, F0                             ;E=C3D2E1F0
                           STORE s0, var_E0
                           LOAD s0, E1
                           STORE s0, var_E1
                           LOAD s0, D2
                           STORE s0, var_E2
                           LOAD s0, C3
                           STORE s0, var_E3
                           ;
                           ;
                           LOAD sE, 00                             ;reset iteration counter
                           ;
                           ;
                           ;Compute ft(B,C,D) in register set [s5,s4,s3,s2] and then add constant Kt.
                           ;
                           ;Iterations 0 to 19 - process type 1
                           ;   ft = (B and C) or ((not B) and D)
                           ;  Then the constant Kt=5A827999 will be added
                           ;
                           ;Iterations 20 to 39  and iterations 60 to 79  - process type 2
                           ;   ft = B xor C xor D
                           ;  Then the constant Kt=6ED9EBA1 will be added for iterations 20 to 39
                           ;  Then the constant Kt=CA62C1D6 will be added for iterations 60 to 79
                           ;
                           ;Iterations 40 to 59  - process type 3
                           ;   ft = (B and C) or (B and D) or (C and D)
                           ;  Then the constant Kt=8F1BBCDC will be added
                           ;
      next_sha1_iteration: FETCH s5, var_B3                        ;B in [s5,s4,s3,s2]
                           FETCH s4, var_B2
                           FETCH s3, var_B1
                           FETCH s2, var_B0
                           CALL fetch_C                            ;C in [s9,s8,s7,s6]
                           FETCH sD, var_D3                        ;D in [sD,sC,sB,sA]
                           FETCH sC, var_D2
                           FETCH sB, var_D1
                           FETCH sA, var_D0
                           ;
                           ;Determine process type
                           ;
                           COMPARE sE, 14                          ;set carry flag for iterations <20
                           JUMP C, ft_type1
                           COMPARE sE, 28                          ;set carry flag for iterations <40
                           JUMP C, ft_type2
                           COMPARE sE, 3C                          ;set carry flag for iterations <60
                           JUMP C, ft_type3
                           ;
                           ;   ft = B xor C xor D
                           ;
                           ;       B xor C     =        B       xor       C
                           ;   [s5,s4,s3,s2]   =  [s5,s4,s3,s2] xor [s9,s8,s7,s6]
                           ;
                           ;   B xor C xor D   =    (B xor C)   xor       D
                           ;   [s5,s4,s3,s2]   =  [s5,s4,s3,s2] xor [sD,sC,sB,sA]
                           ;
                           ;
                 ft_type2: XOR s5, s9                              ;B xor C in [s5,s4,s3,s2]
                           XOR s4, s8
                           XOR s3, s7
                           XOR s2, s6
                           XOR s5, sD                              ;(B xor C) xor D in [s5,s4,s3,s2]
                           XOR s4, sC
                           XOR s3, sB
                           XOR s2, sA
                           COMPARE sE, 3C                          ;set carry flag for iterations <60
                           JUMP NC, Kt_CA62C1D6
                           ADD s2, A1                              ;add Kt=6ED9EBA1
                           ADDCY s3, EB
                           ADDCY s4, D9
                           ADDCY s5, 6E
                           JUMP compute_TMP
              Kt_CA62C1D6: ADD s2, D6                              ;add Kt=CA62C1D6
                           ADDCY s3, C1
                           ADDCY s4, 62
                           ADDCY s5, CA
                           JUMP compute_TMP
                           ;
                           ;   ft = (B and C) or ((not B) and D)
                           ;
                           ;       B and C     =        C       and       B
                           ;   [s9,s8,s7,s6]   =  [s9,s8,s7,s6] and [s5,s4,s3,s2]
                           ;
                           ;       not B       =        B       xor   FFFFFFFF
                           ;   [s5,s4,s3,s2]   =  [s5,s4,s3,s2] xor [FF,FF,FF,FF]
                           ;
                           ;   (not B) and D   =    (not B)     and       D
                           ;   [s5,s4,s3,s2]   =  [s5,s4,s3,s2] and [sD,sC,sB,sA]
                           ;
                           ;   ;(B and C) or ((not B) and D)  =  ((not B) and D)  or   (B and C)
                           ;            [s5,s4,s3,s2]         =   [s5,s4,s3,s2]   or  [s9,s8,s7,s6]
                           ;
                 ft_type1: AND s9, s5                              ;B and C in [s9,s8,s7,s6]
                           AND s8, s4
                           AND s7, s3
                           AND s6, s2
                           XOR s5, FF                              ;(not B) in [s5,s4,s3,s2]
                           XOR s4, FF
                           XOR s3, FF
                           XOR s2, FF
                           AND s5, sD                              ;((not B) and D) in [s5,s4,s3,s2]
                           AND s4, sC
                           AND s3, sB
                           AND s2, sA
                           OR s5, s9                               ;(B and C) or ((not B) and D) in [s5,s4,s3,s2]
                           OR s4, s8
                           OR s3, s7
                           OR s2, s6
                           ADD s2, 99                              ;add Kt=5A827999
                           ADDCY s3, 79
                           ADDCY s4, 82
                           ADDCY s5, 5A
                           JUMP compute_TMP
                           ;
                           ;Routine to fetch variable 'C' into register set [s9,s8,s7,s6]
                           ;
                  fetch_C: FETCH s9, var_C3
                           FETCH s8, var_C2
                           FETCH s7, var_C1
                           FETCH s6, var_C0
                           RETURN
                           ;
                           ;   ft = (B and C) or (B and D) or (C and D)
                           ;
                           ;       B and C     =        C       and       B
                           ;   [s9,s8,s7,s6]   =  [s9,s8,s7,s6] and [s5,s4,s3,s2]
                           ;
                           ;       B and D     =        B       and       D
                           ;   [s5,s4,s3,s2]   =  [s5,s4,s3,s2] and [sD,sC,sB,sA]
                           ;
                           ;  (B and C) or (B and D)   =    (B and D)    or    (B and C)
                           ;      [s5,s4,s3,s2]        =  [s5,s4,s3,s2]  or  [s9,s8,s7,s6]
                           ;
                           ;     read C again into [s9,s8,s7,s6]
                           ;
                           ;       C and D     =        C       and       D
                           ;   [s9,s8,s7,s6]   =  [s9,s8,s7,s6] and [sD,sC,sB,sA]
                           ;
                           ;  ((B and C) or (B and D)) or (C and D)   =    ((B and C) or (B and D)) or   (C and D)
                           ;               [s5,s4,s3,s2]              =           [s5,s4,s3,s2]     or  [s9,s8,s7,s6]
                           ;
                 ft_type3: AND s9, s5                              ;(B and C) in [s9,s8,s7,s6]
                           AND s8, s4
                           AND s7, s3
                           AND s6, s2
                           AND s5, sD                              ;(B and D) in [s5,s4,s3,s2]
                           AND s4, sC
                           AND s3, sB
                           AND s2, sA
                           OR s5, s9                               ;(B and C) or (B and D) in [s5,s4,s3,s2]
                           OR s4, s8
                           OR s3, s7
                           OR s2, s6
                           CALL fetch_C                            ;C in [s9,s8,s7,s6]
                           AND s9, sD                              ;(C and D) in [s9,s8,s7,s6]
                           AND s8, sC
                           AND s7, sB
                           AND s6, sA
                           OR s5, s9                               ;(B and C) or (B and D) or (C and D) in [s5,s4,s3,s2]
                           OR s4, s8
                           OR s3, s7
                           OR s2, s6
                           ADD s2, DC                              ;add Kt=8F1BBCDC
                           ADDCY s3, BC
                           ADDCY s4, 1B
                           ADDCY s5, 8F
                           ;
                           ;Add variable 'E' to [s5,s4,s3,s2]
                           ;
              compute_TMP: FETCH s0, var_E0
                           ADD s2, s0
                           FETCH s0, var_E1
                           ADDCY s3, s0
                           FETCH s0, var_E2
                           ADDCY s4, s0
                           FETCH s0, var_E3
                           ADDCY s5, s0
                           ;
                           ;Add variable 'A' rotated left 5 places
                           ;
                           FETCH s9, var_A3                        ;A in [s9,s8,s7,s6]
                           FETCH s8, var_A2
                           FETCH s7, var_A1
                           FETCH s6, var_A0
                           LOAD s0, 05                             ;rotate left 5 places
                           CALL rotate_word_left_N_places
                           ADD s2, s6                              ;add to TMP
                           ADDCY s3, s7
                           ADDCY s4, s8
                           ADDCY s5, s9
                           ;
                           ;
                           ;Compute Wt in register set [s9,s8,s7,s6]
                           ;  Value computed is also stored back in the external buffer for
                           ;  use in later iterations as well as being added to TMP.
                           ;
                           ;Iterations 0 to 15
                           ;  Wt = Mt
                           ; This only requires Wt-16 to be read and then shifted back into the buffer again.
                           ;
                           ;Iterations 0 to 15
                           ;  Wt = rotate_left_1_place(Wt-3 xor Wt-8 xor Wt-14 xor Wt-16)
                           ; This requires all data values to be read first. Then XORed and rotated before
                           ; shifting the new Wt word into the buffer.
                           ;
                           ;
                           INPUT s9, Wt_minus16_byte3_read_port    ;Read Wt-16 value
                           INPUT s8, Wt_minus16_byte2_read_port
                           INPUT s7, Wt_minus16_byte1_read_port
                           INPUT s6, Wt_minus16_byte0_read_port
                           COMPARE sE, 10                          ;set carry flag for iterations 0 to 15
                           JUMP C, store_Wt
                           ;
                           ;Read other Wt words and perform XOR
                           ;
                           INPUT s0, Wt_minus14_byte3_read_port    ;XOR with Wt-14 value
                           XOR s9, s0
                           INPUT s0, Wt_minus14_byte2_read_port
                           XOR s8, s0
                           INPUT s0, Wt_minus14_byte1_read_port
                           XOR s7, s0
                           INPUT s0, Wt_minus14_byte0_read_port
                           XOR s6, s0
                           INPUT s0, Wt_minus8_byte3_read_port     ;XOR with Wt-8 value
                           XOR s9, s0
                           INPUT s0, Wt_minus8_byte2_read_port
                           XOR s8, s0
                           INPUT s0, Wt_minus8_byte1_read_port
                           XOR s7, s0
                           INPUT s0, Wt_minus8_byte0_read_port
                           XOR s6, s0
                           INPUT s0, Wt_minus3_byte3_read_port     ;XOR with Wt-3 value
                           XOR s9, s0
                           INPUT s0, Wt_minus3_byte2_read_port
                           XOR s8, s0
                           INPUT s0, Wt_minus3_byte1_read_port
                           XOR s7, s0
                           INPUT s0, Wt_minus3_byte0_read_port
                           XOR s6, s0
                           CALL rotate_word_left                   ;rotate XORed word left by one place
                           ;
                           ;Store new Wt value in external buffer
                           ;
                 store_Wt: OUTPUT s9, W_word_write_port
                           OUTPUT s8, W_word_write_port
                           OUTPUT s7, W_word_write_port
                           OUTPUT s6, W_word_write_port
                           ;
                           ;Add new computed Wt value to TMP in [s5,s4,s3,s2]
                           ;
                           ADD s2, s6
                           ADDCY s3, s7
                           ADDCY s4, s8
                           ADDCY s5, s9
                           ;
                           ;TMP is now complete in [s5,s4,s3,s2]
                           ;
                           ;
                           ;copy values
                           ;  E <= D
                           ;  D <= C
                           ;  C <= B (this will need to be rotated 30 places afterwards)
                           ;  B <= A
                           ;
                           LOAD sD, 04                             ;4 bytes per word to copy
            copy_var_loop: LOAD sC, var_E3
                           LOAD sB, var_E2
            move_var_loop: FETCH sA, (sB)
                           STORE sA, (sC)
                           SUB sC, 01
                           SUB sB, 01
                           COMPARE sC, var_A0
                           JUMP NZ, move_var_loop
                           SUB sD, 01
                           JUMP NZ, copy_var_loop
                           ;
                           ;rotate 'C' (the previous 'B') left 30 places
                           ;
                           CALL fetch_C                            ;C in [s9,s8,s7,s6]
                           LOAD s0, 1E                             ;rotate left 30 places
                           CALL rotate_word_left_N_places
                           STORE s9, var_C3
                           STORE s8, var_C2
                           STORE s7, var_C1
                           STORE s6, var_C0
                           ;
                           ;  A <= TMP
                           ;
                           STORE s5, var_A3
                           STORE s4, var_A2
                           STORE s3, var_A1
                           STORE s2, var_A0
                           ;
                           ;count iterations
                           ;
                           COMPARE sE, 4F                          ;test for last iteration = 79 decimal (4F hex)
                           RETURN Z
                           ADD sE, 01
                           JUMP next_sha1_iteration
                           ;
                           ; Routine to rotate left the contents of Register set [s9,s8,s7,s6]
                           ; by the number of places specified in register 's0'.
                           ;
rotate_word_left_N_places: CALL rotate_word_left
                           SUB s0, 01
                           JUMP NZ, rotate_word_left_N_places
                           RETURN
                           ;
                           ; Routine to rotate left the contents of Register set [s9,s8,s7,s6]
                           ; by one place.
                           ;
         rotate_word_left: TEST s9, 80                             ;test MSB of word
                           SLA s6
                           SLA s7
                           SLA s8
                           SLA s9
                           RETURN
                           ;
                           ;**************************************************************************************
                           ; Compute 8-bit CRC used by DS2432.
                           ;**************************************************************************************
                           ;
                           ; The DS2432 computes an 8-bit CRC using the polynomial X8 + X5 + X4 + 1.
                           ; See the DS2432 data sheet for full details.
                           ;
                           ; Test input value of value 00 00 00 01 B8 1C 02
                           ; should produce CRC=A2.
                           ;
                           ; This routine computes the same CRC based on the values stored in the KCPSM3
                           ; scratch pad memory by the read ROM command. The result is returned in register s0.
                           ;
                           ; Registers used s0,s1,s2,s3,s4,s5,s6,s7,s8,s9
                           ;
                           ;
                           ; Start by loading family code and serial number (56-bits) into register set
                           ; [s9,s8,s7,s6,s5,s4,s3] so that it can be shifted out LSB first.
                           ;
                           ;
             compute_CRC8: FETCH s3, family_code
                           FETCH s4, serial_number0
                           FETCH s5, serial_number1
                           FETCH s6, serial_number2
                           FETCH s7, serial_number3
                           FETCH s8, serial_number4
                           FETCH s9, serial_number5
                           LOAD s2, 38                             ;56 bits to shift (38 hex)
                           LOAD s0, 00                             ;clear CRC value
                crc8_loop: LOAD s1, s0                             ;copy current CRC value
                           XOR s1, s3                              ;Need to know LSB XOR next input bit
                           TEST s1, 01                             ;test result of XOR in LSB
                           JUMP NC, crc8_shift
                           XOR s0, 18                              ;compliment bits 3 and 4 of CRC
               crc8_shift: SR0 s1                                  ;Carry gets LSB XOR next input bit
                           SRA s0                                  ;shift Carry into MSB to form new CRC value
                           SR0 s9                                  ;shift input value
                           SRA s8
                           SRA s7
                           SRA s6
                           SRA s5
                           SRA s4
                           SRA s3
                           SUB s2, 01                              ;count iterations
                           JUMP NZ, crc8_loop
                           RETURN
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; Clear or Compute 16-bit CRC used by DS2432.
                           ;**************************************************************************************
                           ;
                           ; The DS2432 computes a 16-bit CRC using the polynomial X16 + X15 + X2 + 1.
                           ; See the DS2432 data sheet for full details.
                           ;
                           ; Note that the value formed in the CRC shift register MUST BE INVERTED to give the
                           ; same value as that sent from the DS2432 during scratchpad write, scratchpad read
                           ; and read auth page commands.
                           ;
                           ; The 16-bit CRC is computed using a different number of bytes depending on the
                           ; command. This routine has been written such that the CRC can be computed one
                           ; byte at a time. The byte to be processed should be provided in register 's3'
                           ; and the contents of this register are preserved.
                           ;
                           ; This routine computes the 16-bit CRC in the register pair [sE,sD] and these
                           ; registers must not be disturbed between calls of this routine.
                           ;
                           ; Before starting a CRC computation the 'clear_CRC16' should be used.
                           ;
                           ; Registers used s0,s1,s3,sD,sE
                           ;    s3 is preserved.
                           ;    sD and sE should not be disturbed between calls if CRC value is required.
                           ;
                           ;
              clear_CRC16: LOAD sE, 00                             ;[sE,sD]=0000
                           LOAD sD, 00
                           RETURN
                           ;
            compute_CRC16: LOAD s1, 08                             ;8-bits to shift
               crc16_loop: LOAD s0, sD                             ;copy current CRC value
                           XOR s0, s3                              ;Need to know LSB XOR next input bit
                           TEST s0, 01                             ;test result of XOR in LSB
                           JUMP NC, crc16_shift
                           XOR sD, 02                              ;compliment bit 1 of CRC
                           XOR sE, 40                              ;compliment bit 14 of CRC
              crc16_shift: SR0 s0                                  ;Carry gets LSB XOR next input bit
                           SRA sE                                  ;shift Carry into MSB to form new CRC value
                           SRA sD
                           RR s3                                   ;shift input value
                           SUB s1, 01                              ;count bits
                           JUMP NZ, crc16_loop                     ;next bit
                           RETURN
                           ;
                           ;
                           ;**************************************************************************************
                           ; Read 16-bit CRC from DS2432, send value received to UART and test result.
                           ;**************************************************************************************
                           ;
                           ; The computed CRC value for comparison must be in register pair [sE,sD]
                           ;
     read_send_test_CRC16: CALL read_byte_slow                     ;read 16-bit CRC into [s5,s4]
                           LOAD s4, s3
                           CALL read_byte_slow
                           LOAD s5, s3
                           CALL send_crc                           ;'crc=' to display CRC value
                           LOAD s0, s5
                           CALL send_hex_byte
                           LOAD s0, s4
                           CALL send_hex_byte
                           CALL send_CR
                           XOR sD, FF                              ;1's complement the computed CRC value
                           XOR sE, FF
                           COMPARE s4, sD                          ;test received value with computed value
                           JUMP NZ, crc16_fail
                           COMPARE s5, sE
                           JUMP NZ, crc16_fail
                           CALL send_Pass                          ;display 'Pass' with carriage return
                           RETURN
               crc16_fail: CALL send_Fail                          ;display 'Fail' with carriage return
                           RETURN
                           ;
                           ;
                           ;**************************************************************************************
                           ; Initialise the DS2432 1-wire interface.
                           ;**************************************************************************************
                           ;
                           ; The 1-wire interface is an open-collector communication scheme employing an external
                           ; pull-up resistor of 680 Ohms.
                           ;
                           ; The hardware section of this translates the one bit signal from PicoBlaze such that
                           ; when this signal is Low the output is driven Low, but when it is High, it turns off
                           ; the output buffer and the signal is pulled High externally.
                           ;
                           ; This initialisation routine simply ensures that the line is High after configuration.
                           ; It is vital that DS_wire is generally in the High state because it is the only way in
                           ; which the DS2432 device derives power to operate.
                           ;
                           ; Registers used s0
                           ;
             DS_wire_init: LOAD s0, DS_wire
                           OUTPUT s0, DS_wire_out_port
                           RETURN
                           ;
                           ;
                           ;**************************************************************************************
                           ; DS2432 initialisation - Regular Speed.
                           ;**************************************************************************************
                           ;
                           ; The initialisation sequence must be performed before any communication can be
                           ; made with the DS2432 device. This involves the application of an active Low master
                           ; reset pulse.
                           ;
                           ; The regular (slow) speed communication is established by transmitting an active
                           ; Low reset pulse for a duration of at least 480us. This design generates a 500us pulse.
                           ;
                           ; The DS2432 acknowledges the reset and the setting of regular mode by generating an
                           ; active Low 'Rx Presence Pulse'. This presence pulse can start 15 to 60us after the
                           ; reset pulse and will end between 120 and 300us after the reset pulse.
                           ;
                           ; To confirm that regular mode has been set, this routine confirms that the presence pulse
                           ; is active only after 60us have elapsed since the reset pulse. This ensures that the
                           ; faster presence pulse of overdrive mode can not be detected.
                           ;
                           ; The carry flag will be set if no valid presence pulse was received (wire remained High) and
                           ; can be used to indicate an initialisation failure or success.
                           ;
                           ; The routine only completes 300us after the presence pulse to ensure the DS2432 has
                           ; completed the presence pulse and is ready for the first operation.
                           ;
                           ; Registers used s0,s1,s2
                           ;
     DS_init_regular_mode: LOAD s0, 00                             ;transmit reset pulse
                           OUTPUT s0, DS_wire_out_port
                           ;Delay of 500us is equivalent to 12500 instructions at 50MHz.
                           ;This delay loop is formed of 28 instructions requiring 446 repetitions.
                           LOAD s2, 01                             ;[s3,s2]=445 decimal (01BD hex)
                           LOAD s1, BD
            rm_wait_500us: CALL delay_1us                          ;25 instructions including CALL
                           SUB s1, 01                              ;decrement delay counter
                           SUBCY s2, 00
                           JUMP NC, rm_wait_500us                  ;repeat until -1
                           LOAD s0, 01                             ;end of regular reset pulse
                           OUTPUT s0, DS_wire_out_port
                           ;Delay of 60us is equivalent to 1500 instructions at 50MHz.
                           ;This delay and is formed of 27 instructions requiring 56 repetitions.
                           LOAD s1, 38                             ;56 (38 hex)
             rm_wait_60us: CALL delay_1us                          ;25 instructions including CALL
                           SUB s1, 01                              ;decrement delay counter
                           JUMP NZ, rm_wait_60us                   ;repeat until zero
                           ;The DS_wire is now checked at approximately 1us intervals for the next 240us looking
                           ;to detect an active Low presence pulse. The 240us is equivalent to 6000 instructions
                           ;at 50MHz and this polling loop is formed of 33 instructions requiring 182 repetitions.
                           LOAD s2, 01                             ;set bit which will be reset by a presence pulse
                           LOAD s1, B6                             ;182 (B6 hex)
            rm_poll_240us: CALL delay_1us                          ;25 instructions including CALL
                           CALL read_DS_wire                       ;read wire - 5 instructions including CALL
                           AND s2, s0                              ;clear flag if DS_wire was Low
                           SUB s1, 01                              ;decrement delay counter
                           JUMP NZ, rm_poll_240us                  ;repeat until zero
                           TEST s2, 01                             ;set carry flag if no pulse detected
                           RETURN
                           ;
                           ;
                           ;**************************************************************************************
                           ; Read the DS_wire
                           ;**************************************************************************************
                           ;
                           ; The DS_wire signal is read and returned in bit0 of register 's0'.
                           ; Additionally the carry flag is set if the signal is High and reset if Low
                           ;
                           ; Registers used s0
                           ;
             read_DS_wire: INPUT s0, DS_wire_in_port
                           AND s0, DS_wire                         ;ensure only bit0 is active
                           TEST s0, DS_wire                        ;set carry flag if DS_wire is High
                           RETURN
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; Write a byte to DS2432 in regular speed mode.
                           ;**************************************************************************************
                           ;
                           ; Bytes are written to the DS2432 with LSB first.
                           ;
                           ; The byte to be written should be provided in register 's3' and this will be preserved.
                           ;
                           ; Registers used s0,s1,s2,s3
                           ;
          write_byte_slow: LOAD s2, 08                             ;8 bits to transmit
                 wbs_loop: RR s3                                   ;test next bit LSB first
                           JUMP C, wbs1                            ;transmit '0' or '1'
                           CALL write_Low_slow
                           JUMP next_slow_bit
                     wbs1: CALL write_High_slow
            next_slow_bit: SUB s2, 01                              ;count bits
                           JUMP NZ, wbs_loop                       ;repeat until 8-bits transmitted
                           RETURN
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; Write a '0' to DS_wire in regular speed mode.
                           ;**************************************************************************************
                           ;
                           ; To write a '0' to the DS_wire the signal must be Low for 60 to 120us. This design
                           ; generates a 78us active Low pulse.
                           ;
                           ; The DS2432 then requires at least 1us of recovery time for which this routine
                           ; provides a 2us delay such that the entire write Low process (slot time) is 80us.
                           ; A recovery time of 1us was also found to be marginal in practice probably due
                           ; to the rise time of the DS_wire via the external pull up resistor.
                           ;
                           ; Registers used s0,s1
                           ;
           write_Low_slow: LOAD s0, 00                             ;transmit Low pulse
                           OUTPUT s0, DS_wire_out_port
                           ;Delay of 78us is equivalent to 1950 instructions at 50MHz.
                           ;This delay loop is formed of 27 instructions requiring 72 repetitions.
                           LOAD s1, 48                             ;72 (48 hex)
            wls_wait_78us: CALL delay_1us                          ;25 instructions including CALL
                           SUB s1, 01                              ;decrement delay counter
                           JUMP NZ, wls_wait_78us                  ;repeat until zero
                           LOAD s0, 01                             ;end of Low pulse
                           OUTPUT s0, DS_wire_out_port
                           CALL delay_1us                          ;2us recovery time
                           CALL delay_1us
                           RETURN
                           ;
                           ;
                           ;**************************************************************************************
                           ; Write a '1' to DS_wire in regular speed mode.
                           ;**************************************************************************************
                           ;
                           ; To write a '1' to the DS_wire the signal must be Low for 1 to 15us to instigate the
                           ; write of the data. This design generates an 8us active Low pulse for this purpose.
                           ;
                           ; Then the output must be High for 53 to 114us to provide the '1' for the DS2432 to
                           ; read and then provide recovery time. This design implements a 72us delay such that
                           ; the entire write High process (slot time) is 80us
                           ;
                           ; Registers used s0,s1
                           ;
          write_High_slow: LOAD s0, 00                             ;transmit Low pulse
                           OUTPUT s0, DS_wire_out_port
                           ;Delay of 8us is equivalent to 200 instructions at 50MHz.
                           ;This delay loop is formed of 27 instructions requiring 8 repetitions.
                           LOAD s1, 08                             ;8 (08 hex)
             whs_wait_8us: CALL delay_1us                          ;25 instructions including CALL
                           SUB s1, 01                              ;decrement delay counter
                           JUMP NZ, whs_wait_8us                   ;repeat until zero
                           LOAD s0, 01                             ;end of Low pulse
                           OUTPUT s0, DS_wire_out_port
                           ;Delay of 72us is equivalent to 1800 instructions at 50MHz.
                           ;This delay loop is formed of 27 instructions requiring 67 repetitions.
                           LOAD s1, 43                             ;67 (43 hex)
            whs_wait_72us: CALL delay_1us                          ;25 instructions including CALL
                           SUB s1, 01                              ;decrement delay counter
                           JUMP NZ, whs_wait_72us                  ;repeat until zero
                           RETURN
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; Read a byte from DS2432 in regular speed mode.
                           ;**************************************************************************************
                           ;
                           ; Bytes are read from the DS2432 with LSB first.
                           ;
                           ; The byte read will be returned in register 's3'.
                           ;
                           ; Registers used s0,s1,s2,s3
                           ;
           read_byte_slow: LOAD s2, 08                             ;8 bits to receive
                 rbs_loop: CALL read_bit_slow                      ;read next bit LSB first
                           SUB s2, 01                              ;count bits
                           JUMP NZ, rbs_loop                       ;repeat until 8-bits received
                           RETURN
                           ;
                           ;
                           ;
                           ;
                           ;**************************************************************************************
                           ; Read a data bit sent from the DS2432 in regular speed mode.
                           ;**************************************************************************************
                           ;
                           ; To read a bit, PicoBlaze must initiate the processed with an active Low pulse of
                           ; 1 to 15us. This design generates a 4us active Low pulse for this purpose.
                           ;
                           ; Then DS2432 responds to the Low pulse by diving DS_wire in two different ways
                           ; depending on the logic level it is trying to send back.
                           ;
                           ; For a logic '0' the DS2432 will drive the DS-wire Low for up to 15us after
                           ; the start of the instigating pulse. Therefore PicoBlaze must read the DS-wire
                           ; before this time has elapsed but only after it has itself released the wire.
                           ;
                           ; For a logic '1' the DS2432 will do nothing and hence the DS-wire will be pulled
                           ; High by the external resistor after PicoBlaze has released the wire. PicoBlaze
                           ; will sample the wire and detect the High level.
                           ;
                           ; In this design, PicoBlaze needs to detect the logic state of the wire after
                           ; releasing the wire at 4us. Sampling the wire too quickly would not provide
                           ; adequate time for a High signal to be formed by the pull up resistor. However, it
                           ; must sample the wire before 15us have elapsed and any potential Low is removed.
                           ; This design samples the wire at 12us which is 8us after the initiation pulse ends.
                           ;
                           ; A further delay of 68us is then allowed for the DS2432 to stop transmitting and
                           ; to recover. This also mean that the entire read process (slot time) is 80us.
                           ;
                           ; The received data bit is SHIFTED into the MSB of register 's3'. In this way
                           ; the reception of 8-bits will shift the first bit into the LSB position of 's3'.
                           ;
                           ; Registers used s0,s1,s3
                           ;
            read_bit_slow: LOAD s0, 00                             ;transmit Low pulse
                           OUTPUT s0, DS_wire_out_port
                           ;Delay of 4us is equivalent to 100 instructions at 50MHz.
                           ;This delay loop is formed of 27 instructions requiring 4 repetitions.
                           LOAD s1, 04                             ;4 (04 hex)
             rbs_wait_4us: CALL delay_1us                          ;25 instructions including CALL
                           SUB s1, 01                              ;decrement delay counter
                           JUMP NZ, rbs_wait_4us                   ;repeat until zero
                           LOAD s0, 01                             ;end of Low pulse
                           OUTPUT s0, DS_wire_out_port
                           ;Delay of 8us is equivalent to 200 instructions at 50MHz.
                           ;This delay loop is formed of 27 instructions requiring 8 repetitions.
                           LOAD s1, 08                             ;8 (08 hex)
             rbs_wait_8us: CALL delay_1us                          ;25 instructions including CALL
                           SUB s1, 01                              ;decrement delay counter
                           JUMP NZ, rbs_wait_8us                   ;repeat until zero
                           CALL read_DS_wire                       ;sample wire (carry = state)
                           SRA s3                                  ;shift received bit into MSB of s3
                           ;Delay of 68us is equivalent to 1700 instructions at 50MHz.
                           ;This delay loop is formed of 27 instructions requiring 63 repetitions.
                           LOAD s1, 3F                             ;63 (3F hex)
            rbs_wait_68us: CALL delay_1us                          ;25 instructions including CALL
                           SUB s1, 01                              ;decrement delay counter
                           JUMP NZ, rbs_wait_68us                  ;repeat until zero
                           RETURN
                           ;
                           ;
                           ;**************************************************************************************
                           ; Software delay routines
                           ;**************************************************************************************
                           ;
                           ; Delay of 1us.
                           ;
                           ; Constant value defines reflects the clock applied to KCPSM3. Every instruction
                           ; executes in 2 clock cycles making the calculation highly predictable. The '6' in
                           ; the following equation even allows for 'CALL delay_1us' instruction in the initiating code.
                           ;
                           ; delay_1us_constant =  (clock_rate - 6)/4       Where 'clock_rate' is in MHz
                           ;
                           ; Register used s0
                           ;
                delay_1us: LOAD s0, delay_1us_constant
                 wait_1us: SUB s0, 01
                           JUMP NZ, wait_1us
                           RETURN
                           ;
                           ; Delay of 40us.
                           ;
                           ; Registers used s0, s1
                           ;
               delay_40us: LOAD s1, 28                             ;40 x 1us = 40us
                wait_40us: CALL delay_1us
                           SUB s1, 01
                           JUMP NZ, wait_40us
                           RETURN
                           ;
                           ;
                           ; Delay of 1ms.
                           ;
                           ; Registers used s0, s1, s2
                           ;
                delay_1ms: LOAD s2, 19                             ;25 x 40us = 1ms
                 wait_1ms: CALL delay_40us
                           SUB s2, 01
                           JUMP NZ, wait_1ms
                           RETURN
                           ;
                           ; Delay of 20ms.
                           ;
                           ; Registers used s0, s1, s2, s3
                           ;
               delay_20ms: LOAD s3, 14                             ;20 x 1ms = 20ms
                wait_20ms: CALL delay_1ms
                           SUB s3, 01
                           JUMP NZ, wait_20ms
                           RETURN
                           ;
                           ; Delay of approximately 1 second.
                           ;
                           ; Registers used s0, s1, s2, s3, s4
                           ;
                 delay_1s: LOAD s4, 14                             ;50 x 20ms = 1000ms
                  wait_1s: CALL delay_20ms
                           SUB s4, 01
                           JUMP NZ, wait_1s
                           RETURN
                           ;
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
           read_from_UART: INPUT s0, status_port                   ;test Rx_FIFO buffer
                           TEST s0, rx_data_present                ;wait if empty
                           JUMP NZ, read_character
                           JUMP read_from_UART
           read_character: INPUT UART_data, UART_read_port         ;read from FIFO
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
             send_to_UART: INPUT s0, status_port                   ;test Tx_FIFO buffer
                           TEST s0, tx_full                        ;wait if full
                           JUMP Z, UART_write
                           JUMP send_to_UART
               UART_write: OUTPUT UART_data, UART_write_port
                           RETURN
                           ;
                           ;
                           ;**************************************************************************************
                           ; Useful ASCII conversion and handling routines
                           ;**************************************************************************************
                           ;
                           ;
                           ; Convert character to upper case
                           ;
                           ; The character supplied in register s0.
                           ; If the character is in the range 'a' to 'z', it is converted
                           ; to the equivalent upper case character in the range 'A' to 'Z'.
                           ; All other characters remain unchanged.
                           ;
                           ; Registers used s0.
                           ;
               upper_case: COMPARE s0, 61                          ;eliminate character codes below 'a' (61 hex)
                           RETURN C
                           COMPARE s0, 7B                          ;eliminate character codes above 'z' (7A hex)
                           RETURN NC
                           AND s0, DF                              ;mask bit5 to convert to upper case
                           RETURN
                           ;
                           ;
                           ; Convert hexadecimal value provided in register s0 into ASCII characters
                           ;
                           ; The value provided must can be any value in the range 00 to FF and will be converted into
                           ; two ASCII characters.
                           ;     The upper nibble will be represented by an ASCII character returned in register s2.
                           ;     The lower nibble will be represented by an ASCII character returned in register s1.
                           ;
                           ; The ASCII representations of '0' to '9' are 30 to 39 hexadecimal which is simply 30 hex
                           ; added to the actual decimal value. The ASCII representations of 'A' to 'F' are 41 to 46
                           ; hexadecimal requiring a further addition of 07 to the 30 already added.
                           ;
                           ; Registers used s0, s1 and s2.
                           ;
        hex_byte_to_ASCII: LOAD s1, s0                             ;remember value supplied
                           SR0 s0                                  ;isolate upper nibble
                           SR0 s0
                           SR0 s0
                           SR0 s0
                           CALL hex_to_ASCII                       ;convert
                           LOAD s2, s0                             ;upper nibble value in s2
                           LOAD s0, s1                             ;restore complete value
                           AND s0, 0F                              ;isolate lower nibble
                           CALL hex_to_ASCII                       ;convert
                           LOAD s1, s0                             ;lower nibble value in s1
                           RETURN
                           ;
                           ; Convert hexadecimal value provided in register s0 into ASCII character
                           ;
                           ;Register used s0
                           ;
             hex_to_ASCII: SUB s0, 0A                              ;test if value is in range 0 to 9
                           JUMP C, number_char
                           ADD s0, 07                              ;ASCII char A to F in range 41 to 46
              number_char: ADD s0, 3A                              ;ASCII char 0 to 9 in range 30 to 40
                           RETURN
                           ;
                           ;
                           ; Send the two character HEX value of the register contents 's0' to the UART
                           ;
                           ; Registers used s0, s1, s2
                           ;
            send_hex_byte: CALL hex_byte_to_ASCII
                           LOAD UART_data, s2
                           CALL send_to_UART
                           LOAD UART_data, s1
                           CALL send_to_UART
                           RETURN
                           ;
                           ;
                           ;
                           ; Convert the HEX ASCII characters contained in 's3' and 's2' into
                           ; an equivalent hexadecimal value in register 's0'.
                           ;     The upper nibble is represented by an ASCII character in register s3.
                           ;     The lower nibble is represented by an ASCII character in register s2.
                           ;
                           ; Input characters must be in the range 00 to FF hexadecimal or the CARRY flag
                           ; will be set on return.
                           ;
                           ; Registers used s0, s2 and s3.
                           ;
        ASCII_byte_to_hex: LOAD s0, s3                             ;Take upper nibble
                           CALL ASCII_to_hex                       ;convert to value
                           RETURN C                                ;reject if out of range
                           LOAD s3, s0                             ;remember value
                           SL0 s3                                  ;multiply value by 16 to put in upper nibble
                           SL0 s3
                           SL0 s3
                           SL0 s3
                           LOAD s0, s2                             ;Take lower nibble
                           CALL ASCII_to_hex                       ;convert to value
                           RETURN C                                ;reject if out of range
                           OR s0, s3                               ;merge in the upper nibble with CARRY reset
                           RETURN
                           ;
                           ;
                           ; Routine to convert ASCII data in 's0' to an equivalent HEX value.
                           ;
                           ; If character is not valid for hex, then CARRY is set on return.
                           ;
                           ; Register used s0
                           ;
             ASCII_to_hex: ADD s0, B9                              ;test for above ASCII code 46 ('F')
                           RETURN C
                           SUB s0, E9                              ;normalise 0 to 9 with A-F in 11 to 16 hex
                           RETURN C                                ;reject below ASCII code 30 ('0')
                           SUB s0, 11                              ;isolate A-F down to 00 to 05 hex
                           JUMP NC, ASCII_letter
                           ADD s0, 07                              ;test for above ASCII code 46 ('F')
                           RETURN C
                           SUB s0, F6                              ;convert to range 00 to 09
                           RETURN
             ASCII_letter: ADD s0, 0A                              ;convert to range 0A to 0F
                           RETURN
                           ;
                           ;
                           ; Read one character from UART and echo.
                           ; Convert to upper case and return.
                           ;
                           ;
          read_upper_case: CALL read_from_UART                     ;read command character from UART
                           CALL send_to_UART                       ;echo character
                           LOAD s0, UART_data                      ;convert to upper case
                           CALL upper_case
                           RETURN
                           ;
                           ;
                           ; Read two hex characters from UART and convert to single byte data
                           ;
             obtain_8bits: CALL read_upper_case                    ;obtain one byte from UART
                           LOAD s3, s0
                           CALL read_upper_case
                           LOAD s2, s0
                           CALL ASCII_byte_to_hex
                           RETURN
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
                           ; Send a minus sign to the UART
                           ;
               send_minus: LOAD UART_data, character_minus
                           CALL send_to_UART
                           RETURN
                           ;
                           ;
                           ; Send the letter 't' to the UART
                           ;
                   send_t: LOAD UART_data, character_t
                           CALL send_to_UART
                           RETURN
                           ;
                           ; Send the letter 'e' to the UART
                           ;
                   send_e: LOAD UART_data, character_e
                           CALL send_to_UART
                           RETURN
                           ;
                           ; Send the letter 'a' to the UART
                           ;
                   send_a: LOAD UART_data, character_a
                           CALL send_to_UART
                           RETURN
                           ;
                           ;
                           ; Send the letter 'd' to the UART
                           ;
                   send_d: LOAD UART_data, character_d
                           CALL send_to_UART
                           RETURN
                           ;
                           ;
                           ; Send the letter 'r' to the UART
                           ;
                   send_r: LOAD UART_data, character_r
                           CALL send_to_UART
                           RETURN
                           ;
                           ;
                           ; Send the letter 's' to the UART
                           ;
                   send_s: LOAD UART_data, character_s
                           CALL send_to_UART
                           RETURN
                           ;
                           ;
                           ; Send the letter 'c' to the UART
                           ;
                   send_c: LOAD UART_data, character_c
                           CALL send_to_UART
                           RETURN
                           ;
                           ;
                           ; Send 'PicoBlaze SHA-1 Algorithm v1.00' string to the UART
                           ;
             send_welcome: CALL send_CR
                           CALL send_CR
                           LOAD UART_data, character_P
                           CALL send_to_UART
                           LOAD UART_data, character_i
                           CALL send_to_UART
                           CALL send_c
                           LOAD UART_data, character_o
                           CALL send_to_UART
                           LOAD UART_data, character_B
                           CALL send_to_UART
                           LOAD UART_data, character_l
                           CALL send_to_UART
                           CALL send_a
                           LOAD UART_data, character_z
                           CALL send_to_UART
                           CALL send_e
                           CALL send_space
                           LOAD UART_data, character_S
                           CALL send_to_UART
                           LOAD UART_data, character_H
                           CALL send_to_UART
                           LOAD UART_data, character_A
                           CALL send_to_UART
                           CALL send_minus
                           LOAD UART_data, character_1
                           CALL send_to_UART
                           CALL send_space
                           LOAD UART_data, character_A
                           CALL send_to_UART
                           LOAD UART_data, character_l
                           CALL send_to_UART
                           LOAD UART_data, character_g
                           CALL send_to_UART
                           LOAD UART_data, character_o
                           CALL send_to_UART
                           CALL send_r
                           LOAD UART_data, character_i
                           CALL send_to_UART
                           CALL send_t
                           LOAD UART_data, character_h
                           CALL send_to_UART
                           LOAD UART_data, character_m
                           CALL send_to_UART
                           CALL send_space
                           LOAD UART_data, character_v
                           CALL send_to_UART
                           LOAD UART_data, character_1
                           CALL send_to_UART
                           LOAD UART_data, character_fullstop
                           CALL send_to_UART
                           LOAD UART_data, character_0
                           CALL send_to_UART
                           LOAD UART_data, character_0
                           CALL send_to_UART
                           CALL send_CR
                           CALL send_CR
                           RETURN
                           ;
                           ;
                           ;
                           ;
                           ;
                           ;
                           ; Send DS2432 menu to the UART
                           ;
         send_DS2432_menu: CALL send_CR
                           CALL send_CR
                           LOAD UART_data, character_1
                           CALL send_to_UART
                           CALL send_minus
                           CALL send_Write
                           CALL send_space
                           CALL send_scratchpad
                           CALL send_CR
                           LOAD UART_data, character_2
                           CALL send_to_UART
                           CALL send_minus
                           CALL send_Read
                           CALL send_space
                           CALL send_scratchpad
                           CALL send_CR
                           LOAD UART_data, character_3
                           CALL send_to_UART
                           CALL send_minus
                           LOAD UART_data, character_L
                           CALL send_to_UART
                           LOAD UART_data, character_o
                           CALL send_to_UART
                           CALL send_a
                           CALL send_d
                           CALL send_space
                           LOAD UART_data, character_f
                           CALL send_to_UART
                           LOAD UART_data, character_i
                           CALL send_to_UART
                           CALL send_r
                           CALL send_s
                           CALL send_t
                           CALL send_space
                           CALL send_secret
                           CALL send_CR
                           LOAD UART_data, character_4
                           CALL send_to_UART
                           CALL send_minus
                           CALL send_Read
                           CALL send_space
                           LOAD UART_data, character_a
                           CALL send_to_UART
                           LOAD UART_data, character_u
                           CALL send_to_UART
                           CALL send_t
                           LOAD UART_data, character_h
                           CALL send_to_UART
                           CALL send_space
                           LOAD UART_data, character_P
                           CALL send_to_UART
                           CALL send_a
                           LOAD UART_data, character_g
                           CALL send_to_UART
                           CALL send_e
                           CALL send_CR
                           RETURN
                           ;
                           ;
                           ;
                           ; Send carriage return, 'OK' and carriage return to the UART
                           ;
                  send_OK: CALL send_CR
                           LOAD UART_data, character_O
                           CALL send_to_UART
                           LOAD UART_data, character_K
                           CALL send_to_UART
                           CALL send_CR
                           RETURN
                           ;
                           ;
                           ; Send 'scratchpad' to the UART
                           ;
          send_scratchpad: CALL send_s
                           CALL send_c
                           CALL send_r
                           CALL send_a
                           CALL send_t
                           CALL send_c
                           LOAD UART_data, character_h
                           CALL send_to_UART
                           LOAD UART_data, character_p
                           CALL send_to_UART
                           CALL send_a
                           CALL send_d
                           RETURN
                           ;
                           ;
                           ; Send 'secret' to the UART
                           ;
              send_secret: CALL send_s
                           CALL send_e
                           CALL send_c
                           CALL send_r
                           CALL send_e
                           CALL send_t
                           RETURN
                           ;
                           ;
                           ; Send 'Byte' to the UART
                           ;
                send_Byte: LOAD UART_data, character_B
                           CALL send_to_UART
                           LOAD UART_data, character_y
                           CALL send_to_UART
                           CALL send_t
                           CALL send_e
                           RETURN
                           ;
                           ;
                           ; Send 'Read' to the UART
                           ;
                send_Read: LOAD UART_data, character_R
                           CALL send_to_UART
                           CALL send_e
                           CALL send_a
                           CALL send_d
                           RETURN
                           ;
                           ;
                           ; Send 'Write' to the UART
                           ;
               send_Write: LOAD UART_data, character_W
                           CALL send_to_UART
                           CALL send_r
                           LOAD UART_data, character_i
                           CALL send_to_UART
                           CALL send_t
                           CALL send_e
                           RETURN
                           ;
                           ;
                           ; Send 'Pass' to the UART
                           ;
                send_Pass: LOAD UART_data, character_P
                           CALL send_to_UART
                           CALL send_a
                           CALL send_s
                           CALL send_s
                           CALL send_CR
                           RETURN
                           ;
                           ;
                           ; Send 'Fail' to the UART
                           ;
                send_Fail: LOAD UART_data, character_F
                           CALL send_to_UART
                           CALL send_a
                           LOAD UART_data, character_i
                           CALL send_to_UART
                           LOAD UART_data, character_l
                           CALL send_to_UART
                           CALL send_CR
                           RETURN
                           ;
                           ;
                           ; Send 'address=' to the UART
                           ;
             send_address: CALL send_CR
                           CALL send_a
                           CALL send_d
                           CALL send_d
                           CALL send_r
                           CALL send_e
                           CALL send_s
                           CALL send_s
              send_equals: LOAD UART_data, character_equals
                           CALL send_to_UART
                           RETURN
                           ;
                           ;
                           ; Send 'data' to the UART
                           ;
                send_data: CALL send_CR
                           CALL send_d
                           CALL send_a
                           CALL send_t
                           CALL send_a
                           RETURN
                           ;
                           ;
                           ; Send 'E/S=' to the UART
                           ;
                  send_ES: CALL send_CR
                           LOAD UART_data, character_E
                           CALL send_to_UART
                           LOAD UART_data, character_divide
                           CALL send_to_UART
                           LOAD UART_data, character_S
                           CALL send_to_UART
                           JUMP send_equals
                           ;
                           ;
                           ; Send 'code=' to the UART
                           ;
                send_code: CALL send_c
                           LOAD UART_data, character_o
                           CALL send_to_UART
                           CALL send_d
                           CALL send_e
                           JUMP send_equals
                           ;
                           ;
                           ; Send 's/n=' to the UART
                           ;
                  send_sn: CALL send_s
                           LOAD UART_data, character_divide
                           CALL send_to_UART
                           LOAD UART_data, character_n
                           CALL send_to_UART
                           JUMP send_equals
                           ;
                           ;
                           ; Send 'crc=' to the UART
                           ;
                 send_crc: CALL send_c
                           LOAD UART_data, character_r
                           CALL send_to_UART
                           CALL send_c
                           JUMP send_equals
                           ;
                           ;
                           ;
                           ; Send 'mac=' to the UART
                           ;
                 send_mac: LOAD UART_data, character_m
                           CALL send_to_UART
                           CALL send_a
                           CALL send_c
                           JUMP send_equals
                           ;
                           ;
                           ;**************************************************************************************
                           ; Interrupt Service Routine (ISR)
                           ;**************************************************************************************
                           ;
                           ; Interrupts are not used in this design. This is a place keeper only.
                           ;
                           ADDRESS 3FE
                      ISR: RETURNI ENABLE
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
