{

  Project: EE-9 Assignment
  Platform: Parallax Project USB Board
  Revision: 1.3
  Author: Teo Xin Yi
  Date: 30th Nov 2021
  Log:
        Date: Desc
        30/11/2021: Calls Comm, Motor & Sensor as an object to control lite kit in wireless mode

}

CON
        _clkmode                = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq                = 5_000_000
        _ConClkFreq             = ((_clkmode - xtal1) >> 6) + _xinfreq
        _Ms_001                 = _ConClkFreq / 1_000

VAR    'Global Variables
  long  mainUltra1Add, mainUltra2Add, mainToF1Add, mainToF2Add, dirVal, Mainmotor, speed

OBJ
  'Term      : "FullDuplexSerial.spin"   'UART communication for debugging
  Sensor    : "SensorControl.spin"      '<-- Object / Blackbox
  Motor     : "MotorControl.spin"
  Comm      : "CommControl.spin"

PUB Main

  'Declaration and Initialisation
  'Term.Start(31,30,0,115200)
  'Pause(3000) 'wait 3 seconds
  Comm.Start(_Ms_001, @dirVal)
  Sensor.Start(_Ms_001, @mainUltra1Add, @mainUltra2Add, @mainToF1Add, @mainToF2Add)
  Motor.Start(_Ms_001, @Mainmotor, @speed)

  {repeat
    Term.Str(String(13, "Ultrasonic 1 Reading: "))
    Term.Dec(mainUltraVal1)
    Term.Str(String(13, "Ultrasonic 2 Reading: "))
    Term.Dec(mainUltraVal2)
    Term.Str(String(13, "ToF 1 Reading: "))
    Term.Dec(mainToFVal1)
    Term.Str(String(13, "ToF 2 Reading: "))
    Term.Dec(mainToFVal2)
    Pause(300)
    Term.Tx(0)}

  repeat
    case dirVal
      1:  'Move forward
        'Term.Str(String(13,"Hello"))
        if (mainUltra1Add > 300) and (mainToF1Add < 200)
          'Term.Str(String(13,"Forward"))
          Mainmotor := 0
          speed := 150
        else
          Mainmotor := 4
      2:  'Move Reverse
        if (mainUltra2Add > 300) and (mainToF2Add < 200)
          'Term.Str(String(13,"Reverse"))
          Mainmotor := 1
          speed := 150
        else
          Mainmotor := 4
      3:  'Turn Left
        Mainmotor := 2
        speed := 150
      4:  'Turn Right
        Mainmotor := 3
        speed := 150
      5:  'Stop
        Mainmotor := 4
        speed := 150

PRI Pause(ms) | t    'Pause Function

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return