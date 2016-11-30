import SpriteKit

class Platform: SKSpriteNode {
    
    init(){
        let s = CGSize(width: 100, height: 18)
        super.init(texture: nil, color: UIColor.red, size: s)
        physicsBody = Platform.createPhysics(size: s)
    }
    
    private class func createPhysics(size: CGSize) -> SKPhysicsBody {
        let p = SKPhysicsBody(rectangleOf: size)
        p.friction = 0
        p.categoryBitMask = Mask.platform.rawValue
        p.isDynamic = false
        return p
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
