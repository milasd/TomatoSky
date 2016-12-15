import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0.0
    
    private var tomato: Tomato!
    private var contactManager: ContactManager!
    
    private var platforms: [Platform] = []
    private var collectables: [Collectable]!
    
    var backgroundNode: SKSpriteNode!
    var midgroundNode: SKSpriteNode!
    var midgroundNodeNext: SKSpriteNode!
    var scaleFactor: CGFloat!
    
    var scoreLabel: SKLabelNode!
    var scoreShape: SKShapeNode!
    
    var cameraNode: SKCameraNode!
    
    var gameOver = false
    
    var floor: SKSpriteNode!
    
    var cont: Int = 0
    
    override func didMove(to view: SKView) {
        gameOver = false
        GameState.sharedInstance.score = 0
        
        cameraNode = SKCameraNode()
        camera = cameraNode
        cameraNode.position.x = self.size.width/2
        cameraNode.position.y = self.size.height/2
        addChild(cameraNode)
        
        scoreLabel = SKLabelNode(fontNamed: "Avenir-Black")
        decorateLabel(label: scoreLabel)
        
        scaleFactor = self.size.width / 320.0
        
        backgroundNode = createBackgroundNode()
        addChild(backgroundNode)
        midgroundNode = createClouds()
        midgroundNodeNext = createClouds()
        midgroundNodeNext.position.x = midgroundNode.position.x - size.width
        
        
        contactManager = ContactManager()
        tomato = Tomato()
        physicsWorld.contactDelegate = contactManager
        tomato.position = CGPoint(x:size.width/2, y:30) //+30
        addChild(tomato)
        
        platforms = [Platform]()
        addPlatform(x: size.width/4, y: size.height/4)
        addPlatform(x: 2*size.width/3, y: size.height/3)
        addPlatform(x: size.width/5, y: size.height/2)
        addPlatform(x: 2*size.width/3, y: 2*size.height/3)
        addPlatform(x: size.width/5, y: 4*size.height/5)
        addPlatform(x: size.width/2, y: size.height)
        addPlatform(x:4*size.width/3, y: 2*size.height/3)
        addPlatform(x: size.width/2 + 20, y: 6*size.height/5)
        addPlatform(x: 10, y: 900)
        addPlatform(x: 300, y: 1000)
//        addPlatform(x: 180, y: 1150)
//        addPlatform(x: 220, y: 1320)
//        addPlatform(x: 90, y: 1420)
//        addPlatform(x: 100, y: 1600)
        
        
        collectables = [Collectable]()
        addCollectable(x: size.width/4 + 15, y: size.height/4 + 30)
        addCollectable(x: 2*size.width/3 + 15, y: size.height/3 + 30)
        addCollectable(x: size.width/5, y: size.height/2 + 30)
        addCollectable(x: 2*size.width/3 - 15, y: 2*size.height/3 + 30)
        addCollectable(x:4*size.width/3 + 15, y: 2*size.height/3 + 30)
        addCollectable(x: size.width/2 + 20 + 15, y: 6*size.height/5 + 30)
//        addCollectable(x: 180 + 15, y: 1150 + 30)
//        addCollectable(x: 220 + 15, y: 1320 + 30)
//        addCollectable(x: 100 + 15, y: 1600 + 30)
        
        addGroundFloor(x: 0, y: 0)
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
            (deviceMotion, error) in
            self.motionUpdateHandler(deviceMotion: deviceMotion!, error: error)

        })
    }
    
    func motionUpdateHandler(deviceMotion: CMDeviceMotion, error: Error!) {
        //let attitude = deviceMotion.attitude.roll
        let attitude = deviceMotion.attitude.quaternion.y
        print(attitude)
        self.xAcceleration = (CGFloat(attitude) * 4.5) //+ (self.xAcceleration * 0.25)
    }
    
    func decorateLabel(label: SKLabelNode) {
        let shape = SKShapeNode()
        
        shape.path = UIBezierPath(roundedRect: CGRect(x: -12, y: -15, width: 76, height: 42), cornerRadius: 5).cgPath
        shape.position = CGPoint(x: 20, y: self.size.height-50)
        shape.fillColor = UIColor(red: 247/255, green: 61/255, blue: 93/255, alpha: 1)
        shape.strokeColor = UIColor.clear
        scoreShape = shape
        scoreShape.zPosition = 5
        addChild(scoreShape)
        
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 46, y: self.size.height-50)
        label.text = String(format: "%d", GameState.sharedInstance.score)
        label.zPosition = 6
        
        addChild(label)
        
    }
    
    override func didSimulatePhysics() {
        // Check x bounds
        if tomato.position.x < -20.0 {
            tomato.position = CGPoint(x: self.size.width + 20.0, y: tomato.position.y)
        } else if (tomato.position.x > self.size.width + 20.0) {
            tomato.position = CGPoint(x: -20.0, y: tomato.position.y)
        }
    }
    
    func createBackgroundNode() -> SKSpriteNode {
        let backgroundNode = SKSpriteNode()
        
        let bgColor = UIColor(red: 6/255, green: 214/255, blue: 255/255, alpha: 1)
        let colorNode = SKSpriteNode(color: bgColor, size: size)
        colorNode.zPosition = 0
        
        //node.setScale(scaleFactor) //should the background change to an image, uncomment this line
        //node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        //node.position = CGPoint(x: self.size.width / 2, y: 0)
        //backgroundNode.addChild(node)
        cameraNode.addChild(colorNode)
        
        return backgroundNode
    }
    
    func createClouds() -> SKSpriteNode {
        let midgroundNode = SKSpriteNode()
        
        let cloud1 = SKSpriteNode(imageNamed: "nuvem")
        let cloud2 = SKSpriteNode(imageNamed: "nuvem")
        let cloud3 = SKSpriteNode(imageNamed: "nuvem")
        let cloud4 = SKSpriteNode(imageNamed: "nuvem")
        
        cloud1.alpha = 0.75
        cloud2.alpha = 0.75
        cloud3.alpha = 0.75
        cloud4.alpha = 0.75
        
        cloud1.position = CGPoint(x: 0, y: 0)
        cloud1.zPosition = 1
        midgroundNode.addChild(cloud1)
        cloud2.position = CGPoint(x: -60, y: -180)
        cloud2.zPosition = 1
        midgroundNode.addChild(cloud2)
        cloud3.position = CGPoint(x: 80, y: 160)
        cloud3.zPosition = 1
        midgroundNode.addChild(cloud3)
        cloud4.position = CGPoint(x: -100, y: 195)
        cloud4.zPosition = 1
        midgroundNode.addChild(cloud4)
        
        cameraNode.addChild(midgroundNode)
        
        return midgroundNode
    }
    
    func moveSprite(sprite: SKSpriteNode,
                    nextSprite: SKSpriteNode, speed: CGFloat) -> Void {
        for spriteToMove in [sprite, nextSprite] {
            
            spriteToMove.position.x += speed
            
            if spriteToMove.frame.minX > self.frame.maxX {
                spriteToMove.position =
                    CGPoint(x: spriteToMove.position.x -
                        spriteToMove.size.width * 2,
                            y: spriteToMove.position.y)
            }
            
        }
    }
    
    func addPlatform(x: CGFloat, y: CGFloat) {
        let p = Platform()
        
        p.position = CGPoint(x: x, y: y)
        platforms.append(p)
        addChild(p)
    }
    
    func addGroundFloor(x: CGFloat, y: CGFloat) {
        let f = GroundFloor()
        
        f.position = CGPoint(x: x, y: y)
        addChild(f)
    }
    
    func addCollectable(x: CGFloat, y: CGFloat) {
        let c = Collectable()
        
        c.position = CGPoint(x: x, y: y)
        collectables.append(c)
        addChild(c)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if (tomato.physicsBody?.isDynamic)! {
            print("a")
        }*/
        //tomato.physicsBody?.isDynamic = true
        super.touchesBegan(touches, with: event)
        tomato.tryJump()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //Como contato nao funcionou bem para ver o chao, veremos de maneira mais segura
        super.update(currentTime)
        
        // Move camera if tomato jumps high
        if tomato.position.y > 100 + cameraNode.position.y {
            cameraNode.position.y = tomato.position.y - 100
        }
        
        if gameOver {
            return
        }
        
        //Cloud Parallax
        self.moveSprite(sprite: midgroundNode, nextSprite: midgroundNodeNext, speed: 0.08)
        
        scoreLabel.text = String(format: "%d", GameState.sharedInstance.score)
        scoreLabel.position = CGPoint(x: 46, y: self.size.height/2 + cameraNode.position.y-50)
        scoreShape.position = CGPoint(x: 20, y: self.size.height/2 + cameraNode.position.y-48)
        
        //Scale label font
        if scoreLabel.frame.width > 74 {
            let scalingFactor = 74 / scoreLabel.frame.width
            scoreLabel.fontSize *= scalingFactor
        }
        
        // Set velocity based on x-axis acceleration
        tomato.physicsBody?.velocity = CGVector(dx: xAcceleration * 400.0, dy: tomato.physicsBody!.velocity.dy)
        
        // Tomato-Platform collision
        if let body = tomato.physicsBody {
            let dy = body.velocity.dy

            if dy > 0 {
                // Prevent collisions if the Tomato is jumping
                body.collisionBitMask = 0
            }
            else {
                // Allow collisions if the Tomato is falling
                body.collisionBitMask = Mask.platform.rawValue
            }
        }
        
        //Check floor?
        let floorP = CGPoint(x:tomato.position.x,y:tomato.position.y-tomato.radius-0.3)
        if let pl = searchFloor(nodes: nodes(at: floorP)) {
            tomato.isOnGround = true
            //tomato.physicsBody?.isDynamic = false
        }
        else if let pl = searchFloor2(nodes: nodes(at: floorP)) {
            tomato.isOnGround = true
        }
        else {
            tomato.isOnGround = false
        }
    
        //print(tomato.isOnGround)
        
        if let i = platforms.index(where: {$0.position.y < (cameraNode.position.y - self.size.height/2)}) {
            platforms[i].removeFromParent()
            platforms.remove(at: i)
            print("remove")
            let p = generate(x: (platforms.last?.position.x)!, y: (platforms.last?.position.y)!, size: size)
            addPlatform(x: p.0, y: p.1)
            cont += 1
            print("add \(cont)")
        }
        
        //Parallax

        //end game if Tomato falls
        if (tomato.position.y) <= (cameraNode.position.y - self.size.height/2) {
            endGame()
        }
    }
    
    private func searchFloor(nodes : [SKNode]) -> Platform? {
        for nd in nodes {
            if let p = nd as? Platform {
                return p
            }
        }
        return nil
    }
    
    private func searchFloor2(nodes : [SKNode]) -> GroundFloor? {
        for nd in nodes {
            if let p = nd as? GroundFloor {
                return p
            }
        }
        return nil
    }
    
    func endGame() {
        gameOver = true
        GameState.sharedInstance.saveState()
        

        let fadeOut = SKTransition.fade(withDuration: 1.0)
        let gameOverScene = GameOverScene(size: self.size)
        self.view!.presentScene(gameOverScene, transition: fadeOut)
    }
}


