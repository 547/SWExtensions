//
//  UIImageExtension.swift
//  SWExtensions
//
//  Created by Seven on 2019/6/17.
//  Copyright © 2019 CYCON.com. All rights reserved.
//

import UIKit

extension UIImage {
    ///MARK:旋转图片
    public func rotate(orientation:UIImage.Orientation) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        return UIImage.init(cgImage: cgImage, scale: self.scale, orientation: orientation)
    }
}
extension UIImage {
    public func resized(_ percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    public func resized(_ newSize: CGSize) -> UIImage? {
        let canvasSize = newSize
        //MARK:使用UIScreen.main.scale替代self.scale可以避免绘制出来的image模糊
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
// MARK: Color pickers
extension UIImage {
    public func compressImage(memsize:Int, byteUnits:ByteUnits) -> Data?{
        var compress:CGFloat = 0.4
        var imageData:Data
        if let jpgData = self.jpegData(compressionQuality: compress) {
            imageData = jpgData
        } else if let pngData = self.pngData() {
            imageData = pngData
        } else { return nil }
        let byteSize = byteUnits.getBytes(with: memsize)
        while imageData.count > byteSize && compress > 0.000001 {
            compress -= 0.001
            guard let data = self.jpegData(compressionQuality: compress) else { break }
            imageData = data
        }
        return imageData.count > byteSize ? nil : imageData
    }
}
public enum ByteUnits:String {
    case B = "bytes"
    case KB = "k"
    case MB = "m"
    case GB = "g"
    case TB = "t"
    //MARK:转成byte
    public func getBytes(with size:Int) -> Int {
        let baseUnit = 1024.0
        switch self {
        case .B:
            return size
        case .KB:
            return size * Int(baseUnit)
        case .MB:
            return size * Int(pow(baseUnit, 2.0))
        case .GB:
            return size * Int(pow(baseUnit, 3.0))
        case .TB:
            return size * Int(pow(baseUnit, 4.0))
        }
    }
    //MARK:向上转换
    public func upwardConversion(with bytes:Int) -> Int {
        let baseUnit = 1024.0
        switch self {
        case .B:
            return bytes
        case .KB:
            return bytes / Int(baseUnit)
        case .MB:
            return bytes / Int(pow(baseUnit, 2.0))
        case .GB:
            return bytes / Int(pow(baseUnit, 3.0))
        case .TB:
            return bytes / Int(pow(baseUnit, 4.0))
        }
    }
}
