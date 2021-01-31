//
//  LWGradientButton.swift
//  Wallpaper
//
//  Created by 李伟 on 2021/1/31.
//

import Foundation
class LWGradientButton: UIButton {
    var gradientColors: [UIColor]?
    func setGradientColor(_ colors: [UIColor]) -> Void {
        if (colors.count == 1) {
            self.setTitleColor(colors.first, for: .normal)
        }else {
            //有多种颜色，需要渐变层对象来上色
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: self.titleLabel?.frame.size.width ?? 0 , height: self.titleLabel?.frame.size.height ?? 0 + 3)
            let gradientColors = NSMutableArray()
            for colorItem in colors {
                gradientColors.add(colorItem.cgColor)
            }
            gradientLayer.colors = gradientColors as? [Any]
            //下一步需要将CAGradientLayer对象绘制到一个UIImage对象上，以便使用这个UIImage对象来填充按钮的字体
            let gradientImage = image(from: gradientLayer)!
            self.setTitleColor(UIColor(patternImage: gradientImage), for: .normal)
        }
    }
    
    //将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
   private func image(from layer: CALayer) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return outputImage
   }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let colors = gradientColors {
            setGradientColor(colors)
        }
    }
}
