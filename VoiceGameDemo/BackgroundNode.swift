//
//  BackgroundNode.swift
//  VoiceGameDemo
//
//  Created by 刘旦 on 2017/2/23.
//  Copyright © 2017年 egame. All rights reserved.
//

import SpriteKit

class BackgroundNode: SKNode {

    
    private var nodeList = [SKShapeNode]()
    private var widthList = [CGFloat]()
    private var gapList = [CGFloat]()
    
    private var distance:CGFloat = 0.0
    
    
    private var timmer : Timer?
   
    public func setup(size : CGSize){
        
        
        timmer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(checkNodeList), userInfo: nil, repeats: true)
        addWidth(gap: 40, width: 200)
        addWidth(gap: 100, width: 250)
        addWidth(gap: 80, width: 250)
        addWidth(gap: 70, width: 280)
        addWidth(gap: 90, width: 290)
        
    }
    
    public func addWidth(gap : CGFloat, width: CGFloat){
        
        var startX:CGFloat = -700
        let ypos:CGFloat = -400.0
        let height:CGFloat = 200
        if let lastNode = nodeList.last {
            startX = lastNode.frame.size.width + lastNode.frame.origin.x + gap
        }
        
        let rect = CGRect(x: startX, y: ypos, width: width, height: height)
        let newNode = SKShapeNode(rect:rect)
        newNode.fillColor = SKColor(red:0.38, green:0.60, blue:0.65, alpha:1.0)
        newNode.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x:startX ,y:ypos + height), to: CGPoint(x:startX+width,y:ypos + height))
        
        gapList.append(gap)
        widthList.append(width)
        nodeList.append(newNode)
        addChild(newNode)
    }
    
    
    
    func checkNodeList(){
        
//        print(self.position)
        if let firstNode = nodeList.first{
            if ( (-self.position.x) - distance > ( widthList.first! + gapList.first!)) {
                print("remove")
                //准备remove
                nodeList.removeFirst()
                firstNode.removeFromParent()
                
                distance += widthList.removeFirst()
                distance += gapList.removeFirst()
                //random一个新的
                addWidth(gap: CGFloat(random(min: 50, max: 100)), width: CGFloat(random(min: 250, max: 350)))
                
            }
            
            
        }
    }
    
    private func random(min:Int, max:Int) ->Int{
   
        let maxI: UInt32 = UInt32(max)
        let minI: UInt32 = UInt32(min)
        let res = arc4random_uniform(maxI - minI) + minI // 82
        return Int(res)
    }
}
