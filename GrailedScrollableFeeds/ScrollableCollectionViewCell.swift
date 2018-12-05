//
//  ScrollableCollectionViewCell.swift
//  GrailedScrollableFeeds
//
//  Created by Chris Mauldin on 12/5/18.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit
import Kingfisher

class ScrollableCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageV: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var title: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    var whenPublished: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()
    
    func setUpLayout() {
        addSubview(imageV)
        imageV.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageV.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageV.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        imageV.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(title)
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        title.topAnchor.constraint(equalTo: imageV.bottomAnchor, constant: 5).isActive = true
        title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
        
        addSubview(whenPublished)
        whenPublished.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        whenPublished.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        whenPublished.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
    }
    
    public func configureImage(url: String) {
        let resourceURL = URL(string: url)!
        self.imageV.kf.setImage(with: resourceURL, options: [.transition(.fade(0.3))])
    }
}
