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
            AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.high.rawValue))]//音频质量
        
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
            lastPeak = 20.0
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
            
        }
        
        
       
    }
    
    func voiceMoniter(){
        
        recoder?.updateMeters()
        
        let avager = recoder?.averagePower(forChannel: 0)
        let peak = recoder?.peakPower(forChannel: 0)
        
        var level:Float = 0.0
        let minDecibels:Float = -80.0
        
        if avager! < minDecibels {
            level = 0.0
        }else if avager! >= 0.0{
            level = 1.0
        }else{
            let root:Float = 2.0
            let minAmp:Float = powf(10.0, 0.05 * minDecibels)
            let inverseAmpRange:Float = 1.0 / (1.0 - minAmp)
            let amp:Float = powf(10.0, 0.05 * avager!)
            let adjAmp = (amp - minAmp) * inverseAmpRange
            
            level = powf(adjAmp, 1.0 / root)
            
            
        }
        
        let result = level * 120
        print(" avager = \( level * 120) , peak = \(peak!)" )
        
        voiceLab?.text = String(level * 120)
        if result > 30 {
            self.backgroundNode.run(SKAction.moveBy(x:-20, y: 0, duration: 0.5))
        }
        
        
        
        let speed = result - lastPeak!
        
        
        if speed > 30 {
             let impulse = -( sqrt((abs(speed) - 20)) * 50 + 100.0)
            self.spinnyNode?.physicsBody?.applyImpulse(CGVector(dx:0.0,dy:Double(impulse)))
            
        }

        
    }
        
    
    func touchDown(atPoint pos : CGPoint) {
        
        self.backgroundNode.run(SKAction.moveBy(x: -20, y: 0, duration: 0.5))
        
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
