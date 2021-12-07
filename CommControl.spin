{

  Project: EE-9 Assignment
  Platform: Parallax Project USB Board
  Revision: 1.3
  Author: Teo Xin Yi
  Date: 30th Nov 2021
  Log:
        Date: Desc
        30/11/2021: Creating object file for Comm Control
}


CON

  commRxPin     = 19 'DOUT
  commTxPin     = 18 'DIN
  commBaud      = 9600

  'Comm Hex Keys
  commStart     = $7A
  commForward   = $01
  commReverse   = $02
  commLeft      = $03
  commRight     = $04
  commStopAll   = $AA

VAR
  long  cogIDNum, cogStack[64], rxValue, _Ms_001

OBJ
  Comm      : "FullDuplexSerial.spin"                   'UART communication for Control

PUB Start(msVal, dirVal)       'Core 3

   _Ms_001 := MSVal   'stores number of milliseconds which will be used by Pause function

  StopCore      'stops cog

  cogIDNum := cognew(commCore(dirVal),@cogStack)   'cog that runs the ValueGiven function

  return

PUB StopCore       'Stops cog if cog3ID is called

  if cogIDNum
    cogstop(cogIDNum)

PUB commCore(dirVal)

  Comm.Start(commTxPin,commRxPin,0,commBaud)
  Pause(3000)

  ' Run & get readings
  repeat
    rxValue := Comm.Rx  '<- Wait at this statement for a byte
    'Comm.Str(String(13, "Hello"))
    if (rxValue == CommStart)
      'Comm.Str(String(13, "Start"))
      repeat
        rxValue := Comm.Rx
        case rxValue
          commForward:
            'Comm.Str(String(13, "Forward"))
            long[dirVal] := 1
          commReverse:
            'Comm.Str(String(13, "Reverse"))
            long[dirVal] := 2
          commLeft:
            'Comm.Str(String(13, "Left"))
            long[dirVal] := 3
          commRight:
            'Comm.Str(String(13, "Right"))
            long[dirVal] := 4
          commStopAll:
            'Comm.Str(String(13, "Stop"))
            long[dirVal] := 5

PRI Pause(ms) | t    'Pause Function

  t := cnt - 1088
  repeat(ms #> 0)
    waitcnt(t += _Ms_001)
  return