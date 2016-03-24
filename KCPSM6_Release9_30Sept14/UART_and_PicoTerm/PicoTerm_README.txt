
© Copyright 2012-2014, Xilinx, Inc. All rights reserved.
This file contains confidential and proprietary information of Xilinx, Inc. and is
protected under U.S. and international copyright and other intellectual property laws.

Disclaimer:
  This disclaimer is not a license and does not grant any rights to the materials
  distributed herewith. Except as otherwise provided in a valid license issued to you
  by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
  ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
  WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
  TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
  PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
  negligence, or under any other theory of liability) for any loss or damage of any
  kind or nature related to, arising under or in connection with these materials,
  including for any direct, or any indirect, special, incidental, or consequential
  loss or damage (including loss of data, profits, goodwill, or any type of loss or
  damage suffered as a result of any action brought by a third party) even if such
  damage or loss was reasonably foreseeable or Xilinx had been advised of the
  possibility of the same.

CRITICAL APPLICATIONS
  Xilinx products are not designed or intended to be fail-safe, or for use in any
  application requiring fail-safe performance, such as life-support or safety devices
  or systems, Class III medical devices, nuclear facilities, applications related to
  the deployment of airbags, or any other applications that could lead to death,
  personal injury, or severe property or environmental damage (individually and
  collectively, "Critical Applications"). Customer assumes the sole risk and
  liability of any use of Xilinx products in Critical Applications, subject only to
  applicable laws and regulations governing limitations on product liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES. 



