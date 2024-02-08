//
//  ViewController.swift
//  sparrow-marathon-task3
//
//  Created by Nikita Bekish on 07.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let cubeView = UIView()
    private lazy var cubeViewCenterXConstraint = cubeView.centerXAnchor.constraint(equalTo: slider.leadingAnchor)
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        return slider
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        cubeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cubeView)
        
        cubeView.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            cubeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            cubeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            // cubeViewCenterXConstraint,
            cubeView.widthAnchor.constraint(equalToConstant: 100),
            cubeView.heightAnchor.constraint(equalToConstant: 100),
            // cubeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            slider.topAnchor.constraint(equalTo: cubeView.bottomAnchor, constant: 40),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            slider.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        slider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)
    }
    
  
    
    @objc private func sliderAction(sender: UISlider, forEvent event: UIEvent) {
        // cubeView.transform = .init(translationX: CGFloat(sender.value * 100), y: 1)
        var t = CGAffineTransform.identity
        
        let width: CGFloat = UIScreen.main.bounds.width - 100
        
        print("nik width", width)

        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("nik began")
            case .moved:
                t = t.rotated(by: CGFloat(slider.value * (.pi / 2) / slider.maximumValue))
                
                
                let result = slider.value.converting(from: 0...1, to: 1...1.5)
                t = t.scaledBy(x: CGFloat(result), y: CGFloat(result))
                
                let translatedResult = slider.value.converting(from: 0...1, to: 100...Float(width))
                let centerXOffset = slider.value.converting(from: 0...1, to: 0...37.5)
                                
                
                cubeView.layer.position.x = CGFloat(translatedResult) - CGFloat(centerXOffset)
            case .ended:
                sender.setValue(slider.maximumValue, animated: true)
                t = t.rotated(by: CGFloat(slider.value * (.pi / 2) / slider.maximumValue))
                
                let result = slider.value.converting(from: 0...1, to: 1...1.5)
                t = t.scaledBy(x: CGFloat(result), y: CGFloat(result))
                
                let translatedResult = slider.value.converting(from: 0...1, to: 100...Float(width))
                let centerXOffset = slider.value.converting(from: 0...1, to: 0...37.5)


                UIView.animate(withDuration: 0.3) {
                    self.cubeView.layer.position.x = CGFloat(translatedResult) - CGFloat(centerXOffset)
                }


                print("nik ended")
            default:
                break
            }
        }
        
        // t = t.translatedBy(x: CGFloat(sender.value * Float(width) / sender.maximumValue), y: 1)

       
        // t = t.scaledBy(x: CGFloat(sender.value / 100 * 1.5), y: CGFloat(sender.value / 100 * 1.5))
        // t = t.translatedBy(x: CGFloat(sender.value * 100), y: 1)

        UIView.animate(withDuration: 0.3) {
            self.cubeView.transform = t
        }
    }
}

extension FloatingPoint {
    func converting(from input: ClosedRange<Self>, to output: ClosedRange<Self>) -> Self {
        let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
        let y = (input.upperBound - input.lowerBound)
        return x / y + output.lowerBound
    }
}

extension BinaryInteger {
    func converting(from input: ClosedRange<Self>, to output: ClosedRange<Self>) -> Self {
        let x = (output.upperBound - output.lowerBound) * (self - input.lowerBound)
        let y = (input.upperBound - input.lowerBound)
        return x / y + output.lowerBound
    }
}

let integer = 380
let result = integer.converting(from: 10...750, to: 100...350) // 225
