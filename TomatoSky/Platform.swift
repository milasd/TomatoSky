import SpriteKit

class Platform: SKSpriteNode {
    
    init(){
        let s = CGSize(width: 100, height: 18)
        super.init(texture: nil, color: UIColor(red: 119/255, green: 69/255, blue: 61/255, alpha: 1), size: s)
        physicsBody = Platform.createPhysics(size: s)
    }
    
    private class func createPhysics(size: CGSize) -> SKPhysicsBody {
        let p = SKPhysicsBody(rectangleOf: size)
        
        p.friction = 1
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
