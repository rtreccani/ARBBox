import serial
import random
import signal
import time

ser = serial.Serial('COM15', 1000000)


def handler(signum, frame):
    ser.close()
    exit()
signal.signal(signal.SIGINT, handler)

def writeToRam(addr,val):
    if(addr>255 or val >255):
        print("invalid value in address or val for write")
        ser.close()
        exit()

    packet =[87, addr, val]
    bytePacket = bytes(packet)
    bytesSent = ser.write(bytePacket)
    if(bytesSent != 3):
        print("full packet not sent on write")
        ser.close()
        exit()
    return    



def readFromRam(addr,val):
    if(addr>255 or val >255):
        print("invalid value in address or val for read")
        ser.close()
        exit()
    
    packet = [82, addr]
    bytesPacket = bytes(packet)
    bytesSent = ser.write(bytesPacket)
    if(bytesSent != 2):
        print("full packet not sent on read")
        ser.close()
        exit()
                                                                         
    inval = ser.read(1)
    if(inval[0] != bytes([val])[0]):
        print("read error: invalid value")
        ser.close()
        exit()
    return


testSeq = []
for i in range(0,255):
    testSeq.append(0)


while True:
    for i in range(0,255):
        testSeq[i] = random.randint(0,255)
    #print(testSeq)

    for addr,val in enumerate(testSeq):
        writeToRam(addr,val)

    for addr,val in enumerate(testSeq):
        readFromRam(addr, val)

    print('successfully wrote and read back 256 bytes')



