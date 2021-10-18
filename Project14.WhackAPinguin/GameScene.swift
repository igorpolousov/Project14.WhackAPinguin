//
//  GameScene.swift
//  Project14.WhackAPinguin
//
//  Created by Igor Polousov on 18.10.2021.
//

import SpriteKit


class GameScene: SKScene {
    var gameScore: SKLabelNode!
    
    var score = 0 {
        didSet {
            gameScore.text = "score = \(score)"
        }
    }

    override func didMove(to view: SKView) {
        let backGround = SKSpriteNode(imageNamed: "whackBackGround")
        backGround.position = CGPoint(x: 512, y: 384)
        backGround.blendMode = .replace
        backGround.zPosition = -1
        addChild(backGround)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score : 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        }
        
    
}
