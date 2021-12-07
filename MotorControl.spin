{

  Project: EE-9 Assignment
  Platform: Parallax Project USB Board
  Revision: 1.4
  Author: Teo Xin Yi
  Date: 30th Nov 2021
  Log:
        Date: Desc
        30/11/2021: Connect & Control Motors
}


CON
        Motor1 = 10
        Motor2 = 11
        Motor3 = 12
        Motor4 = 13

        Motor1Zero = 1490
        Motor2Zero = 1490
        Motor3Zero = 1480
        Motor4Zero = 1480

VAR

  long cogStack[64], cogIDNum, _Ms_001

OBJ
   motors      : "Servo8Fast_vZ2.spin"
   'Term      : "FullDuplexSerial.spin"

PUB Start(msVal, mainMotor, speed)

  _Ms_001 := msVal
  StopCore
  cogIDNum := cognew(motorCore(mainMotor, speed),@cogStack)

PUB motorCore(mainMotor, speed)

  MotorInit

  repeat
    case long[mainMotor]
      0:
        Forward(speed)
      1:
        Reverse(speed)
      2:
        Turnleft(speed)
      3:
        TurnRight(speed)
      4:
        StopAllMotors

PUB StopCore                    'To stop the code in the core/cog and release the core/cog

  if cogIDNum
   cogstop(cogIDNum~)

PUB Forward(motorSpeed)         'To move motor forward

  Motors.Set(motor1, motor1Zero + long[motorSpeed])     'motor 1 & 2 will turn clockwise
  Motors.Set(motor2, motor2Zero + long[motorSpeed])
  Motors.Set(motor3, motor3Zero - long[motorSpeed])     'motor 3 & 4 will turn anti-clockwise
  Motors.Set(motor4, motor4Zero - long[motorSpeed])
  Pause(100)

PUB Reverse(motorSpeed)         'To move motor backward

  Motors.Set(motor1, motor1Zero - long[motorSpeed])     'motor 1 & 2 will turn anti-clockwise
  Motors.Set(motor2, motor2Zero - long[motorSpeed])
  Motors.Set(motor3, motor3Zero + long[motorSpeed])     'motor 3 & 4 will turn clockwise
  Motors.Set(motor4, motor4Zero + long[motorSpeed])
  Pause(100)

PUB Turnleft(motorSpeed)        'To move motor to the left depending on the mode, mode 1 is forward mode 2 is reverse

  Motors.Set(motor1, motor1Zero - long[motorSpeed])     'motor 1 & 3 will turn clockwise/ move forward
  Motors.Set(motor2, motor2Zero + long[motorSpeed])     'motor 2 & 4 will turn anti-clockwise/ reverse
  Motors.Set(motor3, motor3Zero + long[motorSpeed])
  Motors.Set(motor4, motor4Zero - long[motorSpeed])
  Pause(100)

PUB TurnRight(motorSpeed)       'To move motor to the right depending on the mode, mode 1 is forward mode 2 is reverse

  Motors.Set(motor1, motor1Zero + long[motorSpeed])     'motors 1 & 3 will turn anti-clockwise/ move forward
  Motors.Set(motor2, motor2Zero - long[motorSpeed])     'motors 2 & 4 will turn clockwise/ reverse
  Motors.Set(motor3, motor3Zero - long[motorSpeed])
  Motors.Set(motor4, motor4Zero + long[motorSpeed])
  Pause(100)

PUB StopAllMotors               'To stop all motors to its pre-set zero speed value

  Motors.Set(motor1, Motor1Zero)
  Motors.Set(motor2, Motor2Zero)
  Motors.Set(motor3, Motor3Zero)
  Motors.Set(motor4, Motor4Zero)

PRI MotorInit                   'To start initialize code to load the motor driving code into a new core/cog

  Motors.Init
  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Motors.Start
  Pause(100)

  StopAllMotors

PRI Pause(ms) | t    'Pause Function

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return