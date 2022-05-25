//
//  WFShopModel.swift
//  WaterFlow
//
//  Created by 王鑫 on 16/9/16.
//  Copyright © 2016年 王鑫. All rights reserved.
//

import UIKit

class WaterFlowModel: NSObject {
    
    var w:CGFloat =  0
    var h:CGFloat = 0
    var img:String?
    var price:String?
    var widhtForPresent:CGFloat = 0
    class func waterFlowM(w:CGFloat,h:CGFloat,img:String,price:String) -> WaterFlowModel{
         let wf = WaterFlowModel()
        wf.w = w
        wf.h = h
        wf.img = img
        wf.price = price
        return wf
    }
}
