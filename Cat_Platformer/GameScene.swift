//
//  GameScene.swift
//  Cat_Platformer
//
//  Created by Sandi Junker on 10/21/24.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cat: SKSpriteNode!
    var pointLabel: SKLabelNode!
    var userPoints: Double = 0
    var backgroundMusic: SKAudioNode?
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    //Points
    private func setupPointLabel() {
        pointLabel = SKLabelNode(fontNamed: "Chalkduster")
        pointLabel.zPosition = 1
        pointLabel.text = "Points: \(userPoints)"
        pointLabel.fontSize = 24
        pointLabel.position = CGPoint(x: 550, y: 600)
        addChild(pointLabel)
    }
    
    //MARK: Fish functions
    private var fishTexture: SKTexture {
        return SKTexture(imageNamed: "GreenFish")
    }
    
    private func setupFish(xPosition: CGFloat, yPosition: CGFloat) {
        let fish = SKSpriteNode(texture: fishTexture, size: CGSize(width: 100, height: 100))
        fish.position = CGPoint(x: xPosition, y: yPosition)
        fish.zPosition = 2
        
        //Physics
        fish.physicsBody = SKPhysicsBody(circleOfRadius: 60)
        fish.physicsBody?.isDynamic = false
        fish.physicsBody?.allowsRotation = false
        fish.physicsBody?.affectedByGravity = false
        fish.physicsBody?.categoryBitMask = 2
        fish.physicsBody?.contactTestBitMask = 1
        
        addChild(fish)
    }
    
    //MARK: Cat player functions
    private var catAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "Cat")
    }
    
    private var catTexture: SKTexture {
            return catAtlas.textureNamed("idle0")
        }

    private func setupCat() {
        cat = SKSpriteNode(texture: catTexture, size: CGSize(width: 70 * 3, height: 46 * 3))
        cat.position = CGPoint(x: -1200, y: -400)
        cat.zPosition = 2
        
        //Physics
        cat.physicsBody = SKPhysicsBody(texture: cat.texture!, size: cat.texture!.size())
        cat.physicsBody?.isDynamic = true
        cat.physicsBody?.allowsRotation = false
        cat.physicsBody?.linearDamping = 0.75
        cat.physicsBody?.friction = 0.1
        cat.physicsBody?.categoryBitMask = 1
        cat.physicsBody?.contactTestBitMask = 2

        //World boundaries
        let boundaryX = SKConstraint.positionX(SKRange(lowerLimit: -1280, upperLimit: 1280))
        let boundaryY = SKConstraint.positionY(SKRange(lowerLimit: -800, upperLimit: 650))
        cat.constraints = [boundaryX, boundaryY]
        
        addChild(cat)
    }
    
    //MARK: Atlases
    private var catIdleTextures: [SKTexture] {
        return [
            catAtlas.textureNamed("idle0"),
            catAtlas.textureNamed("idle1"),
            catAtlas.textureNamed("idle2"),
            catAtlas.textureNamed("idle3"),
            catAtlas.textureNamed("idle4"),
            catAtlas.textureNamed("idle5"),
            catAtlas.textureNamed("idle6")
        ]
    }
    
    private var catWalkTextures: [SKTexture] {
        return [
            catAtlas.textureNamed("walk0"),
            catAtlas.textureNamed("walk1"),
            catAtlas.textureNamed("walk2"),
            catAtlas.textureNamed("walk3"),
            catAtlas.textureNamed("walk4"),
            catAtlas.textureNamed("walk5"),
            catAtlas.textureNamed("walk6")
        ]
    }
    
    private var catRunTextures: [SKTexture] {
        return [
            catAtlas.textureNamed("run0"),
            catAtlas.textureNamed("run1"),
            catAtlas.textureNamed("run2"),
            catAtlas.textureNamed("run3"),
            catAtlas.textureNamed("run4"),
            catAtlas.textureNamed("run5"),
            catAtlas.textureNamed("run6")
        ]
    }
    
    private var catJumpTextures: [SKTexture] {
        return [
            catAtlas.textureNamed("jump0"),
            catAtlas.textureNamed("jump1"),
            catAtlas.textureNamed("jump2"),
            catAtlas.textureNamed("jump3"),
            catAtlas.textureNamed("jump4"),
            catAtlas.textureNamed("jump5"),
            catAtlas.textureNamed("jump6")
        ]
    }
    
    private var catAttackTextures: [SKTexture] {
        return [
            catAtlas.textureNamed("attack0"),
            catAtlas.textureNamed("attack1"),
            catAtlas.textureNamed("attack2")
        ]
    }
    
    //MARK: Animations
    //Animations
    func startCatIdleAnimation() {
        let idleAnimation = SKAction.animate(with: catIdleTextures, timePerFrame: 0.1)
        
        cat.run(SKAction.repeatForever(idleAnimation), withKey: "catIdleAnimation")
    }
    
    func startCatXMovement(xCoor: CGFloat) {
        if (xCoor < 0) {
            cat.xScale = -1
        } else {
            cat.xScale = 1
        }
        
        let force = CGVector(dx: xCoor, dy: 0.0)
        cat.physicsBody?.applyForce(force)
        
        if ((cat.physicsBody?.velocity.dx)! < 1000.0) {
            startCatWalkAnimation()
        } else {
            startCatRunAnimation()
        }
    }
    
    func startCatWalkAnimation() {
        let walkAnimation = SKAction.animate(with: catWalkTextures, timePerFrame: 0.1)

        cat.run(walkAnimation, withKey: "catWalkAnimation")
    }
    
    func startCatRunAnimation() {
        let runAnimation = SKAction.animate(with: catRunTextures, timePerFrame: 0.15)
        
        cat.run(SKAction.repeatForever(runAnimation), withKey: "catRunAnimation")
    }
    
    func startCatJumpAnimation() {
        let jumpAnimation = SKAction.animate(with: catJumpTextures, timePerFrame: 0.1)
        let force = CGVector(dx: 0.0, dy: 1000.0)
        cat.physicsBody?.applyForce(force)
        cat.run(jumpAnimation, withKey: "catJump")
    }
    
    func startCatAttackAnimation() {
        let attackAnimation = SKAction.animate(with: catAttackTextures, timePerFrame: 0.3)
        
        cat.run(SKAction.repeatForever(attackAnimation), withKey: "catAttackAnimation")
    }
    
    //MARK: Background Music
    func setBackgroundMusic() {
        let path = Bundle.main.path(forResource: "backgroundMusic", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        let backgroundMusic = SKAudioNode(url: url)
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    //MARK: Movement Functions
    //TODO: Make animations finish before restarting
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x0D: //up right
            //TODO: Prevent flying
                startCatJumpAnimation()
        case 0x02: //right
            startCatXMovement(xCoor: 250)
        case 0x00: //left
            startCatXMovement(xCoor: -250)
        default:
            startCatIdleAnimation()
        }
    }
    
    //MARK: Basic game functions
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        self.setupPointLabel()

        self.setupCat()
        self.startCatIdleAnimation()
        
        //Create Several Fish
        self.setupFish(xPosition: 0, yPosition: 0)
        self.setupFish(xPosition: 100, yPosition: -10)
        self.setupFish(xPosition: -100, yPosition: -10)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Remove the fish and add a point when the fish and cat contact
        var fishBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            fishBody = contact.bodyB
            
            fishBody.node?.removeFromParent()
            //TODO: Correct Point Adding
            userPoints += 1
            pointLabel.text = "Points: \(userPoints)"
        }
    }
    
    override func sceneDidLoad() {
        self.setBackgroundMusic()
        
        self.lastUpdateTime = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
