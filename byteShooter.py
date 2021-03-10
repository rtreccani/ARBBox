val = 0
import serial

ser = serial.Serial('COM15', 1000000)


while (True):
    try:
        val = int(input('> ')) #home sweet home
        valByte = val.to_bytes(1, 'big')
        ser.write(valByte)
    except:
        ser.close()
        exit()