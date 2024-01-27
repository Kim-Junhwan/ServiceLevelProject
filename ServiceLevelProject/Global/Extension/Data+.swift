//
//  Data+.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import Foundation
import UIKit

extension Data {
    func downSamplingImage(maxSize:CGFloat) -> UIImage {
        let sourceOptions = [kCGImageSourceShouldCache:false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(self as CFData, sourceOptions) else { return UIImage() }
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways:true,
            kCGImageSourceThumbnailMaxPixelSize: maxSize * UIScreen.main.scale,
            kCGImageSourceShouldCacheImmediately:true,
            kCGImageSourceCreateThumbnailWithTransform:true
        ] as CFDictionary
        guard let downsampledCGImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else {
            return UIImage()
        }
        return UIImage(cgImage: downsampledCGImage, scale: 1.0, orientation: .up)
    }
}
