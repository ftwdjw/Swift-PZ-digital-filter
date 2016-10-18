//: Playground - noun: a place where people can play

import UIKit

let pi = 4.0*atan(1.0)

struct Complex {
    var r:Double = 0.0, j:Double = 0.0
}

/*************functions**********/


func printComplex (c1: Complex) {
    print("r=\(c1.r) j=\(c1.j)")
    
}

func SIGN (a:Double, b:Double)-> Double {
    
    //If B\ge 0 then the result is ABS(A), else it is -ABS(A)
    var out:Double=0.0
    if b>0{
        out=abs(a)
    }
    else{
        out = -abs(a)
    }
    return out
    
}

func + (c1: Complex, c2: Complex) -> Complex {
    return Complex(r: c1.r + c2.r, j: c1.j + c2.j)
}
func - (c1: Complex, c2: Complex) -> Complex {
    return Complex(r: c1.r - c2.r, j: c1.j - c2.j)
}

func CABS (c1: Complex) -> Double {
    var out :Double = 0.0
    out=sqrt(c1.r*c1.r+c1.j*c1.j)
    return out
}

func angFunction (c1: Complex) -> (rad:Double, deg:Double) {
    var rad :Double = 0.0
    let pi :Double = 4.0*atan(1.0)
    //let ratio1 = c1.j/c1.r
    let angle1 = atan2(c1.j,c1.r)
    rad=(angle1)
    let deg=rad*180/pi
    return (rad, deg)
}

func * (c1: Complex, c2: Complex) -> Complex {
    var out = Complex(r:0.0, j:0.0)
    out.r=c1.r*c2.r-c1.j*c2.j
    out.j=c1.r*c2.j+c1.j*c2.r
    return out }

func / (c1: Complex, c2: Complex) -> Complex {
    var out = Complex(r:0.0, j:0.0)
    let bottom = pow(c2.r,2)+pow(c2.j,2)
    out.r=(c1.r*c2.r+c1.j*c2.j)/bottom
    out.j=(c1.j*c2.r-c1.r*c2.j)/bottom
    return out }

func MagToRect (m1: MagAng ) -> Complex {
    var out = Complex(r:0.0, j:0.0)
    out.r = m1.mag * cos(m1.ang)
    out.j = m1.mag * sin(m1.ang)
    return out }

//: ![Functions 1 - Programming Examples](CEXP.tiff)
func CEXP (c1: Complex)-> Complex{
    var out=Complex(r: 0.0,j: 0.0)
    //exp(a+jb)=e^a(cos(w)+jsin(w))
    out.r=exp(c1.r)*cos(c1.j)
    out.j=exp(c1.r)*sin(c1.j)
    return out
}

struct MagAng {
    var mag = 0.0, ang = 0.0
}

//test
var HW=Complex(r: 0.0,j: 1.0)
var HWN=Complex(r: 1.0,j: 1.0)
var HWD=Complex(r: 0,j: 0)


let y = CEXP(c1: HW)
let x = HW*HWD

print(x)

let z=SIGN(a: 1.0, b: 5.0)

print(z)

func FTPLZ (RmagZeros: [Double],THphaseZeros: [Double],PmagPoles: [Double],PHphasePoles: [Double],gain: Double, lPoints: Int) -> (Mag:[Double], Phase:[Double]) {//start
    
    assert(RmagZeros.count==THphaseZeros.count,"number of magnitudes of zeros must equal number of phase of zeros")
    
      assert(PmagPoles.count==PHphasePoles.count,"number of magnitudes of poles must equal number of phase of poles")
    
    let mTopNum=RmagZeros.count //number of zeros on top
    let nBotNum=PmagPoles.count  //number of poles on bottom
    
    
    var XMAG=[Double](repeating:0.0, count: lPoints)
    var XPHA=[Double](repeating:0.0, count: lPoints)
    
    var eJW1=Complex(r:0.0,j:0.0)
    var eJW=Complex(r:0.0,j:0.0)
    var HW=Complex(r: 0,j: 0)
    var HW1=Complex(r: 0,j: 0)
    var HW2=Complex(r: 0,j: 0)
    var HW3=Complex(r: 0,j: 0)
    var HW4=Complex(r: 0,j: 0)
     var HW5=Complex(r: 0,j: 0)
    var G1=Complex(r: 0,j: 0)
    var DW:Double=0.0
    
    let EPS=1.0e-7
    var x:Double=0.0
    var x1:Double=0.0
    
    
    
    if lPoints>1{//start if
        DW=pi/Double(lPoints-1)
        print("DW=\(DW)")
    }//end if
    
    for i in (0..<lPoints){//start for i Do 300
        x=(Double(i)*DW)
        eJW1.r=0.0
        eJW1.j=x
        eJW=CEXP(c1: eJW1)
        print("\neJW=\(eJW)")
        
        G1.r=gain
        print("G1=\(G1)")
        x1=x*Double(nBotNum-mTopNum)
        HW3.r=0.0
        HW3.j=x1
        HW2=CEXP(c1: HW3)
        HW=G1*HW2
        print("HW=\(HW)")
        
        
        for k in (0..<mTopNum){//start for index Do 100
            HW1.r=0.0
            HW1.j=THphaseZeros[k]*pi/180.0
            HW1=CEXP(c1: HW1)
            print("HW1=\(HW1)")
            
            let x = eJW.r
            let y = RmagZeros[k]
            eJW.r=x - y
            HW=HW*eJW*HW1
            print("HW1=\(HW)")
            
        }//end for index 100

        
        for k in (0..<nBotNum){//for index1
            HW4.r=0.0
            HW4.j=THphaseZeros[k]*pi/180.0
            HW5=CEXP(c1: HW4)
            let x = eJW.r
            let y = PmagPoles[k]
            
            eJW.r=x - y
            
            HW=HW/(eJW*HW5)
            
            print("HW=\(HW)")
            
        }//end index1 200

    
        
        if abs(HW.r)<EPS && abs(HW.j)<EPS {//start if1
            if i>2 {//start if2
                XPHA[i]=2.0*XPHA[i-1]-XPHA[i-2]
            }//end if2
            else if abs(HW.r)<EPS{//start else if
                
                XPHA[i]=SIGN(a: 1.0, b: HW.j)*0.5*pi
            }//end else if
        }//end if1
        else
        {//start else
            
            let IX=(1.0-SIGN(a: 1.0, b: HW.r))/2.0
            let IY=SIGN(a: 1.0, b: HW.j)
            XPHA[i]=atan(HW.j/HW.r)+IX*IY*pi
        }//end else
        
        
        XMAG[i]=CABS(c1: HW)
        
        
        
        
        
        
    }//end for i 300
    return (Mag:XMAG,Phase:XPHA)
}//end


let R=[0.0]
let TH=[0.0]
let P=[0.8]
let PH=[0.0]
let gain=1.0
let points=4

let output=FTPLZ(RmagZeros: R, THphaseZeros: TH, PmagPoles: P, PHphasePoles: PH, gain: gain, lPoints: points)

let mag=output.Mag
let phase=output.Phase
print("mag=\(mag)")
print("phase=\(phase)")
