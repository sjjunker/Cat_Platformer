//
//  GameScene.swift
//  Cat_Platformer
//
//  Created by Sandi Junker on 10/21/24.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    var cat: SKSpriteNode!
    var backgroundMusic: SKAudioNode?
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    //MARK: Cat player functions
    private var catAtlas: SKTextureAtlas {
        return SKTextureAtlas(named: "Cat")
    }
    
    private var catTexture: SKTexture {
            return catAtlas.textureNamed("idle0")
        }
    
    //Textures
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
    
    private func setupCat() {
        cat = SKSpriteNode(texture: catTexture, size: CGSize(width: 70 * 3, height: 46 * 3))
        cat.position = CGPoint(x: -1200, y: -400)
        cat.zPosition = 2
        cat.physicsBody = SKPhysicsBody(texture: cat.texture!, size: cat.texture!.size())
        cat.physicsBody?.isDynamic = true
        cat.physicsBody?.allowsRotation = false
        addChild(cat)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        self.setupCat()
        self.startCatIdleAnimation()
    }
    
    //Animations
    func startCatIdleAnimation() {
        let idleAnimation = SKAction.animate(with: catIdleTextures, timePerFrame: 0.3)
        
        cat.run(SKAction.repeatForever(idleAnimation), withKey: "catIdleAnimation")
    }
    
    func startCatWalkAnimation() {
        let walkAnimation = SKAction.animate(with: catWalkTextures, timePerFrame: 0.3)
        
        cat.run(SKAction.repeatForever(walkAnimation), withKey: "catWalkAnimation")
    }
    
    func startCatRunAnimation() {
        let runAnimation = SKAction.animate(with: catRunTextures, timePerFrame: 0.3)
        
        cat.run(SKAction.repeatForever(runAnimation), withKey: "catRunAnimation")
    }
    
    func startCatJumpAnimation() {
        let jumpAnimation = SKAction.animate(with: catJumpTextures, timePerFrame: 0.3)
        
        cat.run(SKAction.repeatForever(jumpAnimation), withKey: "catJumpAnimation")
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
    
    //MARK: Basic game functions
    override func sceneDidLoad() {
        
        self.setBackgroundMusic()
        
        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    //MARK: Movement Functions
    
    
    
    //MARK: Default movement functions?
    /*func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }*/
    
    
    //TODO: Work out kinks in movement
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x0D: //up
            startCatJumpAnimation()
            let moveNodeUp = SKAction.moveBy(x:500.0, y:500.0, duration:1.0)
            cat.run(moveNodeUp, withKey: "catJump")
        case 0x02: //right
            startCatWalkAnimation()
            let moveNodeLeft = SKAction.moveBy(x:-300.0, y:0.0, duration:1.0)
            cat.run(SKAction.repeatForever(moveNodeLeft), withKey: "catLeft")
        case 0x00: //left
            startCatWalkAnimation()
            let moveNodeRight = SKAction.moveBy(x:300.0, y:0.0, duration:1.0)
            cat.run(SKAction.repeatForever(moveNodeRight), withKey: "catRight")
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
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
