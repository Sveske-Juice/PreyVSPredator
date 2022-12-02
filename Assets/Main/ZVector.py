#include <iostream>
#include <vector.h>

import math

class ZVector:
    x=y=z=0

    def __init__(self, x = 0, y = 0, z = 0):
        self.x = x
        self.y = y
        self.z = z
    
    def __str__(self):
        return "({}, {}, {})".format(self.x, self.y, self.z)

    @staticmethod
    def copy(vectorToCopy):
        vec = ZVector()
        vec.x = vectorToCopy.x
        vec.y = vectorToCopy.y
        vec.z = vectorToCopy.z
        return vec


    def add(self, X, Y = 0, Z = 0, setToSelf = False):
        vecSum = ZVector.copy(self)
        vecSum.x += X.x
        vecSum.y += X.y
        vecSum.z += X.z

        if setToSelf:
            self.copyValues(vecSum)

        return vecSum

    '''
    This only accepts another vector as input
    '''
    def sub(self, otherVec, setToSelf = False):
        # if not isinstance(otherVec, ZVector):
        #     raise TypeError("This only accepts ZVector")
        
        modVec = ZVector.copy(self)
        modVec.x -= otherVec.x
        modVec.y -= otherVec.y
        modVec.z -= otherVec.z

        if setToSelf:
            self.copyValues(modVec)
        
        return modVec
        

    def diff(self, compareVec):
        # if not isinstance(compareVec, ZVector):
        #     raise TypeError("Param is not of type ZVector")

        vecBetween = ZVector()
        vecBetween.x = self.x - compareVec.x
        vecBetween.y = self.y - compareVec.y
        vecBetween.z = self.z - compareVec.z
        return vecBetween

    def mult(self, scalar, setToSelf = False):
        modVec = ZVector.copy(self)
        modVec.x *= scalar
        modVec.y *= scalar
        modVec.z *= scalar

        if setToSelf:
            self.copyValues(modVec)

        return modVec

    def printVec(self): 
        print("({}, {}, {})".format(self.x, self.y, self.z))

    def toZVector(self): 
        return ZVector(self.x, self.y, self.z)

    @staticmethod
    def fromAngle(angle, isRadians = False):
        if not isRadians:
            angle *= (math.pi / 180)
        return ZVector(math.cos(angle), math.sin(angle))

    def heading(self):
        return 360 - (((math.atan2(self.x, self.y) * (180 / math.pi)) + 90) % 360)

    def mag(self): 
        return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)

    def distTo(self, otherVec):
        combined = self.sub(otherVec)
        return math.sqrt(combined.x*combined.x + combined.y*combined.y + combined.z*combined.z)
    
    def normalized(self):
        m = self.mag()
        normalVec = ZVector()
        normalVec.x = self.x / m
        normalVec.y = self.y / m
        normalVec.z = self.z / m
        return normalVec

    def limit(self, length):
        return self.normalized().mult(length)

    def setMag(self, length):
        self = self.normalized().mult(length)
        return self
    
    def rotate(self, degrees, isRadians = False):
        if isRadians:
            degrees *= (math.pi / 180)
        degrees %= 360
        mag = self.mag()
        currentAngle = self.heading()
        currentAngle += degrees
        return ZVector.fromAngle(currentAngle).setMag()

    def copyValues(self, otherVec):
        self.x = otherVec.x
        self.y = otherVec.y
        self.z = otherVec.z

    @staticmethod
    def randomScreenPoint():
        return ZVector(random(0, width), random(0, height))
