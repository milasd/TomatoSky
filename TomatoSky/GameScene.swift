import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var tomato : Tomato!
    private var contactManager : ContactManager!
    
    private var platforms : [Platform]!
    
    override func didMove(to view: SKView) {
        
        contactManager = ContactManager()
        tomato = Tomato()
        physicsWorld.contactDelegate = contactManager
        tomato.position = CGPoint(x:size.width/4,y:size.height/2)
        addChild(tomato)
        
        platforms = [Platform]()
        addPlatform(x: size.width/4, y: size.height/4)
        addPlatform(x: 2*size.width/3, y: size.height/3)
    }
    
    func addPlatform(x: CGFloat, y: CGFloat){
        let p = Platform()
        p.position = CGPoint(x: x, y: y)
        platforms.append(p)
        addChild(p)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tomato.tryJump()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //Como contato nao funcionou bem para ver o chao, veremos de maneira mais segura
        let floorP = CGPoint(x:tomato.position.x,y:tomato.position.y-tomato.radius-0.3)
        if let pl = searchFloor(nodes: nodes(at: floorP)){
            tomato.isOnGround = true
        }
        else{
            tomato.isOnGround = false
        }
        print(tomato.isOnGround)
    }
    
    private func searchFloor(nodes : [SKNode]) -> Platform?{
        for nd in nodes{
            if let p = nd as? Platform{
                return p
            }
        }
        return nil
    }
}
