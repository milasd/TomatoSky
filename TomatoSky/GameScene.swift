import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0.0
    
    private var tomato: Tomato!
    private var contactManager: ContactManager!
    
    private var platforms: [Platform]!
    private var collectables: [Collectable]!
    
    var backgroundNode: SKNode!
    var scaleFactor: CGFloat!
    
    var scoreLabel: SKLabelNode!
    var scoreShape: SKShapeNode!
    
    var cameraNode: SKCameraNode!
    
    var gameOver = false
    
    override func didMove(to view: SKView) {
        gameOver = false
        GameState.sharedInstance.score = 0
        
        cameraNode = SKCameraNode()
        camera = cameraNode
        cameraNode.position.x = self.size.width/2
        cameraNode.position.y = self.size.height/2
        addChild(cameraNode)
        
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        decorateLabel(label: scoreLabel)
        
        scaleFactor = self.size.width / 320.0
        
        backgroundNode = createBackgroundNode()
        addChild(backgroundNode)
        
        contactManager = ContactManager()
        tomato = Tomato()
        physicsWorld.contactDelegate = contactManager
        tomato.position = CGPoint(x:size.width/4,y:size.height/4 + 100) //+30
        addChild(tomato)
        
        platforms = [Platform]()
        addPlatform(x: size.width/4, y: size.height/4)
        addPlatform(x: 2*size.width/3, y: size.height/3)
        addPlatform(x: size.width/5, y: size.height/2)
        addPlatform(x: 2*size.width/3, y: 2*size.height/3)
        
        
        collectables = [Collectable]()
        addCollectable(x: size.width/4 + 15, y: size.height/4 + 30)
        addCollectable(x: 2*size.width/3 + 15, y: size.height/3 + 30)
        addCollectable(x: size.width/5, y: size.height/2 + 30)
        addCollectable(x: 2*size.width/3 - 15, y: 2*size.height/3 + 30)
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
            (deviceMotion, error) in
            self.motionUpdateHandler(deviceMotion: deviceMotion!, error: error)

        })

        
        //Accelerometer
        /*motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
            (accelerometerData, error) in
            self.motionUpdateHandler(accelerometerData: accelerometerData, error: error)
        })*/
    }
    
    func motionUpdateHandler(deviceMotion: CMDeviceMotion, error: Error!) {
        let attitude = deviceMotion.attitude.roll
        self.xAcceleration = (CGFloat(attitude) * 1.5) //+ (self.xAcceleration * 0.25)
    }
    
    func decorateLabel(label: SKLabelNode) {
        label.fontSize = 20
        label.fontColor = SKColor.white
        label.position = CGPoint(x: 32, y: self.size.height-50)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        label.text = String(format: "%d", GameState.sharedInstance.score)
        addChild(label)
        
        let shape = SKShapeNode()
        shape.path = UIBezierPath(roundedRect: CGRect(x: -12, y: -12, width: 76, height: 42), cornerRadius: 5).cgPath
        shape.position = CGPoint(x: 20, y: self.size.height-50)
        shape.fillColor = UIColor(red: 247/255, green: 61/255, blue: 93/255, alpha: 1)
        shape.strokeColor = UIColor.clear
        scoreShape = shape
        addChild(scoreShape)
        
    }
    
    override func didSimulatePhysics() {
        // Check x bounds
        if tomato.position.x < -20.0 {
            tomato.position = CGPoint(x: self.size.width + 20.0, y: tomato.position.y)
        } else if (tomato.position.x > self.size.width + 20.0) {
            tomato.position = CGPoint(x: -20.0, y: tomato.position.y)
        }
    }
    
    func createBackgroundNode() -> SKNode {
        let backgroundNode = SKNode()
        
        let bgColor = UIColor(red: 6/255, green: 214/255, blue: 255/255, alpha: 1)
        let node = SKSpriteNode(color: bgColor, size: size)
        
        //node.setScale(scaleFactor) //should the background change to an image, uncomment this line
        //node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        //node.position = CGPoint(x: self.size.width / 2, y: 0)
        //backgroundNode.addChild(node)
        cameraNode.addChild(node)

        return backgroundNode
    }
    
    func addPlatform(x: CGFloat, y: CGFloat) {
        let p = Platform()
        
        p.position = CGPoint(x: x, y: y)
        platforms.append(p)
        addChild(p)
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
        
        if tomato.position.y > 100 + cameraNode.position.y {
            cameraNode.position.y = tomato.position.y - 100
        }
        
        if gameOver {
            return
        }
        
        scoreLabel.text = String(format: "%d", GameState.sharedInstance.score)
        scoreLabel.position = CGPoint(x: 32, y: self.size.height/2 + cameraNode.position.y-50)
        scoreShape.position = CGPoint(x: 20, y: self.size.height/2 + cameraNode.position.y-50)
        
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
        if let pl = searchFloor(nodes: nodes(at: floorP)){
            tomato.isOnGround = true
            //tomato.physicsBody?.isDynamic = false
        }
        else{
            tomato.isOnGround = false
        }
        print(tomato.isOnGround)
        
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
    
    func endGame() {
        gameOver = true
        GameState.sharedInstance.saveState()
        

        let fadeOut = SKTransition.fade(withDuration: 1.0)
        let gameOverScene = GameOverScene(size: self.size)
        self.view!.presentScene(gameOverScene, transition: fadeOut)
    }
}