-------------------------------------------------------------------------------------------------
PicoTerm v1.97 
-------------------------------------------------------------------------------------------------


           ____  _         _____
          |  _ \(_) ___ __|_   _|__ _ __ _ __ ____
          | |_) | |/ __/ _ \| |/ _ \ '__| '_ ` _  \ 
          |  __/| | (_| (_) | |  __/ |  | | | | | | 
          |_|   |_|\___\___/|_|\___|_|  |_| |_| |_| 




11th April 2014

Ken Chapman - Xilinx Ltd - email:chapman@xilinx.com


PicoTerm is primarily a simple PC based terminal ideally suited for communication with PicoBlaze 
based designs that utilise the UART macros connected to a USB/UART port on a development 
board or evaluation kit. However, given that PicoTerm is a simple terminal that can be used to
communicate with any 'COM' port it could be used with virtually any hardware and design.

The primary motivation for the development of PicoTerm was to provide a quick and reliable way 
to establish a working connection with a PicoBlaze based UART design. Whilst this should be 
easy to achieve with any terminal application, correctly setting all the communication and 
ASCII options often makes this a challenge. PicoTerm has been pre-configured to match with the 
parameters required for a PicoBlaze/UART designs and has a default BAUD rate of 115200. This 
means that in most cases only the COM port needs to be specified and it even helps to make 
that easier to do.

PicoTerm also has some features that you would not expect to find with a normal terminal. These 
special features are described later in this document and will hopefully appeal to users of 
PicoBlaze for fun, education or serious applications. The 'PicoTerm_routines.psm' file 
provided with PicoTerm contains a set of KCPSM6 routines with descriptions ready to be used with
PicoTerm. What will you use the virtual 7-Segment Display for? 

   
Summary of PicoTerm Features
----------------------------

   - Easy setup
   - 1.6:1 aspect ratio (47 lines of 144 characters)
   - 8 text colours
   - Virtual 7-Segment Display (4-Digits)
   - Virtual LED Display (8 Red + 8 Amber + 8 Green)
   - Virtual Switches Window (16-Switches)
   - 256 x 256 graphic display 
   - Date and Time information
   - Random numbers
   - Writing log files
   - Reading text files


In this file
------------

System Requirements 
Usage
  Quick Start Method                             <- This is all you really need  
  How To Find The COM Port Number                <- to start using PicoTerm 
  Closing PicoTerm
  Opening PicoTerm with command line options
PicoTerm Features
  Control Codes (Characters)
  Special Features and Control 
    Escape Sequences
Device Control Strings
  'Ping' Sequences
  Time String Sequence
  Time Value Sequence
  Date String Sequence
  Date Value Sequence
  Pseudo Random Number Sequence
  Opening and closing a LOG file
  Hide DCS Transactions Window
  PicoTerm Application Control
  Virtual LED Display
  Virtual 7-Segment Display
  Virtual Switches
  Graphic Display
  Reading Text Files
Invalid Characters and Control Sequences
BAUD Rates and Character Rates


-------------------------------------------------------------------------------------------------
System Requirements 
-------------------------------------------------------------------------------------------------

Windows-XP or Windows-7 Operating System.

A 'COM' port to communicate with - This appears to be obvious but do remember that when using a 
                                   USB/UART connection a driver may need to be installed to 
                                   provide you with a 'virtual COM port'. You also need to have 
                                   the hardware connected to your PC and power turned on.

You need to know the number of the COM port and the required BAUD rate (see 'Usage' section).



-------------------------------------------------------------------------------------------------
Usage
-------------------------------------------------------------------------------------------------


Quick Start Method
------------------

PicoTerm has the communication fixed to 8-bit, 1 Stop Bit, No Parity and No Handshake which is 
immediately compatible with the UART macros provided with PicoBlaze. This means that the only 
two variables are the number of the COM port and the BAUD rate. However, even the BAUD rate
defaults to 115200 so if you use this in your design (e.g. as set in the reference designs 
provided with the KCPSM6 version of PicoBlaze) then you don't have to worry about that either.

So if the required BAUD rate is indeed 115200 then simply execute PicoTerm and it will prompt
you to enter a COM Port number. All you need to do is enter the correct COM number. 


How To Find The COM Port Number
-------------------------------

Although the COM port number is the only piece of information that you need, this vital piece 
of information may not be so obvious especially when using a USB/UART where a virtual COM port
number has been automatically allocated by the driver. But don't worry, we can look that 
information up and it is then quick and easy way to make connection attempts with PicoTerm.

To find the possible COM port number on your PC make sure your hardware is connected and 
has the power turned on....

  Right click on 'My Computer' and select 'System Properties'
    Select the 'Hardware' tab.
      Click on 'Device Manager'
        Scan down the list to find 'Ports (COM & LPT)
          Click on '+' to open this section and review COM port numbers.

   For example, a Xilinx Evaluation Kit such as the VC707 board will show something like...
    
      Silicon Labs (CP210x USB to UART Bridge (COM13)   

   Hint - Temporarily disconnecting the USB cable connected to a USB/UART port will typically
          cause the COM port list in the 'Device Manager' to update so you can see which COM 
          port disappears and reappears as you unplug and reconnect it.    


Having entered a COM port number into PicoTerm, it will attempt to open that port. If it is 
unable to open that port then it will tell you. It may be that you specified an invalid port 
number but you should also remember to check that you have no other applications open that are 
already accessing the same port before trying again. 

When a COM port is opened successfully then a message similar to the following will be displayed.

   COM13 is open for communication at 115200 baud.

Then as soon as anything is received from that port, or any key is pressed on the keyboard, the
screen will automatically clear and start displaying any received characters. So don't expect 
to see the message above if your hardware is transmitting information as you connect (it will
be obvious that it is working anyway!).



Closing PicoTerm
----------------

To close PicoTerm press the 'Esc' key or close the window. Although no issues have been 
encountered when simply closing the PicoTerm window, using the 'Esc' key is preferred as it 
does result in a definitive closing of the COM port at the end of the session.

The application (e.g. PicoBlaze) can also issue a 'Device Control String' (DCS) forcing
PicoTerm to close (full description later in this file).



Opening PicoTerm with command line options
------------------------------------------

There are three optional command line options available. 

   PicoTerm -c<port> -b<baud> -w

You can invoke PicoTerm from a command line in a 'Command Prompt' window or within a Batch
file. However, it is probably easier to create a PicoTerm shortcut (or several shortcuts) 
and edit the properties. 

How to create a short cut and edit its properties...
   Locate 'PicoTerm.exe' in Explorer.
     Right click on 'PicoTerm.exe' and select 'Create Shortcut'. 
       This should make a shortcut in the same directory.
       In Win7 the file name is called 'PicoTerm.exe - Shortcut'.
       Note that the icon has a small arrow inside a white box on it.
          If you wish, modify the name of the shortcut (e.g. 'PicoTerm for COM13').
            Then Right click on the shortcut and select 'Properties'.
               Append the required options to the 'Target'.
               e.g. Target:  C:\utilities\PicoTerm\PicoTerm.exe -c13 -b9600 -w 
                  If you want the shortcut on your desktop then simply drag the icon to it.

Valid command line options...

   -c<port>
 
   This option is useful when you always want to open the same COM port. Providing you specify 
   a COM port which is accessible (i.e. make sure any USB/UART bridge is connected and powered) 
   then your PicoTerm session will start immediately. 

   -b<baud>

   As previously explained, PicoTerm defaults to a BAUD rate of 115200. However, PicoTerm
   can support the following BAUD rates when specified using this option.
     1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800 and 921600. 
   Note that not all COM ports (real or virtual) support all of these rates. Also be aware 
   that higher BAUD rates don't necessarily mean high average data rates will be achieved.
   Please take a while to read the 'BAUD Rates and Character Rates' section later in this 
   document if you anticipate the transmission of reception of significant quantities of data.

   -w

   This option instructs PicoTerm to open a LOG file in the same directory in which the 
   PicoTerm executable (PicoTerm.exe) is located. All visible characters displayed in the
   main terminal window will also be written to the LOG file. The LOG file is automatically 
   given a name containing the date and time consistent with when it was opened. For example,
   'PicoTerm_08May2013_154530.txt' is a LOG file opened at 15:45:30 on the 8th May 2013. 
   The writing of LOG files can also be controlled by Device Control Strings (DCS). Please
   see 'Opening and closing a LOG file' later in this document for details.


   Examples

     PicoTerm -c5                     Open COM5 with default baud rate of 115200  

     PicoTerm -c 13                   Open COM13 with default baud rate of 115200  

     PicoTerm -c13 -b9600             Open COM13 with baud rate of 9600  

     PicoTerm -b9600                  Set baud rate to 9600 but still prompt for port number.   

     PicoTerm -w                      Write a LOG file but still prompt for port number. 

     PicoTerm -c13 -w                 Open COM13 with baud rate of 115200 and write a LOG file.  

   
-------------------------------------------------------------------------------------------------
PicoTerm Features
-------------------------------------------------------------------------------------------------

PicoTerm is first and foremost a simple terminal application but even as a basic terminal it does
incorporate some features that make it more compatible with typical PicoBlaze applications as 
well as for general use.

Wide display with 1.6:1 aspect ratio - Fits well on most landscape monitors and supports 47 lines 
of 144 characters. As with most applications, the physical window size can be adjusted by 
dragging the borders with your mouse but the active terminal size remains 144 x 47 characters.
No characters are displayed once the end of a line has been reached (i.e. line wrapping has been
deliberately prevented from occurring) but will automatically scroll. 


Control Codes (Characters)
--------------------------

The following commonly used control codes (characters) are supported...

'CR'                    - Carriage return with automatic Line Feed with. Note that this avoids
(0D hex = 13)             the requirement for Line Feed characters (0A hex = 10) to be 
Carriage Return           transmitted (except for special circumstances) which helps to keep
                          PicoBlaze programs smaller and easier to develop. Whilst other 
                          terminals can support this automatic line feed functionality it can 
                          often be difficult to find an ASCII setup option to enable it and your
                          display can be a real mess until you do!

'LF' Line Feed          - Feeds a new line but the cursor remains at the same position
(0A hex = 10)             along the new line as it was on the previous line.
Line Feed

'VT'                    - Moves cursor up one line. Note that the cursor cannot move up if
(0B hex = 10)             it is already located on the top line of the visible screen. 
Vertical Tab              (i.e. the cursor has to have space to move up into, it will not 
                          cause the display to scroll downwards within the visible screen).

'BS' or 'DEL'           - Moves the cursor one position to the left and deletes any character 
(08 hex = 8)              previously in that position. If the cursor is already at the start 
(7F hex = 127)            of a line then any character at the start of the line will be 
Back Space or Delete      deleted and the cursor will not move (i.e. start of the current line).
                          
'HT'                    - Advances the cursor to the start of the next column automatically 
(09 hex = 9)              clearing any previously displayed characters between the current 
Horizontal Tab            cursor position and its new position. Each column is 8 characters 
                          wide so the display width of 144 characters is exactly 18 columns.

'BEL' (07 hex = 7)      - Will make a short sound (providing your speaker is turned on!).

'NUL' (00 hex = 0)      - This does nothing at all!


  Hint - CR, LF, VT, BS, DEL, HT, BEL and NUL are predefined constants in the KCPSM6 assembler.

All other control codes (i.e. other codes in the range 01 to 1F hex) are automatically replaced 
with a '*' character. The display of this visible character makes it easier to observe and 
debug applications during development. (See also 'Invalid Characters and Control Sequences'
later in the document).



Special Features and Control 
----------------------------

The application (e.g. PicoBlaze) is able to control the main PicoTerm terminal window and 
to open and control a variety of independent features such as virtual LEDs and Switches. 
A selection of 'Escape Sequences' and 'Device Control Strings' (DCS) enable the application
to exert control over PicoTerm features whilst not being displayed as characters in their 
own right (i.e. in much the same way that a 'CR' control character starts a new line but 
is itself invisible). 

The remainder of this document describes each of the features available and the sequences used
to control them. The scale of the documentation may appear a little daunting at first but the
majority of features are actually straightforward to use and examples are provided in the 
PicoBlaze for Spartan-6, Virtex-6 and 7-Series (KCPSM6) package. Remember that everything 
beyond this point is optional but it is very much hoped that you will enjoy using the special
features available and that they will enhance your projects.

As with most technology, it is possible to encounter difficulties especially when using the 
more advanced features. This document ends with two sections to help you when developing 
applications using the special features. The first is called 'Invalid Characters and 
Control Sequences' and explains what PicoTerm will do if you should make a mistake and how it
tries to be as helpful as it can under those circumstances. The second section is called 'BAUD 
Rates and Character Rates' which you are advised to read if you anticipate the use of 
prolonged periods of communication at relatively high data rates such as when writing or reading
information to or from files on your PC.



-------------------------------------------------------------------------------------------------
Escape Sequences
-------------------------------------------------------------------------------------------------


PicoTerm supports the following 'Escape Sequences'....

  Move cursor to HOME position (upper-left of screen) and set text colour to black.

    'ESC' (1B hex = 27)
    '['   (5B hex = 91)
    'H'   (48 hex = 72)

  Clear screen, move cursor to HOME position and set text colour to black.

    'ESC' (1B hex = 27)
    '['   (5B hex = 91)
    '2'   (32 hex = 50)
    'J'   (4A hex = 74)
 
  
  Set the colour for the display of characters that follow.
 
    'ESC'    (1B hex = 27)
    '['      (5B hex = 91)
    colour   (Where 'colour' is one of the following values)
             (  1E hex = 30'd   Black                      )      
             (  1F hex = 31'd   Red                        )  
             (  20 hex = 32'd   Green                      ) 
             (  21 hex = 33'd   Yellow                     ) 
             (  22 hex = 34'd   Blue                       ) 
             (  23 hex = 35'd   Magenta                    ) 
             (  24 hex = 36'd   Cyan                       ) 
             (  25 hex = 37'd   Grey                       )
             (  26 hex = 38'd   White                      )


  Hint - ESC is predefined constant in the KCPSM6 assembler.

  Hint - 'White' is the background colour so it cannot be seen! It may be used to clear 
         previously displayed text but spaces (20 hex) in any colour would do this as well.


-------------------------------------------------------------------------------------------------
Device Control Strings
-------------------------------------------------------------------------------------------------


PicoTerm also implements some 'Device Control Strings' (DCS) that can be useful in PicoBlaze
applications. When PicoTerm receives one of the DCS sequences then it will perform a special 
operation. Some DCS commands will result in PicoTerm responding with another Device Control 
String containing appropriate information such as the time on the PC whilst others are used 
to open and control separate windows such as the virtual 7-Segment digits display.

When a DCS is used to facilitate the transfer of information between PicoBlaze (or similar) 
and the PC (e.g. a request for time) then a 'PicoTerm DCS Transactions' window will automatically
open and display a message confirming the request and information exchanged. This ensures 
that all communications with PicoTerm results in something visible on the PC screen which is 
often reassuring as well as useful during PicoBlaze (or similar) code development. 

The contents of a Device Control String may contain bytes of any value (i.e. data in the range 
00 to FF hex). The following characters that begin and end all 'Device Control Strings' have 
codes that are also beyond the normal 7-bit ASCII range. 
  'DCS' = 'Device Control String' character (90 hex = 144).
   'ST' = 'String Terminator' character (9C hex = 156).

Hint - DCS and ST are predefined constants in the KCPSM6 assembler.

Hint - When PicoTerm responds with a Device Control String it always starts with the same 
       character that was used to make the request. Although PicoBlaze (or similar) would have
       made the request, and therefore should know what response to expect, it is often convenient
       to implement a DCS handing routine that can operate fairly independently. Therefore, having
       the first character of the response string to identify the meaning of the information can
       be very useful for such a handling routine. Note that the 'ping' sequence is a special 
       case (see description below). 

Hint - Even if PicoTerm makes a DCS request for some information, the PicoTerm DCS response  
       may not be the very next thing waiting to be read from the UART receiver. Other keyboard
       characters may still be waiting in the receiver FIFO buffer and need to be processed 
       first. 

Note that PicoTerm will always transmit a complete DCS response. Keyboard entries can be made 
during the time that a DCS request and response is taking place but keyboard characters will 
always be transmitted either before or after the DCS response (i.e. will never become part 
of the response string).


Summary of 'Device Control Strings' (DCS) available in this version (full details below).

D - Read Date string
d - Read Date value
G - Plot point in graphic display
g - Plot character in graphic display
h - Hide transaction window
L - LED display
N - Request a Pseudo Random Number
P - 'Ping' with PicoTerm version request
p - 'Ping'
q - Force PicoTerm to restart
Q - Force PicoTerm application to quit
R - Read default text file
r - Read any text file with auto prompt
S - Read switches
s - Set switches
T - Read Time string
t - Read Time value
V - Fill a box in the graphic display
v - Draw a line in the graphic display
W - Open a LOG file
w - Close the LOG file
7 - Seven segment display




  'Ping' Sequences
  ----------------

    A 'Ping' sequence provides a simple way for PicoBlaze (or similar) to determine if it 
    is communicating with PicoTerm rather than a different terminal. It is a good idea to 
    check that PicoTerm is being used if your application goes on to use any of its special 
    features provided. There are two forms of 'Ping' request which are shown below (note 
    the specification of either lower case 'p' or upper case 'P').

      Simple 'Ping'                    'Ping' with version 
      Request to PicoTerm              Request to PicoTerm


        'DCS'   (90 hex = 144)          'DCS'   (90 hex = 144)
        'p'     (50 hex = 80 )            'P'   (70 hex = 112)
        'ST'    (9C hex = 156)           'ST'   (9C hex = 156)

    Depending of the type of 'Ping' request that PicoTerm receives, it will display 'Ping!' 
    or 'Ping! v1.93' in the 'PicoTerm DCS Transaction' window. It will then respond with 
    the appropriate DCS sequence shown below.

      Simple 'Ping'                     'Ping' with version 
      Response from PicoTerm            Response from PicoTerm

       'DCS'                            'DCS'      
       'P'    (upper case)              'p'   (lower case)
       'ST'                             'v'   version text string
                                        '1'    e.g. v1.93
                                        '.'
                                        '9'
                                        '3'
                                        'ST'

    Following the 'DCS', the first character of the response contains the opposite case of 
    letter to that used in the request. For example, the simple 'Ping' request contains a 
    lower case 'p' (70 hex = 112) and the response contains an upper case 'P' (50 Hex = 80).
    This case reversal ensures that a simple echo or loop-back connection cannot be confused 
    with a connection to PicoTerm. All other DCS responses made by PicoTerm begin with the 
    exact same character used in the request so this is only a special case for 'Ping'.

    The set of special features provided by PicoTerm is increasing over time. When an 
    application requires a specific feature to be present, the 'Ping' with version 
    request enables the application to verify that PicoTerm is connected and to verify that
    it is of a suitable version. The response contains the version in the form of a 5-character 
    ASCII text string. Note that the version request was introduced in PicoTerm v1.93 so 
    earlier versions will report that a 'P' request is an 'Invalid string!'.



  Time String Sequence
  --------------------

    Request to PicoTerm


    'DCS'     (90 hex = 144)
    'T'       (54 hex = 84 )   upper case 'T'
    'ST'      (9C hex = 156)

    PicoTerm response is a string of 8 ASCII characters describing the current time
    on the PC. The time is 24-hour with an hour value range of '00' to '23'.
    For example...   14:27:58 

    'DCS'
    'T'  
    '1'
    '4'
    ':'
    '2'
    '7'
    ':'
    '5'
    '8'
    'ST' 


  Time Value Sequence
  -------------------

    Request to PicoTerm

    'DCS'     (90 hex = 144)
    't'       (74 hex = 116)   lower case 't'
    'ST'      (9C hex = 156)

    PicoTerm response is a series of 3 byte values representing the current time on the 
    PC in hours, minutes and seconds. 

    'DCS'
    't'  
    hours     (byte value 00 to 17 hex = 0 to 23)
    minutes   (byte value 00 to 3B hex = 0 to 59)
    seconds   (byte value 00 to 3B hex = 0 to 59)
    'ST' 


  Date String Sequence
  --------------------

    Request to PicoTerm

    'DCS'     (90 hex = 144)
    'D'       (44 hex = 68 )   upper case 'D'
    'ST'      (9C hex = 156)

    PicoTerm response is a string of 11 ASCII characters describing the current date 
    on the PC. The day is always represented by 2 characters, the month by 3 characters
    and the year by 4 characters. For example...   02 May 2012

    'DCS'    
    'D'
    '0'
    '2'
    ' '
    'M'
    'a'
    'y'
    ' '
    '2'
    '0'
    '1'
    '2'
    'ST' 


  Date Value Sequence
  -------------------

    Request to PicoTerm

    'DCS'     (90 hex = 144)
    'd'       (64 hex = 100)   lower case 'd'
    'ST'      (9C hex = 156)

    PicoTerm response is a series of 3 byte values representing the current date on the 
    PC as year, month and day.  

    'DCS'  
    'd'  
    year      (byte value 00 to 63 hex = 0 to 99)   e.g. '12' for the year 2012.
    month     (byte value 01 to 0C hex = 1 to 12)
    day       (byte value 01 to 1F hex = 1 to 31)
    'ST' 



  Pseudo Random Number Sequence
  -----------------------------

    The following sequence includes a 24-bit value (3-bytes) which defines the maximum value 
    which the random number returned by PicoTerm can be.

    'DCS'            (90 hex = 144)
    'N'              (4E hex = 78 )
    max(0)           (maximum value[7:0])
    max(1)           (maximum value[15:8])
    max(2)           (maximum value[23:16])
    'ST'             (9C hex = 156)

    PicoTerm will respond with the following sequence containing a 24-bit (3-byte) pseudo random
    number in the range 0 up to, and including, the maximum value specified during the request. 

    'DCS'      
    'N'
    random(0)        (random number[7:0])
    random(1)        (random number[15:8])
    random(2)        (random number[23:16])
    'ST'        

    A message will be displayed in the 'PicoTerm DCS Transaction' indicating that a request was 
    received and showing both the maximum value and random number returned (as 6-digit hex values).
    For example, the message 'Random (0003FF) -> 000142' indicates that the maximum value 
    specified in the request was 0003FF hex and the random number generated and returned on 
    this occasion was 000142 hex. 


    Analysis of a significant quantity of random numbers returned by PicoTerm would reveal that
    their values are evenly distributed across the 0 to 'maximum value' range.

    Hint - Specifying an appropriate 'maximum value' ensures that ALL responses will be valid
           and suitable for immediate use in your application.  

    Hint - Exercise great care if you request a larger number than your application actually 
           needs. Reducing a series of larger values to make a series of smaller values can 
           easily result in an uneven distribution of values. This is why the DCS request 
           allows you to define a 'maximum value' and it is strongly recommended that you 
           use this feature.

    Hint - Requesting a value within the full 24-bit range ('DCS', 'N', 255, 255, 255 'ST') can 
           be used to obtain three random byte values each with the range 0 to 255 and the 
           property of even distribution. This only works because EVERYTHING is consistent with
           a power of two but again care should be taken not to extract smaller values from 
           each byte unless out of range values are discarded. 




  Opening and closing a LOG file
  ------------------------------

    PicoBlaze (or similar) can use the following DCS sequence to instruct PicoTerm to open a
    LOG file. Once a LOG file is open, all visible characters displayed in the main terminal 
    window will also be written to the LOG file. Whilst the LOG file cannot reflect the full 
    effect of all control characters and escape sequences, it attempts to provide a clean 
    and logical representation which is typically ideal for capturing automatically generated
    information. 

    Request PicoTerm to open a LOG file

    'DCS'     (90 hex = 144)
    'W'       (57 hex = 87 )   upper case 'W'
    'ST'      (9C hex = 156)

    When PicoTerm receives this sequence it will open a LOG file in the same directory in which 
    the PicoTerm executable (PicoTerm.exe) is located. PicoTerm automatically names the LOG file 
    'PicoTerm' followed by a date and time stamp (consistent with when it was opened) and with a 
    '.txt' file extension. For example, 'PicoTerm_08May2013_154530.txt' is the name of a LOG 
    file opened at 15:45:30 on the 8th May 2013.

    An 'Opening LOG file' message will be displayed in DCS Transactions window when a LOG file 
    is opened. The file name and location will also be displayed in the DCS Transactions window.

    Note that if the open LOG file sequence is received whilst a LOG file is already open then 
    PicoTerm will automatically close the current file and open a new one.

    Request PicoTerm to close the LOG file

    'DCS'     (90 hex = 144)
    'w'       (77 hex = 119)   lower case 'w'
    'ST'      (9C hex = 156)

    When PicoTerm receives this sequence it will close the LOG file. This will be confirmed by a
    by a 'Closing LOG file' message in the is displayed in DCS Transactions window. If this 
    sequence is received whilst no LOG file is currently open then an 'Attempt to close a LOG file 
    that is not open!' message will be displayed.


  Hide DCS Transactions Window
  ----------------------------

    The messages displayed in the 'DCS Transactions Window' can be very useful during the 
    development of an application. They show you the values being sent back to you in 
    response to your requests and will also help you to see when mistakes have been made.
    However, this window can be distracting once an application is fully developed and stable
    so this sequence can be used to close the 'DCS Transactions Window' or to prevent it from 
    opening in the first place. PicoTerm will not issue a DCS response to this request.

    'DCS'     (90 hex = 144)
    'h'       (68 hex = 104)
    'ST'      (9C hex = 156)


  PicoTerm Application Control
  ----------------------------

    The DCS shown below can be used to force the PicoTerm application on the PC to close (Quit).
    One situation in which this may be used is when a design uses PicoTerm to display various 
    information during initialisation and then automatically closes PicoTerm if everything
    works correctly or stays open to display an initialisation error.

    'DCS'     (90 hex = 144)
    'Q'       (51 hex = 81 )   upper case 'Q'
    'ST'      (9C hex = 156)

    The following DCS effectively forces the PicoTerm application to restart (a soft quit). The 
    main window will remain open but the screen will be cleared and the cursor set in the HOME
    position (equivalent to the '[2J' escape sequence). Any PicoTerm feature windows that are 
    open will be closed (e.g. virtual LED window). It can be useful to use this DCS during 
    code development.

    'DCS'     (90 hex = 144)
    'q'       (71 hex = 113)   upper case 'q'
    'ST'      (9C hex = 156)



Virtual LED Display
-------------------

The PicoTerm Virtual LED Display is a pop-up window containing 24 virtual LEDs. There are 8 red,
8 yellow (amber) and 8 green LEDs arranged in 3 rows as shown below.

         
                      7   6   5   4   3   2   1   0
         
             Red      O   O   O   O   O   O   O   O
             Amber    O   O   O   O   O   O   O   O
             Green    O   O   O   O   O   O   O   O
         

The virtual display is opened and updated using a 'Device Control String' (DCS) sequence. When 
PicoTerm receives the first virtual LED display DCS sequence it will open the virtual LED window
with the specified LEDs 'turned on'. Subsequent virtual LED display DCS sequences will modify 
the LEDs to reflect the new control values provided. Note that PicoTerm does not transmit 
a DCS sequence back to the COM port.

The DCS sequence for the virtual LED display is as follows (please read the 'Device Control 
Strings' section above if you are unfamiliar with this concept)...

    'DCS'                  (90 hex = 144)
    'L'                    (4C hex = 76 )
    RED_control_byte    
    YELLOW_control_byte    
    GREEN_control_byte    
    'ST'                   (9C hex = 156)

The virtual LEDs of each colour are controlled by the corresponding bits contained in each of 
control bytes. For example the least significant bit of 'GREEN_control_byte' will control the 
virtual LED in the lower right hand corner of the display.




Virtual 7-Segment Display
-------------------------

The PicoTerm Virtual 7-Segment Display is a pop-up window containing a virtual 4-digit, 
7-segment display. The digits and their segments are identified below.


              Digit 3             Digit 2             Digit 1             Digit 0

                 a                   a                   a                   a
                ___                 ___                 ___                 ___
              |     |
            f |     | b         f |     | b         f |     | b         f |     | b 
              |  g  |             |  g  |             |  g  |             |  g  |
                ___                 ___                 ___                 ___
    
              |     |             |     |             |     |             |     |
            e |     | c         e |     | c         e |     | c         e |     | c
              |  d  |             |  d  |             |  d  |             |  d  |
                ___   p            ___    p             ___   p             ___   p


The virtual display is opened and updated using a 'Device Control String' (DCS) sequence. When 
PicoTerm receives the first virtual display DCS sequence it will open the window and display 
the digits with the specified segments 'turned on'. Subsequent virtual display DCS sequences 
will modify the display to reflect the new control values provided. Note that PicoTerm does 
not transmit a DCS sequence back to the COM port.

The DCS sequence for the virtual 7-Segment display is as follows (please read the 'Device Control 
Strings' section above if you are unfamiliar with this concept)...

    'DCS'                         (90 hex = 144)
    '7'                           (37 hex = 55 )
    digit0_segment_control_byte    
    digit1_segment_control_byte    
    digit2_segment_control_byte    
    digit3_segment_control_byte    
    'ST'                          (9C hex = 156)

The segments of each digit are controlled by the bits contained in the control bytes. Each 
digit has 7 segments and a decimal point and a segment will be 'turned on' when the corresponding
bit of the control byte is High (1).

           Segment  Bit
        
              a      0
              b      1                  
              c      2
              d      3
              e      4
              f      5
              g      6
              p      7   decimal point


Hint - See the 'nibble_to_7seg' routine provided in the 'PicoTerm_routines.psm' file.




Virtual Switches
----------------

PicoTerm Virtual Switches is a pop-up window containing 16 virtual switches. Each switch has  
the appearance of a square black button with an embedded green LED. Clicking on a virtual 
button will toggle the state of the switch and the virtual LED will indicate the current
state, i.e. LED on means switch is turned on ('1').

        
      15  14  13  12  11  10   9   8   7   6   5   4   3   2   1   0
      
       O   O   O   O   O   O   O   O   O   O   O   O   O   O   O   O

There are two 'Device Control String' (DCS) sequences that can be used in conjunction with the 
virtual switches. The first time either sequence is received by PicoTerm the Virtual Switches 
display will be opened.

The first and most useful DCS sequence is used to read the current states of switches. If this
is also used to open the window then all 16 switches will initially be off ('0').

    Request to PicoTerm to read virtual switches

    'DCS'     (90 hex = 144)
    'S'       (53 hex = 83 )   upper case 'S'
    'ST'      (9C hex = 156)

In response to each use of the above DCS sequence, PicoTerm will respond with the following 
DCS sequence reporting the current states of all 16 switches.

    PicoTerm response

    'DCS'  
    'S'  
    switches(0)     (current states of switches[7:0])
    switches(1)     (current states of switches[15:8])
    'ST' 

Note that whilst the effect of clicking on a switch is immediately reflected by its indicator
LED, PicoTerm will only generate a DCS sequence in response to a DCS request. Hence, PicoBlaze
must issue a DCS request in order to determine the current states of the switches (this is
similar to the way in which PicoBlaze would need to read an input port to determine the current 
states of physical switches). 

In the top right of the virtual switches window is an small dot. When this dot is green it 
indicates that the current switch settings have not changed since the last DCS request and 
response occurred and implies that PicoBlaze has up to date information (of course the 
PicoBlaze program is responsible for processing and using the information correctly). When 
a virtual switch is changed the dot will become red until the time of the next DCS request. 
Hence a red dot indicates that PicoBlaze has not read the latest states of the switches.

The second DCS sequence shown below can be used to set the 16 virtual switches either when 
opening the window or during operation. PicoTerm will set the indicator LEDs on each switch as 
defined by the two byte values provided. 
    Request to PicoTerm to set virtual switches

    'DCS'           (90 hex = 144)
    's'             (73 hex = 115)   lower case 's'
    switches(0)     (new states for switches[7:0])
    switches(1)     (new states for switches[15:8])
    'ST'            (9C hex = 156)

PicoTerm does not generate a DCS response to this sequence because the state of the switches 
is known.



Graphic Display
---------------

This display contains a grid of 256 x 256 points allowing simple graphs, shapes and patterns 
to be plotted using 9 colours. Characters can also be displayed enabling graphs to be annotated 
with scales and labels etc.

There are four 'Device Control String' (DCS) sequences available for use with the graphic 
display. The 'PicoTerm Graphic Display' pop-up window will automatically open the first time 
any one of these sequences is used.

  G - Plot a single point.
  v - Draw a line between two points.
  V - Fill the box defined by two points. 
  g - Display a character at a specified position.


Each sequence is described in greater detail below. However, all sequences require one or two 
points to be specified as X-Y coordinates. Although a 256 x 256 display does not provide the 
kind of high resolution we have become used to these days, the primary objective of PicoTerm 
is to be easy to use. With that in mind, the X-Y coordinates are simple byte values (00 to FF 
hex (0'd to 255'd) which are a natural fit with both UART communication and PicoBlaze.   

          Y |(0,255)    (255,255)          
            |                              As illustrated, the lower-left corner is the  
            |       (X,Y)                  display origin (0,0) is the lower-left corner     
            |                              which feels natural and easy to work with. 
            |(0,0)        (255,0)
             -------------------- 
                                X


Likewise, all sequences require you to specify the colour of the object to be displayed. 
The following values define each of the 9 colours available. 

     1E hex = 30'd   Black (also used if colour value provided is outside normal range) 
     1F hex = 31'd   Red        
     20 hex = 32'd   Green      
     21 hex = 33'd   Yellow     
     22 hex = 34'd   Blue       
     23 hex = 35'd   Magenta    
     24 hex = 36'd   Cyan       
     25 hex = 37'd   Grey 
     26 hex = 38'd   White 

  Hint - This is the same colour palette available for text in the main PicoTerm window.
         In this case, 'white' can really be useful because it will be visible when plotting
         in an area previously set to a different colour. Alternatively, you can think in 
         terms of White allowing you to 'clear' points. Regardless, 'white' soon becomes a 
         useful colour in the display window.


 
  Sequence to set a single point
  ------------------------------

    'DCS'     (90 hex = 144)
    'G'       (47 hex = 71 )   upper case 'G'
     x              
     y      
     colour
    'ST'      (9C hex = 156)
     
  This sequence can be used to set any of the 65,536 points to one of the 9 colours. It is 
  typically used when plotting simple graphs but its simplicity actually provides you with 
  the flexibility to do anything.

  It is worth noting that when operating with a default baud rate of 115200, it will take 
  ~521us to transmit this 6-character DCS sequence. This implies a plotting rate of 1,920 
  points per second. Hence a simple line graph consisting of 256 points can be plotted in 
  133ms which is reasonable. However, attempting to set all 65,536 point (e.g. to display 
  a 256x256 image) would take over 34 seconds and generally a technique to avoid!



  Sequence to draw a line between two points.
  -------------------------------------------

    'DCS'     (90 hex = 144)
    'v'       (76 hex = 118)   lower case 'v'
     x1       Start of line (x1,y1) 
     y1
     x2       End of line (x2,y2) 
     y2
     colour
    'ST'      (9C hex = 156)

  This sequence defines the points at the start (x1,y1) and end (x2,y2) of a line. PicoTerm 
  works out the vector and sets all the points required to form a continuous line of the 
  colour specified. Although this 8-character DCS sequence will take slightly longer to 
  transmit (~694us at 115200 baud) it could set up to 256 points in one transaction and is 
  a faster way to draw lines than plotting individual points. Note that there are no 
  restrictions concerning the relative positions of the start and end points; PicoTerm will 
  draw a connecting line of whatever length and in whatever direction is needed to connect them.

  Hint - Even though vertical and horizontal lines (e.g. graph axes) are easy to plot as 
         a series of individual points, using this sequence makes plotting faster and much 
         easier to define. When plotting a graph, you may find the overall appearance is 
         improved when using short connecting lines rather than isolated points.



  Sequence to fill a box defined by two points.
  ---------------------------------------------

    'DCS'     (90 hex = 144)
    'V'       (56 hex = 86 )   upper case 'V'
     x1       First Corner (x1,y1) 
     y1
     x2       Second Corner (x2,y2) 
     y2
     colour
    'ST'      (9C hex = 156)

  This sequence defines the points at two diagonally opposite corners of a rectangular (or 
  square) box which PicoTerm will completely fill with the specified colour. As with drawing 
  lines, there are no restrictions concerning the relative positions of the two points but it 
  is generally easier to think in terms of the first point (x1,y1) being in the lower-left 
  corner and the second point (x2,y2) being in the upper-right corner.

  This sequence can dramatically improve the speed at which large areas can have all points 
  set to the same colour. For example, specifying points (0,0) and (255,255) and the colour 
  white will effectively 'clear' the entire display in one transaction (~694us at 115200 baud).

  Hint - A grey rectangle can be a good background for a graph. When presenting more than one 
         graph at a time (e.g. one at the top and another at the bottom) the grey rectangles 
         can really help define the plotting area of each.



  Sequence to display a character.
  --------------------------------
 
    'DCS'       (90 hex = 144)
    'g'         (67 hex = 103)   lower case 'g'
     x              
     y      
     colour
     character
    'ST'        (9C hex = 156)

  This sequence allows a character to be displayed at any position using any colour. There are 
  two font sizes available (small and large). The X-Y coordinates specifies the lower-left 
  corner of a small 'virtual box' which the character will occupy. 

                                                                     * * * * .
  The 'virtual box' of a large font character is 5-points            * . . . *
  wide and 7-points tall. The specified X-Y coordinate always        * . . . *    5 x 7
  defines the lower-left corner even if that point is not            * * * * .   character
  used by the character. The image on to the right illustrates       * . . . .    'box'
  the 15 points out of a possible 35 points that PicoTerm will       * . . . .
  set to the specified colour in order to display a capital 'P'.    y* . . . .
                                                                     x
           
  Small font size characters are exactly half the size of the large font size characters with 
  a 'virtual box' that is 2.5 points wide and 3.5-points tall. In practice, PicoTerm uses the 
  same 5 x 7 bit map for each character but then divides each regular point into four smaller 
  points. 

  Hint - When displaying text or a label, space small characters at 3-point intervals and large
         characters at 6-point intervals.

  Note that when each character is displayed, only the points required to form the character are
  set and all other points within the 'virtual box' will remain the same. When using the small 
  font size then only the required quarters of each regular point will be set so even the 
  remainder of a regular point will remain the same. This is equivalent to writing on a piece 
  of paper with a pen and means that labels can be added to a graph (or refreshed) without 
  obliterating all the information that has been previously plotted. 

  Hint - The above may sound natural and obvious but it is completely different to the way in
         which characters are displayed in the main PicoTerm window. Displaying a space (20 hex)
         in the main window will completely clear a previous character at the same location 
         whereas displaying a space in the graphic window has no effect at all. If you do 
         really need to clear the whole 'virtual box' of a character in the graphic window 
         then use the solid 5x7 'box' character (see later) with colour set to white.

  The 'character' value is based on standard ASCII codes and indeed values in the range 20 to 
  7E hex (32'd to 126'd) will all result in the display of the expected ASCII character. 
  However, codes in the range 00 to 1F hex (0'd to 31'd) and 7F (127'd) are traditionally 
  associated with control which is not relevant to the graphic window so some other useful 
  characters, symbols and shapes have been assigned to these codes as shown in the table below.

  A small font size character will be displayed when the code in the range 00 to 7F hex (0'd to 
  127'd). Simply add 80 hex (128'd) to the normal codes to display the character using the 
  large font size (i.e. codes in the range 80 to FF hex (128'd to 255'd) are large font). 


       Non-standard 'character' codes
      
        Hex   Dec   character
      
        00      0    edged 5x7 'virtual box'
        01      1    up arrow
        02      2    right arrow
        03      3    down arrow
        04      4    left arrow
        05      5    degrees
        06      6    micro
        07      7    pi
        08      8    ohm
        09      9    British Pound
        0A     10    Euro
        0B     11    Sigma (upper case)
        0C     12    Sigma (lower case)
        0D     13    divide
        0E     14    Hourglass
        0F     15    Bus cross
        10     16    Bus lines
        11     17    reserved (solid box)
        12     18    reserved (solid box)
        13     19    reserved (solid box)
        14     20    reserved (solid box)
        15     21    reserved (solid box)
        16     22    reserved (solid box)
        17     23    reserved (solid box)
        18     24    single point (0,0)
        19     25    single point (1,0)
        1A     26    single point (0,1)
        1B     27    single point (1,1)
        1C     28    solid 5x5 triangle (upper-left)
        1D     29    solid 5x5 triangle (lower-left)
        1E     30    solid 5x5 triangle (upper-right)
        1F     31    solid 5x5 triangle (lower-right)
        7F    127    solid 5x7 'virtual box'


  Hint - The four 'single point' characters used with a small font size enable each
         quadrant of the regular point specified in the X-Y coordinate to be set. 
         This opens the potential to implement a scheme that increases the plotting
         resolution to 512 x 512 points (262,144 virtual points).




Reading Text Files
------------------

PicoTerm provides two DCS commands that enable PicoBlaze (or similar) to read text files from 
the PC on which PicoTerm is running. Although the scheme is straightforward, it should be 
appreciated that the act of reading a text file will typically require PicoBlaze (or similar)
to receive and process a relatively high number of characters in a timely manner. It is therefore
recommended that you consider how your application will ensure that its UART receiver buffer will
always be read at a rate that ensures that it does not overflow when PicoTerm is continuously 
reading characters from the text file and transmitting them to your application.

The PicoTerm definition of a 'text file' is that it should primarily contain only characters with
ASCII codes 20 to 7E hex (32 to 126 decimal). This is all the normal visible characters including
'A' to 'Z', 'a' to 'z', '0' to '9', a space and various standard symbols. PicoTerm will also read
and transmit a carriage return (0D hex = 13 decimal) which is generally understood to mean the 
end of a line. However, if PicoTerm reads a horizontal tab (09 hex = 9 decimal) from a file it 
will automatically replace it with a space (20 hex = 32 decimal) before it is transmitted. If 
PicoTerm reads any of the other character codes it will ignore them and they will not be 
transmitted.

Both of the DCS commands read the contents of a text file and transmit them to the COM port in 
exactly the same way. The only difference between the commands is the way in which the file to 
be read is specified...

    This first DCS sequence requests PicoTerm to read a file with the name 'picoreadfile.txt'
    which must be located in the same directory as 'PicoTerm.exe'. Although this requires you 
    to have previously provided the correctly named file in the correct location, this command 
    allows your application to automatically read the file without any delay. For example, this 
    can be a good way to load a set of parameters for an application as part of an initialisation 
    procedure 

    'DCS'     (90 hex = 144)
    'R'       (52 hex = 82 )    upper case 'R'
    'ST'      (9C hex = 156)


    The second DCS sequence shown below will also request PicoTerm to read a file but this 
    command will result in PicoTerm prompting the user to 'Specify file to be read:'. The prompt 
    will appear in a new 'PicoTerm Read File' window that will pop up. Whilst this command is 
    flexible about the file to be read, waiting for the file to be specified will effectively
    cause PicoTerm to freeze and that will generally force your application to wait as well. 
    Waiting is normally acceptable but it is clearly quiet different behavior to the 'R' command.

    'DCS'     (90 hex = 144)
    'r'       (72 hex = 114)    lower case 'r'
    'ST'      (9C hex = 156)


    When specifying the file to be read...
      - Any file extension can be used (e.g. .hex or .mcs) providing the actual contents 
        of the file conform to the definition of a 'text file' as previously described.
      - By default, PicoTerm will look for the file in the same directory as that in 
        which 'PicoTerm.exe' is located.
      - The file specification may include an absolute path to the location of the file
           e.g.  C:\Designs\PicoBlaze\kc705_kcpsm6_i2c_eeprom.mcs
      - The file specification may include a path relative to the location of 'PicoTerm.exe'
           e.g.  read_files\eeprom_data_files\filter_coefficients.hex

    Hint - It is possible to paste a file specification into the 'PicoTerm Read File' window 
           using Ctrl+V which can save typing and help avoid mistakes.

 
As soon as PicoTerm has received either command it will immediately acknowledge that it is 
entering the read file mode by transmitting 'DCS' followed by 'R' or 'r' to the COM port. The 
application should then be aware that an attempt is being made to read a file. When the 'r' 
command is used there will then be a pause whilst the user specifies the file to be read.

Providing PicoTerm is able to open the file specified, each character is read and transmitted 
by PicoTerm and the application must receive and process them until the end of the file is 
reached which will be indicated by PicoBlaze transmitting an 'ST' character. Hence the normal 
complete response to a read file command is...
     'DCS', 'R' (or 'r'), 'c', 'c', 'c', 'c', 'c', 'c', ......, 'c', 'c', 'ST'
Where 'c' represents a character from the text file and clearly the number of characters in 
the response depends on the size of the file being read.

If PicoTerm is unable to locate and open the file (or the file is empty) then the response 
will be as shown below and the application should recognise this to be a failure to read
the file and take suitable actions. 
     'DCS', 'R' (or 'r'), 'ST'
           
Throughout the read file process, PicoTerm will display messages in the 'PicoTerm DCS 
Transactions' window which can be useful when developing your application. As each character
is read from a file and transmitted it will also be displayed in the 'PicoTerm Read File' 
window providing a clear indication of progress. On completion, a message is displayed in the
transactions window and the 'PicoTerm Read File' window will close automatically. 

When a file is in the process of being read, PicoTerm is still able to receive characters 
from the application but there are limitations and special cases which are important to 
understand and often key to the implementation of a successful application.

During the reading of a file, the application can only display plain text in the main terminal 
window. It is not possible to use any other Device Control Strings (DCS) or Escape sequences 
until the read command has completed (i.e. 'ST' has been received). In practice, the primary 
focus of the application should be receiving the file being read so the amount of characters 
sent for display in the terminal window should normally be limited to that of status information
using as few characters as practically possible. Remember that the 'PicoTerm Read File' window 
already indicates progress.

   Hint - A common mistake is that PicoBlaze (or similar) tries to transmit too many characters 
          to PicoTerm resulting in the buffer of its transmit UART becoming full. Then while 
          PicoBlaze waits for space to appear in the transmit buffer the buffer its UART 
          receiver overflows because it is no longer keeping up with the continuous flow of 
          characters PicoTerm is reading from the file.

If the application is unable to receive and process all the characters at the rate at which 
PicoTerm is reading and transmitting them then it is possible for the application to stop and 
start the flow by transmitting 'XOFF' and 'XON' control characters.

        'XON'   (11 hex = 17)  Also known as control character 'DC1'  
        'XOFF'  (13 hex = 19)  Also known as control character 'DC3'  

If for any reason the application would like to terminate the reading of the file early then
it simply needs to transmit a 'DCS' and PicoTerm will stop reading and transmitting characters 
from the file, display a message in the transaction window and close the 'PicoTerm Read File' 
window. PicoTerm will then continue to process the DCS command that has been started so it 
is good practice to use a valid sequence (e.g. the 'ping' sequence).  

When PicoTerm receives 'XOFF' it will stop reading and transmitting the file. PicoTerm will 
then wait until it receives 'XON' before it resumes. PicoTerm will continue to receive and 
display characters in the main terminal window so that the application can still display status
information. The 'PicoTerm Read File' window provides a visual indication of how the reading 
of the file is being interrupted (i.e. it may appear to be making slow progress or even stop 
if the is a significant time between 'XOFF' and 'XON' control codes).
 
In many cases, the need to interrupt the file read and flow of characters from PicoTerm to 
the application is related to the performance of something else in the system. For example, 
programming a FLASH memory is typically performed one 'page' at a time. A page of data 
(typically 256 or 512 bytes) can be quickly loaded into a RAM buffer but it can then take several
milliseconds for the page to program the FLASH memory cells. If the buffer in the UART receiver
is liable to overflow whilst the application is forced to wait for the FLASH memory to be ready 
then 'XOFF' and 'XON' flow control could be the solution.

When PicoTerm receives an 'XOFF' character it will immediately stop transmitting characters. 
However, there may be a quite considerable latency in the system and the application should 
expect to continue receiving characters. How many characters are received before the flow stops
really depends on the system and some experimentation is advisable to establish whether the 
buffer in the UART receiver is adequate or if it necessary to issue 'XOFF' early so that
takes effect in time. The following is an indication of where the latency can be in a system.
   a) PicoBlaze sends 'XOFF' to its UART transmitter.
   b) The UART Transmitter has a 16-character buffer so maybe there are up to 15 other 
      characters to be transmitted before the 'XOFF' is actually on its way (note the 
      application will benefit from limiting the transmission of status information when 
      reading a file).
   c) When a USB/UART bridge is used then these devices also have a buffer which may 
      be holding characters in front of the 'XOFF'.
   d) On your PC, the COM port (or virtual COM port in the case of a USB/UART bridge) 
      almost certainly has a buffer which may further delay PicoTerm receiving characters .
   e) When PicoTerm transmits characters read from the file then also pass to the COM port 
      which has a buffer. In the case of a virtual COM port it is possible that several 
      characters are queued up before transmission in a burst.
   f) A USB/UART bridge device has a buffer such that bursts of characters received from
      the USB can be transmitted by the UART.

Although the above description can make this sound like a potentially nasty problem, it is rarely
an issue in practice when a USB/UART bridge and corresponding Virtual COM port driver is being 
used. This is because the average character transmission rate is often much less than the 
BAUD rate of the UART implies. The PicoTerm default BAUD rate is 115200 and this means that a
character (start bit, 8 data bits and a stop bit) is transmitted in ~87us. This implies that 
PicoTerm could be reading and transmitting 11,520 characters per second. If you actually use 
a PC with a traditional RS232 serial port then you may actually observe a character rate close 
to this but the interaction of Virtual COM port driver with the USB/UART device typically 
results in relatively large gaps between the transmission of each character or large gaps  
between small bursts of characters. The actual character rate very much depends on the 
manufacturer of the USB/UART device and the Virtual COM port driver they provide. 

The following experimental observation have been made by reading a large text file... 

    The Spartan-6 ATLYS board has an EXAR XR21V1410 USB/UART bridge device.
      Average read rate of ~2,000 characters per second.
  
    KC705 board with a Silicon Labs CP2103GM USB/UART bridge device.
      Average read rate of ~1,960 characters per second.



-------------------------------------------------------------------------------------------------
Invalid Characters and Control Sequences
-------------------------------------------------------------------------------------------------

In an ideal world your application will only transmit valid characters and valid escape and DCS
sequences to PicoTerm and everything will work precisely as intended. However, mistakes do 
happen especially during code development so it is useful to know how PicoTerm has been designed
to react when it receives unexpected characters and sequences.

Any control codes (i.e. codes in the range 01 to 1F hex) and all 8-bit codes (80 to FF hex)
not supported by PicoTerm are automatically replaced with a '*' character. The display of
this visible character makes it easier to observe and debug applications during development.

The most common mistakes when developing an application are the incorrect preparation of a 
character code (e.g. when converting a binary value into its ASCII representation) or the 
incorrect implementation of a Device Control String (DCS) resulting in raw 8-bit values then 
being interpreted by PicoTerm as ASCII characters (see below).

When an escape sequence does not match with any of those supported then PicoTerm will abandon
the processing of the sequence at the earliest opportunity with any subsequent characters being 
displayed in the main terminal window. For example, if a mistake is made when attempting to 
issue a clear screen sequence...
         
   invalid sequence  'ESC'  '['  '3'  'J'  is transmitted to PicoTerm 
   correct sequence  'ESC'  '['  '2'  'J'  (contains '2' rather than '3')

... PicoTerm will abandon the sequence as soon as '3' is received and then both '3' and 'J' will
be displayed in the main terminal window. Not what you expected, but being observable helps.  

In a similar way, when a DCS sequence does not match with any of those supported then PicoTerm
will abandon the processing of the sequence at the earliest opportunity. 'Invalid string! will 
be displayed in the 'PicoTerm DCS Transactions' window and any subsequent characters will be 
displayed in the main terminal window. Since some DCS sequences are associated with byte data, 
the subsequent characters displayed could be anything and quite often '*' would be observed 
because byte values can easily be in the range 128 to 255 (80 to FF hex). 



-------------------------------------------------------------------------------------------------
BAUD Rates and Character Rates
-------------------------------------------------------------------------------------------------

The BAUD rate defines the number of bits per second transmitted or received when a 'character' 
(or byte) is transferred between PicoTerm and a device (e.g. PicoBlaze). The serial transfer of
each 'character' consists of a start bit, 8 data bits and a stop bit. So at the default BAUD rate
of 115200 bits/s it will take 10/115200 = 86.8us to transmit or receive one 'character'. It is 
therefore reasonable and tempting to assume that 115200/10 = 11,520 characters can be transferred
per second. However, this is not always the case and it also means that higher BAUD rates do NOT
always result in faster communication rates of multiple characters (or bytes).

When using PicoTerm with a USB/UART bridge and Virtual COM port, the typical maximum CONTINUOUS 
communication rates achieved are in the region of 2,000 characters per second from the PC running
PicoTerm to a peripheral and 4,000 characters per second from a peripheral to PicoTerm. These 
rates far exceed the requirements of applications involving simple human interaction but reading
and writing files, or heavy use of some of the special features (e.g. the graphics window), can 
lead to issues or otherwise unexpected results. So if you have applications for which you 
anticipate potentially high character rates then please review the descriptions below.


Character Rate from a PC running PicoTerm to the Peripheral
-----------------------------------------------------------

When PicoTerm is used with a USB/UART device then it is typical for the Virtual COM port driver
to leave additional gaps between characters (or between bursts of characters). These gaps lower 
the average character rate. Maximum rates in the region of 2,000 characters per second are 
typical. In practice, this rate reduction will normally only be noticed when an application 
attempts to read files containing a significant amount of data (i.e. many thousands of 
characters). Whilst this rate reduction can be disappointing, it often makes it easier for your
application to cope with the data flow without resorting to large buffers of flow control 
mechanisms. Please see 'Reading Text Files' section earlier in this file for further descriptions.

Ultimately, the communication rate from PicoTerm running on the PC to the peripheral is a self-
regulating limitation that must be accepted when using a virtual COM port. It simply means that 
it will probably take longer to read a file than you may have expected to take.


Character Rate from the Peripheral to a PC running PicoTerm 
-----------------------------------------------------------

In this direction the limitation is less obvious and affords your application a reasonable 
degree of flexibility. However, it is the application that is ultimately responsible for the 
character rate and this must be kept within certain limits for reliable communication to take
place. 

Hint - High character or data rates are most likely to occur when attempting to write a 
       large amount of information to a LOG file but can also be attributed to high usage of 
       certain Device Control Strings (DCS) used to control one or more of the special PicoTerm
       features. A high transfer rate can be beneficial when writing a lot of information to a
       file or plotting a complex graphic but in these cases it may be necessary to accept the 
       limitations and implement a scheme that will deliberately lower the overall data rate. 
       However, there are situations in which it high data rates occur which relate to 
       inappropriate use of DCS and can easily be avoided. For example, it is theoretically 
       possible transmit the DCS to update the virtual 7-Segment over 1,600 times a second but
       there is no way that the user would observe more than a few changes of the display per 
       second so such a high update rate is therefore unnecessary. Likewise, it is pointless 
       polling the virtual switches more than a few times a second as no user would change 
       them that fast. 

When using the default BAUD rate of 115200 the maximum communication rate that can be achieved 
is 11,520 characters per second. A virtual COM port working with a USB/UART device is able to 
operate at this rate but PicoTerm will only be able to process in the region of 4,000 characters 
per second. Virtual buffers in PicoTerm and the virtual COM port driver are able to accumulate a
backlog of characters when the received data rate is of a higher than PicoTerm can process. 
However, the backlog cannot be allowed to grow indefinitely and therefore it is the responsibility 
of the application to ensure that the AVERAGE character rate is suitable for PicoTerm. 

Hint - When developing an application it is helpful to think in terms of an average character 
       rate relative to a period of ~10 seconds. As such, the transmission of <4,000 characters
       every second is ideal but the transmission of 40,000 characters in 3.5 seconds is also 
       acceptable providing very few characters are transmitted during the next 6.5 seconds to
       achieve the same average rate over a 10 second period.

If the application CONTINUOUSLY transmits 11,520 characters per second to PicoTerm, which only 
processes 4,000 characters per second, the backlog will grow by 6,520 characters per second.
If this is sustained then the backlog will reach 60,000 characters after ~9 seconds and PicoTerm
will display a 'WARNING - High Average Data Rate!' message in the DCS Transactions Window (the 
DCS Transactions will pop up if not already open). The warning is a clear indication that the 
communication rate is unsustainable; it would take at least as long again before any data would
be lost but it is recommended that the application is modified to avoid this message from ever 
being displayed. If the warning message is generated then a 'Good News - Average Data Rate has
reduced!' message will be displayed when the backlog falls back below 20,000 characters. 

Hint - It would take PicoTerm up to 15 seconds to clear a backlog of 60,000 characters. Whilst
       PicoTerm will reliably clear such a large backlog, it is often undesirable for your 
       PicoTerm display(s) to be that far behind your application. So in general, it is far 
       better to craft your application so that it does not transmit more than ~4,000 characters
       in any one second as this will result in the timely display of all information.

Hint - When transmitting large amounts of information from an application to PicoTerm (e.g. 
       writing information to a LOG file) you could issue a 'ping' request after every few 
       thousand characters have been transmitted and then wait for the 'ping' response. In this
       way your application would wait for PicoTerm to clear any backlog before it continued
       ensuring that the PicoTerm display(s) was never more than a second behind the application.  
        


-------------------------------------------------------------------------------------------------
End of 'PicoTerm_README.txt'
-------------------------------------------------------------------------------------------------
