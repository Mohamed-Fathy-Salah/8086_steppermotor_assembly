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

<img src="images/components/8086.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa .,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa</p>
  <hr>


<b>8255A</b>

<img src="images/components/8255A.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa </p>
  </br></br></br></br></br></br></br></br></br>
  <hr>
  
  <b>latch</b>

<img src="images/components/latch.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa </p>
  </br></br></br></br></br></br></br></br></br>
  <hr>
  
  <b>ADC</b>

<img src="images/ADC.PNG" align="right">
<h5> analog to digital converter used to read analog voltage from potentiometer and convert it to digital then send this value to the I/O device </h5>
<ul>
    <li> CS---> is grounded to operate the ADC (active low) </li>
    <li> WR---> set and reset this bit to convert the data from analog to digital </li> 
    <li> RD---> after the conversion from analog to digital we set this pin to low to bring data from internal registers to output pins (DB0-DB7) </li>
    <li> DB0-DB7---> we get the digital data which is equivalent to the voltage on potentiometer and this value will be varied to get different values of motor speed (varying the delay between every step) </li>
  </ul>
  </br></br></br></br></br></br></br></br></br>
  <hr>
  
  <b>Stepper motor</b>

<img src="images/components/STEPPER%20MOTOR.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa </p>
  </br></br></br></br></br></br></br></br></br>
  <hr>
  
   <b>L293D Driver</b>
   
<img src="images/components/l293d.PNG" align="right">
  <p>l.,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa,khmjgnhgfdfghm,k.,mmnnbvcdxscvbnm,.,mmhngbfdsdfghnm,.kjhjgfdsa </p>
  </br></br></br></br></br></br></br></br></br>
  <hr>
  
  
## Controlling the motor's speed

In our circuit we can control the speed of the motor by two different ways, the first way was through change (half / full) cycle switch and the second way was through change the potentiometer slider place and we can use the two ways in same time. the two ways have different techniques to change speed which :

- **(half / full) cycle switch :** change the speed of the motor only in two modes the full cycle and the half cycle mode , and it can be achieved by making two arrays of steps and by using one of them with the stepper motor it will step corresponding to the selected array and the array selected according to the (half / full) cycle switch.
 ```
STEPS  DB       00000011B,              ; Full Step Mode Array
                 00000110B, 
                 00001100B, 
                 00001001B   

HSTEPS DB       00000001B,      	; Half Step Mode Array
                 00000011B, 
                 00000010B, 
                 00000110B, 
                 00000100B, 
                 00001100B, 
                 00001000B,
                 00001001B
 ``` 
- **the Potentiometer Slider :** in this way we control the speed by really different technique as we change the value of delay between the steps sent to the motor , there are 11 values we can obtained through the Potentiometer by using ADC converter to convert the analog value of the potentiometer to digital value we can use and obtain delay value from it , the range of the delay value (06FFH - 185CH).

-  By using the both way in same time we can obtain 22  mode for the motor's speed by different values of delay.

## GETSPEED function

In this function we obtain the digital value from the potentiometer and by using ADC converter it converted into digital value that we can modified any used in changing the delay time value that used between the steps in `RUN function` .
In our function we create an equation to compute the delay time from this digital value as we multiply this value by `35` and add it to the initial value of the delay time that we initialized , which equal to `06FFH`. that will make the range of the delay value between (`06FFH` and `185CH`). and this equation will be :

>    DELAY  = 06FFH + ( 35 * potentiometer value )

the second operation that this function do, was set and reset write bit of ADC converter to help in the converting process and turn on and off the direction lamp after check the reverse switch in the previous function  

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

