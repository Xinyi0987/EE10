{
  Project: EE-9 Assignment
  Platform: Parallax Project USB Board
  Revision: 1.2
  Author: Teo Xin Yi
  Date: 14th Nov 2021
  Log:
        Date: Desc
        15/11/2021: Connect to Ultrasonic & ToF sensors
}


CON

        '' [ Declare Pins for Sensors ]
        ' Ultrasonic 1 (Front) - I2C Bus 1
        ultra1SCL = 6
        ultra1SDA = 7
        ' Ultrasonic 2 (Back) - I2C Bus 2
        ultra2SCL = 8
        ultra2SDA = 9

        ' ToF 1 (Front) - I2C Bus 1
        tof1SCL = 0
        tof1SDA = 1
        tof1RST = 14            'ToF reset pin
        'ToF 2 (Back) - I2C Bus 2
        tof2SCL = 2
        tof2SDA = 3
        tof2RST = 15

        tofAdd = $29           'ToF default addr is hex 29


VAR  ' Global Variable

  long cogIDNum, cogStack[64]
  long _Ms_001

OBJ
  Ultra         : "EE-7_Ultra_v2.spin"                                          ' <-- Embedded a 2-element obj within EE-7_Ultra_v2
  ToF[2]        : "EE-7_Tof.spin"
  ' Create a hardware definition file

PUB Start(mainMSVal, mainUltra1Add, mainUltra2Add, mainToF1Add, mainToF2Add)

  _Ms_001 := mainMSVal

  Stop

  cogIDNum := cognew(sensorCore(mainUltra1Add, mainUltra2Add, mainToF1Add, mainToF2Add), @cogStack)

  return cogIDNum


PUB Stop                                                                    'To stop the code in the core/cog and release the core/cog

  if cogIDNum
    cogstop (cogIDNum~)

PUB sensorCore(mainUltra1Add, mainUltra2Add, mainToF1Add, mainToF2Add)

  ' Declaration & Initialisation
  Ultra.Init(ultra1Scl, ultra1SDA, 0)                   ' Assigning & init the first element obj in EE-7_Ultra_v2
  Ultra.Init(ultra2Scl, ultra2SDA, 1)                   ' Assigning & init the second element obj in EE-7_Ultra_v2

  tofInit                                               ' Perform init for both sensors

  ' Run & get readings
  repeat
    long[mainUltra1Add] := Ultra.readSensor(0)          ' Reading from first element obj
    long[mainUltra2Add] := Ultra.readSensor(1)          ' Reading from second element obj
    long[mainToF1Add] := ToF[0].GetSingleRange(tofAdd)
    long[mainToF2Add] := ToF[1].GetSingleRange(tofAdd)
    Pause(50)

PRI tofInit | i

  ToF[0].Init(tof1SCL, tof1SDA, tof1RST)
  ToF[0].ChipReset(1)              ' Last state is ON position
  Pause(1000)
  ToF[0].FreshReset(tofAdd)
  ToF[0].MandatoryLoad(tofAdd)
  ToF[0].RecommendedLoad(tofAdd)
  ToF[0].FreshReset(tofAdd)

  'Initialization for ToF2 sensors
  ToF[1].Init(tof2SCL, tof2SDA, tof2RST)
  ToF[1].ChipReset(1)              ' Last state is ON position
  Pause(1000)
  ToF[1].FreshReset(tofAdd)
  ToF[1].MandatoryLoad(tofAdd)
  ToF[1].RecommendedLoad(tofAdd)
  ToF[1].FreshReset(tofAdd)

PRI Pause(ms) | t

  t := cnt - 1000
  repeat (ms #> 0)
    waitcnt(t += _Ms_001)
  return

DAT