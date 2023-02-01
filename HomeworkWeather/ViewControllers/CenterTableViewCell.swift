//
//  CenterTableViewCell.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 19.01.23.
//

import UIKit

class CenteredTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = imageView,
              imageView.image != nil,
              let textLabel = textLabel
        else{
            return
            
        }
        

        let imageHeight = imageView.frame.height
        let textHeight = textLabel.frame.height
        
        
        imageView.frame = CGRect(x: contentView.center.x - imageHeight/2,
                                 y: (contentView.frame.height - imageHeight/2 - textHeight/2)/2,
                                 width: imageHeight,
                                 height: imageHeight)
        
        textLabel.frame = CGRect(x: contentView.center.x - textLabel.frame.width/2,
                                 y: imageView.frame.minY,
                                 width: textLabel.frame.width,
                                 height: textHeight)
        
    }
}
