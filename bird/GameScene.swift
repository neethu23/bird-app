//
//  GameScene.swift
//  bird
//
//  Created by Somasekharan, Neethu on 7/19/16.
//  Copyright (c) 2016 neethu. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
   
    enum ColliderType : UInt32{
        
        case bird = 1
        case object = 2
        case gap = 4
    }
    
    var movingObjects = SKSpriteNode()
    
    var labelContainer = SKSpriteNode()
    
    
    var gameOver = false
    
    func makebg(){
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        let movebg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let movebgForever = SKAction.repeatForever(SKAction.sequence([movebg, replacebg]))
        
        // to get background continuously
        //let number:CGFloat = [0,1,2]
        //for var i:CGFloat=0, i<3, i+=1 {
        for i:CGFloat in [0,1,2]{
            //i:CGFloat {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: self.frame.midY)
            bg.size.height = self.frame.height
            
            bg.run(movebgForever)
            
            movingObjects.addChild(bg)
            
        }
        
    }
    override func didMove(to view: SKView) {
        
        
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        
        makebg()
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint( x: self.frame.midX, y: self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        bird.physicsBody!.isDynamic = true
        bird.physicsBody!.allowsRotation = false
        
        bird.physicsBody!.categoryBitMask = ColliderType.bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        self.addChild(bird)
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: 1))
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        
        self.addChild(ground)
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GameScene.makePipes), userInfo: nil, repeats: true)
        
        bg.zPosition = 1
        ground.zPosition = 2
        bird.zPosition = 6
        
    }
    
    func makePipes() {
        
        let gapHeight = bird.size.height * 4
        let movementAmount = arc4random() % UInt32(self.frame.size.height/2)
        let pipeOffSet =  CGFloat(movementAmount) - self.frame.size.height/4
        let movePipes = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: TimeInterval(self.frame.size.width/100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes , removePipes])
        
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY + pipeTexture.size().height/2 + gapHeight/2 + pipeOffSet)
        pipe1.run(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe1.physicsBody!.isDynamic = false
        
        pipe1.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        pipe1.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        
        movingObjects.addChild(pipe1)
        
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY - pipe2Texture.size().height/2 - gapHeight/2 + pipeOffSet)
        pipe2.run(moveAndRemovePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.categoryBitMask = ColliderType.object.rawValue
        pipe2.physicsBody!.contactTestBitMask = ColliderType.object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.object.rawValue
        
        movingObjects.addChild(pipe2)
        
        pipe1.zPosition = 3
        pipe2.zPosition = 4
        
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.size.width, y: self.frame.midY + pipeOffSet)
        gap.run(moveAndRemovePipes)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipe1.size.width, height: gapHeight))
        gap.physicsBody?.isDynamic = false
        
        gap.physicsBody!.categoryBitMask = ColliderType.gap.rawValue
        gap.physicsBody!.contactTestBitMask = ColliderType.bird.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.gap.rawValue
        
        movingObjects.addChild(gap)
        
        gap.zPosition = 5
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.gap.rawValue{
            
            score += 1
            scoreLabel.text = String(score)
            print(score)
            scoreLabel.zPosition = 7
            
            
        }else{
            
            if gameOver == false {
                gameOver = true
                self.speed = 0
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "game over! Tap tp play again"
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                labelContainer.addChild(gameOverLabel)
                
                gameOverLabel.zPosition = 7
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameOver == false{
            
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50))
            
        }else{
            
            score = 0
            scoreLabel.text = "0"
            bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            movingObjects.removeAllChildren()
            labelContainer.removeAllChildren()
            makebg()
            self.speed = 1
            gameOver = false
            
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}

