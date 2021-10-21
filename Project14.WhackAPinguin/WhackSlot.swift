//
//  WhackSlot.swift
//  Project14.WhackAPinguin
//
//  Created by Igor Polousov on 18.10.2021.
//

import UIKit
import SpriteKit


class WhackSlot: SKNode {
    // Создание переменной charNode
    var charNode: SKSpriteNode!
    // Создание переменной видно или нет, является условием для вызова функций show() or hide()
    var isVisible = false
    // Создание переменной дотронулись или нет
    var isHit = false
    
    // Функция конфигурации
    func configure(at position: CGPoint) {
        self.position = position
        // Добавление картинки норы
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        // Создание экземпляра cropeNode
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        // Задание masknode
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        // Создание charNode чтобы показать картинку pinguinGood
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        // Присвоение этой node имени character
        charNode.name = "character"
        // Добавление к cropNode  как addChild, parentNode->cropNode->charNode
        cropNode.addChild(charNode)
        // Добавили cropNode
        addChild(cropNode)
    }
    
    // Функция показать пингвина
    func show(hideTime: Double) {
        // Проверка видно или нет
        if isVisible { return }
       
        // Сохранить оригинальный размер изображения
        charNode.xScale = 1
        charNode.yScale = 1
        
        // Показ charNode
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
      
        isVisible = true
        isHit = false
        
        // Если число в интервале от 0 до 2  будет равно 0
        if Int.random(in: 0...2) == 0 {
            // То текстурой будет картинка с именем penguinGood
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            // и названием node будет charFriend
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        // Вызов функции hide c задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {[weak self] in
            self?.hide()
        }
    }
    
    // Функция спрятать
    func hide() {
        if !isVisible { return }
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    // Функция hit() создаёт порядок действий если до пингвина докоснулись  
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false  }
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
        smoke()
       
    }
    
    func smoke() {
        if isVisible {
            if let smokeParticles = SKEmitterNode(fileNamed: "Smoke") {
                smokeParticles.position = charNode.position
                addChild(smokeParticles)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                   smokeParticles.removeFromParent()
                }
            }
        }
    }
}
