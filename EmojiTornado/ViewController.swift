//
//  ViewController.swift
//  EmojiTornado
//
//  Created by iGuest on 5/11/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let emojis = [
        "😀",
        "😃",
        "😄",
        "😁",
        "😆",
        "😅",
        "😂",
        "😈",
        "👿",
        "👹",
        "👺",
        "💩",
        "👻",
        "💀",
        "👽",
        "👾",
        "🤖",
        "🎃"
    ]
    
    let textLayer = CATextLayer()
    let fontSize: CGFloat = 30.0
    let fontColor = UIColor(white: 0.1, alpha: 1.0)
    let emitterLayer = CAEmitterLayer()
    
    let fallRate: CGFloat = 72
    let spinRange: CGFloat = 5
    let birthRate: Float = 6
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.masksToBounds = true
        
        configureTextLayer()
        configureEmitterLayer()
        
        beginRotatingIn3D() //tornado method
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emitterLayer.frame = view.bounds
        
        let paddingAboveScreen = view.bounds.height
        emitterLayer.emitterPosition = CGPoint(x: emitterLayer.frame.midX, y: -paddingAboveScreen / 2)
        emitterLayer.emitterSize = CGSize(width: emitterLayer.frame.width, height: paddingAboveScreen)
        
    }

//Mark: raining emojis
    func configureTextLayer() {
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.fontSize = fontSize
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = fontColor.cgColor
        textLayer.frame = CGRect(x: 0, y: 0, width: fontSize * 2.0, height: fontSize * 2.0)
    }

    func configureEmitterLayer() {
        emitterLayer.contentsScale = UIScreen.main.scale
        
        emitterLayer.preservesDepth = true
        
        emitterLayer.emitterMode = kCAEmitterLayerVolume
        emitterLayer.emitterShape = kCAEmitterLayerRectangle
        
        emitterLayer.emitterCells = generateEmitterCells()
        
        view.layer.addSublayer(emitterLayer)
    }
    
    func generateEmitterCells() -> [CAEmitterCell] {
        var emitterCells = Array<CAEmitterCell>()
        for emoji in self.emojis {
            let emitterCell = emitterCellWith(text:emoji)
            emitterCells.append(emitterCell)
        }
        
        return emitterCells
    }
    
    func emitterCellWith(text:String) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        
        emitterCell.contentsScale = UIScreen.main.scale
        emitterCell.contents = cgImageFrom(text: text)
        
        emitterCell.birthRate = birthRate
        emitterCell.lifetime = Float(view.bounds.height * 2 / fallRate) //(Distance / time)
        
        emitterCell.velocity = fallRate
        emitterCell.emissionLongitude = CGFloat.pi * 0.5
        emitterCell.emissionRange = CGFloat.pi * 0.25
        
        emitterCell.spinRange = spinRange
        
        return emitterCell
    }
    
    func cgImageFrom(text: String) -> CGImage? {
        textLayer.string = text
        
        UIGraphicsBeginImageContextWithOptions(textLayer.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        textLayer.render(in: context)
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return renderedImage?.cgImage
    }
    
//MARK: Tornado Emojis
    func beginRotatingIn3D() {
        view.layer.sublayerTransform.m34 = 1 / 500.0
        
        let rotationAnimation = infiniteRotationAnimation()
        emitterLayer.add(rotationAnimation, forKey: "lsfuvsv")
    }
    
    func infiniteRotationAnimation() -> CABasicAnimation{
        let rotation = CABasicAnimation(keyPath: "transform.rotation.y")
        
        rotation.toValue = 4 * Double.pi
        rotation.duration = 10
        
        rotation.isCumulative = true
        rotation.repeatCount = HUGE
        
        return rotation
    }
}

