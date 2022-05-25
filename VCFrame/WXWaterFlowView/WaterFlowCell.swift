//
//  WaterFlowCell.swift
//  WaterFlowView
//
//  Created by 王鑫 on 17/4/23.
//  Copyright © 2017年 王鑫. All rights reserved.
//

import UIKit
class WaterFlowCell: UIView {

    var identifier:String?
    private lazy var imageView:UIImageView = UIImageView()
    private lazy var lable:UILabel = UILabel()
    
    var shopM:WaterFlowModel?{
        didSet{
            imageView.image = UIImage.init(named: "WaterFlowView.bundle/placeholder")
            lable.text = (shopM!.price)!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(lable)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        lable.frame = CGRect(x:0,y:self.bounds.height - 10,width:WFScreenWidth,height:10)
        
    }
    
}
