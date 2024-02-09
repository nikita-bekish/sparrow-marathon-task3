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
    private let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = true
        return slider
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 100
        
        return stackView
    }()
    
    private let width: CGFloat = UIScreen.main.bounds.width - 100

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(cubeView)
        stackView.addArrangedSubview(slider)
        view.addSubview(stackView)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 40, leading: 50, bottom: 10, trailing: 50)
                
        cubeView.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            cubeView.widthAnchor.constraint(equalToConstant: 100),
            cubeView.heightAnchor.constraint(equalToConstant: 100),
            
            slider.heightAnchor.constraint(equalToConstant: 10),
            slider.widthAnchor.constraint(equalToConstant: width)
        ])
        
        slider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)
    }
    
    @objc private func sliderAction(sender: UISlider, forEvent event: UIEvent) {
        var t = CGAffineTransform.identity

        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .moved, .began, .ended:
                
                if touchEvent.phase == .ended {
                    sender.setValue(slider.maximumValue, animated: true)
                }
                
                let scaledResult = slider.value.converting(from: 0...1, to: 1...1.5)
                let translatedResult = slider.value.converting(from: 0...1, to: 100...Float(width))
                let centerXOffset = slider.value.converting(from: 0...1, to: 0...37.5)
                
                t = t.rotated(by: CGFloat(slider.value * (.pi / 2) / slider.maximumValue))
                t = t.scaledBy(x: CGFloat(scaledResult), y: CGFloat(scaledResult))
                
                if touchEvent.phase == .ended {
                    UIView.animate(withDuration: 0.3) {
                        self.cubeView.layer.position.x = CGFloat(translatedResult) - CGFloat(centerXOffset)
                    }
                } else {
                    cubeView.layer.position.x = CGFloat(translatedResult) - CGFloat(centerXOffset)
                }
                
            default:
                break
            }
        }

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
