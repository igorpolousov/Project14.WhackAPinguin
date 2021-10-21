//
//  GameScene.swift
//  Project14.WhackAPinguin
//
//  Created by Igor Polousov on 18.10.2021.
//

import SpriteKit


class GameScene: SKScene {
    // Label node для отображения количества набранных очков
    var gameScore: SKLabelNode!
    // Переменная в которой задано время на которое будет появляться пингвин из норы
    var popupTime = 0.85
    // Количество раундов, будет ограничено в силу того что скорость появления/исчезновения постоянно растёт и игра может стать слишком быстрой.
    var numRounds = 0
    // Массив со слотами
    var slots = [WhackSlot]()
    // Переменная со свойством обозревателя которая считает очки  и передаёт инфо на gameScore LabelNode
    var score = 0 {
        didSet {
            gameScore.text = "score = \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        // Создана константа backGround для установки картинки фона
        let backGround = SKSpriteNode(imageNamed: "whackBackground")
        // Начальная координата для фона
        backGround.position = CGPoint(x: 512, y: 384)
        backGround.blendMode = .replace
        backGround.zPosition = -1
        addChild(backGround)
        
        // Заданы значения для gameScore, положение, размер шрифта
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score : 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        // Создание слотов 4 строки по 5 и 4 слота, со сдвигом i * 170
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))}
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))}
        //  Вызов первый раз функции createEnemy() при помощи GCD asyncAfter чтобы была задержка между запуском игры и появлением первого пингвина, чтобы игрок смог осмотреть поле
        DispatchQueue.main.asyncAfter(deadline: . now() + 1) {[weak self] in
            self?.createEnemy()
        }
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Проверка что касание !nil
        guard let touch = touches.first else { return }
        // Определение места касания
        let location = touch.location(in: self)
        // Определение node на которых произошло касание
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes { // для node до которых докоснулись
            // type casting to type WhackSlot
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            // Если слот видно и если до него дотронулись
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            // Вызвать функцию hit()
            whackSlot.hit()
            
            //Если charFriend
            if node.name == "charFriend" {
                // Выччесть очки
                score -= 5
                // Запустить звук
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            // Если charEnemy
            } else if node.name == "charEnemy" {
                // Уменьшить размер
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                // Прибавить очки
                score += 1
                // Запустить звук
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    // Функция создать слот
    func createSlot(at position: CGPoint) {
        // Создали экземляр WhackSlot
        let slot = WhackSlot()
        // Размещение слотов
        slot.configure(at: position)
        // Добавление слотов addChild
        addChild(slot)
        // Добавление слота в массив slots
        slots.append(slot)
    }
    
    // функция создать врага
    func createEnemy() {
        // При запуске функции увеличиваем число раундов на 1
        numRounds += 1
        // Проверка количества раундов
        if numRounds >= 30 {
            // Если больше или равно 30 спрятать все слоты
            for slot in slots {
                slot.hide()
            }
            // Показать надпись Game Over поверх всех node
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            return
        }
        // Если меньше 30
        popupTime *= 0.991
        // Перемешивание слотов в массиве slots
        slots.shuffle()
        //  Компонент slots с индексом 0 показать 
        slots[0].show(hideTime: popupTime)
        // В зависимости от случайного числа и сравнения этого числа с заданным числом показывать компонент slots с определенным индексом и с заданным временем появления
        if Int.random(in: 0...12) > 4 {slots[1].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 8 {slots[2].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 10 {slots[3].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 11 {slots[4].show(hideTime: popupTime)}
        
        // Задан интревал времени задержки
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        // Вызов функции createEnemy() с задержкой delay
        DispatchQueue.main.asyncAfter(deadline: . now() + delay) {[weak self] in
            self?.createEnemy()
        }
    }
}
