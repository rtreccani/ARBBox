val = 0
import serial

ser = serial.Serial('COM15', 9600) #1000000)


while (True):
    try:
        val = (input('> ')) #home sweet home
        if(val == 'V'):
            print(ser.in_waiting)
        elif(val == 'R'):
            print(ser.read(1))
        else:
            valByte = int(val).to_bytes(1, 'big')
            ser.write(valByte)
    except:
        ser.close()
        exit()