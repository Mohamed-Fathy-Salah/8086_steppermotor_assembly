<h1 align="center">8086_steppermotor_assembly</h1>

<p align="center">
  
  <br>
  <i>Using 8086 Microprocessor to control Stepper motor direction and speed 
    <br> then showing the current speed value on 7-seg display and the direction through Blinking Led.</i>
  <br>
</p>

## Table of contents

- [Quick start](#Quick-start)
- [Description](#Description)
- [Used Devices](#Used-Devices)
- [Circuit Diagram](#Circuit-Diagram)
- [Features](#Features)
- [Team members](#Team-members)

## Quick start

Several quick start options are available:

- in order to run the [circuit](https://github.com/Mohamed-Fathy-Salah/8086_steppermotor_assembly/blob/main/stepper%20motor_project.pdsprj) you have to install at least proteus vertion 8. 
- Clone the repo: `git clone https://github.com/Mohamed-Fathy-Salah/8086_steppermotor_assembly.git`


## Code Flow

   As long as the ON/OFF switch is closed the main process runs in an infinite loop.</br></br>
Before running the motor we have to calculate some global variables.</br>
Firstly it calls the `GETPRESSED` process to read from port c the state of the direction and the HALF/FULL step then update the HDIR variable.
Then it calls the `GETSPEED` process to get the input from the potentiometer to calculate the right delay as the user wants after that it reset the write pin of the ADC to convert the analog value to digital and set this pin again at the end of the process for future use. then it checks the HDIR value to see whether to turn the led on or off.</br></br>
After the delay has the right value from the potentiometer and HDIR (the direction variable) has the right value it's time to call the RUN function.</br>
In the `RUN` function it firstly checks the direction to see whether the motor will rotate in clockwise direction or anticlockwise direction, Then it checks the step mode to rotate the motor in full step of half step. so it’s able now to run in the desired mode and direction.</br></br>
The remaining part related to the speed Display on the screen.</br>
Then `GETDSPLYD` PROC calculate the speed of the motor that will be displayed on the 3-segments ranging from 28 to 100 depending on the minimum and the maximum delay value the motor can handle. and store the result in the DSPLYD global variable.</br>
Finally the `DISPLAY` PROC which will simply take the value of the speed stored in the DSPLYD global variable and display it on the segments connected to the second i/o device.

## Components discription

<b>8086</b>

<img src="https://github.com/omarmohamed101/java-code/blob/main/8255A.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa .,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa</p>
  <hr>


<b>8255A</b>

<img src="https://github.com/omarmohamed101/java-code/blob/main/8255A.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa </p>
  </br></br></br></br></br></br></br></br></br>
  <hr>
  
  <b>latch</b>

<img src="https://github.com/omarmohamed101/java-code/blob/main/8255A.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa </p>
  </br></br></br></br></br></br></br></br></br>
  <hr>
  
  <b>ADC</b>

<img src="https://github.com/omarmohamed101/java-code/blob/main/8255A.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa </p>
  </br></br></br></br></br></br></br></br></br>
  <hr>
  
  <b>Stepper motor</b>

<img src="https://github.com/omarmohamed101/java-code/blob/main/8255A.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa </p>
  </br></br></br></br></br></br></br></br></br>
  <hr>
  
## Used Devices
- 8086 microprocessor
- 74HC373 Latch
- 8255A I/O device
- Stepper Motor
- ADC0804 Digital to Analog Converter
- L293D Motor Driver Ic
- Resistors
- LED
- Switch
- potentiometer
- Battery
## Resources
* [8086] - 8086 pinout
* [74HC373] - Latch pinout
* [8255A] -8255A I/O device
* [Stepper Motor] - Stepper Motor
* [ADC0804] - Digital to Analog Converter
* [L293D] - Motor Driver Ic

 [8086]: <https://www.tutorialspoint.com/microprocessor/microprocessor_8086_pin_configuration.htm>
 [74HC373]: <https://assets.nexperia.com/documents/data-sheet/74HC_HCT373.pdf>
 [8255A]: <https://www.tutorialspoint.com/microprocessor/microprocessor_intel_8255a_programmable_peripheral_interface.htm>
 [Stepper Motor]: <https://www.monolithicpower.com/en/stepper-motors-basics-types-uses>
 [ADC0804]: <https://www.engineersgarage.com/knowledge_share/adc0804-pinout/> 
 [L293D]: <https://components101.com/l293d-pinout-features-datasheet>
 
 ## Circuit Diagram
 ![alt circuit](https://raw.githubusercontent.com/Mohamed-Fathy-Salah/8086_steppermotor_assembly/main/images/Circuit%20Diagram.PNG)
 
## Features
* Change direction of rotation

    ![rotate](/images/rotate.gif "rotate GIF")


* Change rotation speed
    | Slow | Mid | Fast |
    |:----:|:----:|:----:|
    |![slow](/images/slow.gif "slow speed rotation")|![mid](/images/mid.gif "mid speed rotation")|![fast](/images/fast.gif "fast speed rotation") |
    
    
* On/Off Motor

    ![on/off](/images/onoff.gif "on/off GIF")
    
    
* Full/Half step

    ![on/off](/images/halfstepfullstep.gif "half/fullstep GIF") 
    
    
* Adjusting speed

    ![Speed](/images/speed.gif "speed GIF")    
        
    

## Team members
- [Mohamed Fathy](https://github.com/Mohamed-Fathy-Salah)
- [Omar Mohamed](https://github.com/omarmohamed101)
- [Ahmed Nashaat](https://github.com/AhmadNashaat0)
- [Ahmed Yasser](https://github.com/ahmadyasser01)
- [Shahenda Hamdy](https://github.com/shahendahamdy)

