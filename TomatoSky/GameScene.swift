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
    var elementsNode: SKNode!
    var scaleFactor: CGFloat!
    
    var gameOver = false
    
    override func didMove(to view: SKView) {
        gameOver = false
        
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
        
        collectables = [Collectable]()
        addCollectable(x: size.width/4 + 15, y: size.height/4 + 30)
        addCollectable(x: 2*size.width/3, y: size.height/3 + 30)
        
        //Accelerometer
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
            (accelerometerData, error) in
            self.motionUpdateHandler(accelerometerData: accelerometerData, error: error)
        })
    }
    
    func motionUpdateHandler(accelerometerData: CMAccelerometerData!, error: Error!) {
        let acceleration = accelerometerData?.acceleration
        self.xAcceleration = (CGFloat((acceleration?.x)!) * 0.75) + (self.xAcceleration * 0.25)
    }
    
    override func didSimulatePhysics() {
        // 1
        // Set velocity based on x-axis acceleration
        tomato.physicsBody?.velocity = CGVector(dx: xAcceleration * 400.0, dy: tomato.physicsBody!.velocity.dy)
        // 2
        // Check x bounds
        if tomato.position.x < -20.0 {
            tomato.position = CGPoint(x: self.size.width + 20.0, y: tomato.position.y)
        } else if (tomato.position.x > self.size.width + 20.0) {
            tomato.position = CGPoint(x: -20.0, y: tomato.position.y)
        }
    }
    
    func createBackgroundNode() -> SKNode {
        let backgroundNode = SKNode()
        
        let bgColor = UIColor(red: 192/255, green: 225/255, blue: 237/255, alpha: 1)
        let node = SKSpriteNode(color: bgColor, size: size)
        
        //node.setScale(scaleFactor) //should the background change to an image, uncomment this line
        node.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        node.position = CGPoint(x: self.size.width / 2, y: 0)
        //5
        backgroundNode.addChild(node)
        
        // 6
        // Return the completed background node
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
        tomato.tryJump()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //Como contato nao funcionou bem para ver o chao, veremos de maneira mais segura
        if gameOver {
            return
        }
        
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
        print(Int(tomato.position.y))
        
        //Parallax

        //end game if Tomato falls
        if Int(tomato.position.y) <= 0 {
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

        let fadeOut = SKTransition.fade(withDuration: 1.0)
        let gameOverScene = GameOverScene(size: self.size)
        self.view!.presentScene(gameOverScene, transition: fadeOut)
    }
}
