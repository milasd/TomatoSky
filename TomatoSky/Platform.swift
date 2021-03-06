import SpriteKit

class Platform: SKSpriteNode {
    
    //let floor: SKSpriteNode!
    
    init(){
        let s = CGSize(width: 100, height: 18)
        //floor = SKSpriteNode(imageNamed: "plataformaGrande")
        //floor.size = s
        super.init(texture: nil, color: UIColor(red: 119/255, green: 69/255, blue: 61/255, alpha: 1), size: s)
        physicsBody = Platform.createPhysics(size: s)
        //addChild(floor)
        
        let shape = SKShapeNode()
        shape.path = UIBezierPath(roundedRect: CGRect(x: -50, y: -9, width: 100, height: 18), cornerRadius: 5).cgPath
        shape.position = CGPoint(x: frame.midX, y: frame.midY)
        //shape.fillColor = UIColor(red: 119/255, green: 69/255, blue: 61/255, alpha: 1)
        addChild(shape)
        
        
    }
    
    private class func createPhysics(size: CGSize) -> SKPhysicsBody {
        let p = SKPhysicsBody(rectangleOf: size)
        
        p.friction = 0.5
        p.angularDamping = 1
        p.usesPreciseCollisionDetection = true
        p.categoryBitMask = Mask.platform.rawValue
        p.isDynamic = false
        
        return p
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
