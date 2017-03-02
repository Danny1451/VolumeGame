//
//  GameScene.swift
//  VoiceGameDemo
//
//  Created by 刘旦 on 2017/2/22.
//  Copyright © 2017年 egame. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    
    private var spinnyNode : SKSpriteNode?
    private var voiceLab : SKLabelNode?
    
    private var recoder : AVAudioRecorder?
    
    private var timmer : Timer?
    
    private let backgroundNode = BackgroundNode()
    var lastPeak: Float?
    override func didMove(to view: SKView) {
        
        //init av catch the volume
        let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),//声音采样率
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),//编码格式
            AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
            AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//音频质量
        
        let url = URL(fileURLWithPath:"/dev/null")
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recoder = AVAudioRecorder(url: url, settings: recordSettings)
            
            
            
        }catch let error as NSError{
            print(error)
        }
        
        if let recoder = recoder {
            recoder.prepareToRecord()
            recoder.isMeteringEnabled = true
            recoder.record()
            lastPeak = -10.0
            timmer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(voiceMoniter), userInfo: nil, repeats: true)
        }
       
        
        //back
        
        backgroundNode.setup(size: size)
        addChild(backgroundNode)
        
        

        
        self.voiceLab = self.childNode(withName: "//voicelab") as? SKLabelNode
        if let voiceLab = self.voiceLab {
            voiceLab.text = "123.456"
        }
        
        // Create shape node to use during mouse interaction
        
        let plane = SKTexture(image: #imageLiteral(resourceName: "robot2"))
        self.spinnyNode = SKSpriteNode(texture: plane)
        
        if let spinnyNode = self.spinnyNode {
           
            
            spinnyNode.physicsBody = SKPhysicsBody(texture: plane, size: spinnyNode.size)
            spinnyNode.physicsBody?.allowsRotation = false
            
            addChild(spinnyNode)
            
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//         
//                                              SKAction.removeFromParent()]))
            
        }
        
        
       
    }
    
    func voiceMoniter(){
        recoder?.updateMeters()
        
        let value = recoder?.averagePower(forChannel: 0)
        let peak = recoder?.peakPower(forChannel: 0)
        
        let speed = peak! - lastPeak!
        lastPeak = peak
        
//        print("average = \(value) , peak = \(peak)")
         print("speed \(abs(speed))")
        if abs(speed) > 15{
            
            let impulse = -((abs(speed) - 15) * 20 + 300.0)
            
           
            self.spinnyNode?.physicsBody?.applyImpulse(CGVector(dx:0.0,dy:Double(impulse)))
//            self.backgroundNode.run(SKAction.moveBy(x:-30, y: 0, duration: 0.5))
        }
        
        print("value \(abs(value!))")
        if abs(value!) > 50 {
           
                    
            self.backgroundNode.run(SKAction.moveBy(x:-20, y: 0, duration: 0.5))
            
            self.voiceLab?.text = "fenbei\(speed)"
        }
        
        
    }
        
    
    func touchDown(atPoint pos : CGPoint) {
        
        self.backgroundNode.run(SKAction.moveBy(x: -20, y: 0, duration: 0.5))

//        if let n = self.spinnyNode?.copy() as! SKSpriteNode? {
//            n.position = pos
//
//            self.addChild(n)
//        }

        
//        self.spinnyNode?.run(SKAction.moveBy(x: 0, y: 100, duration: 0.5))
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
