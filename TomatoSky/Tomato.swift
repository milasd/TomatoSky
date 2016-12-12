import SpriteKit

public class Tomato: SKNode {
    
    let sprite: SKSpriteNode

    var isOnGround = true
    
    var jumpSpeed: CGFloat = 700
    
    let radius: CGFloat = 20
    
    override init(){
        sprite = SKSpriteNode(imageNamed: "Tomatinho")
        sprite.size = CGSize(width: 2*radius, height: 2*radius)
        super.init()
        physicsBody = Tomato.createPhysics(radius: radius)
        addChild(sprite)
    }
    
    public class func createPhysics(radius : CGFloat) -> SKPhysicsBody {
        let p = SKPhysicsBody(circleOfRadius: radius)
        
        p.friction = 0.5
        p.categoryBitMask = Mask.tomato.rawValue
        p.collisionBitMask = Mask.platform.rawValue
        p.contactTestBitMask = Mask.platform.rawValue
        p.angularDamping = 0
        p.linearDamping = 0
        p.allowsRotation = false
        p.usesPreciseCollisionDetection = true
        p.restitution = 0
        p.isDynamic = true
        
        return p
    }
    
    func update(){
        
    }
    
    func tryJump(){
        if isOnGround {
            physicsBody!.velocity.dy = jumpSpeed
            //physicsBody!.velocity.dx = jumpSpeed/2
        }
    }
    
    /*
    func touchedGround(){
        isOnGround = true
    }
    
    func leftGround(){
        isOnGround = false
    }*/
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
