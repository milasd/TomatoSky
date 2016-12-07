import SpriteKit

class ContactManager: NSObject, SKPhysicsContactDelegate {
    
    /* Set important references
    let world : ...
    ....
 
    init(world : ...){
        self.world = world
    }
    */
    
    func didBegin(_ contact: SKPhysicsContact) {
        let ndA: SKNode
        var ndB: SKNode
        
        //Safe check
        if let p = sortAndCheck(contact: contact){
            ndA = p.0
            ndB = p.1
        } else { return }
        //Tomato always the lesser mask
        let tom = ndA as! Tomato
        
        if ndB.isKind(of: Platform.self){
            if checkGround(tom, ndB as! Platform) {
                //tom.touchedGround() Nao funcionou tao bem, SpriteKit bugado =( ver GameScene
            }
        }
        if ndB.isKind(of: Collectable.self) {
            GameState.sharedInstance.score += 200
            ndB.removeFromParent()
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let ndA : SKNode, ndB : SKNode
        if let p = sortAndCheck(contact: contact){
            ndA = p.0
            ndB = p.1
        } else{ return }
        let tom = ndA as! Tomato
        if ndB.isKind(of: Platform.self){
            if checkGround(tom, ndB as! Platform){
                //tom.leftGround() Nao funcionou tao bem infelizmente, SpriteKit bugado =( ver GameScene
                //tom.physicsBody = Tomato.createPhysics(radius: 30) testar se está mudando depois de colidir
                //tom.physicsBody!.velocity.dx = 0
            }
        }
    }
    
    func sortAndCheck(contact: SKPhysicsContact)->(SKNode,SKNode)?{
        if contact.bodyA.node == nil || contact.bodyB.node == nil {
            return nil
        }
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            return (contact.bodyA.node!,contact.bodyB.node!)
        }
        return (contact.bodyB.node!,contact.bodyA.node!)
    }
    
    func checkGround(_ tom: Tomato, _ plat: Platform) -> Bool {
        let pt = tom.position
        let pp = plat.position
        return pt.y>pp.y && abs(pt.x-pp.x)<plat.size.width/2
    }
    
    
}
