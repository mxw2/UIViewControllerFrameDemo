//
//  WXWaterFlowView.swift
//  PROJECT
//
//  Created by 王鑫 on 17/4/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit


var WFScreenWidth = UIScreen.main.bounds.width
public let kWaterFlowViewDefaultMargin:CGFloat = 10.0


@objc enum WaterFlowViewMarginType:Int{
    case top
    case left
    case bottom
    case right
    case columns
    case row
}

@objc
protocol WaterFlowViewDelegate:UIScrollViewDelegate{
    
    /// 每个cell返回的高度
    @objc optional func waterFlowView(_ waterFlowView:WaterFlowView,heightForRowAt index:NSInteger,cellWidth width:CGFloat) -> CGFloat
    
     /// 间距
     @objc optional func waterFlowView(_ waterFlowView:WaterFlowView,marginType:WaterFlowViewMarginType) -> CGFloat
    
    /// 点击每个cell
    @objc optional func waterFlowView(_ waterFlowView:WaterFlowView,didSelectForRowAt index:NSInteger)
    
}

@objc
protocol WaterFlowViewDataSource:NSObjectProtocol {
    
    /// cell的总数
    func numberOfCells(_ waterFlowView:WaterFlowView) -> Int
    
    /// 在indexPath位置上的cell的样式
    func waterFlowView(_ waterFlowView:WaterFlowView,cellForRowAt index: NSInteger) -> WaterFlowCell
    
    /// 瀑布流一共几列,默认3列
    @objc optional func numberOfColums(_ waterFlowView: WaterFlowView) -> Int
    
}

class WaterFlowView: UIScrollView {

    weak var dataSourceOfWaterFlow:WaterFlowViewDataSource?
    weak var delegateOfWaterFlow:WaterFlowViewDelegate?
    
    fileprivate lazy var displayingCells = Dictionary<Int, WaterFlowCell>()
    
    //MARK : - 对外暴露的刷新方法
    public func reloadData(){
       //核心就是在这里通过计算获取的瀑布流的大小等
        
        //1.获取一共数据多少
        let totalCount = dataSourceOfWaterFlow?.numberOfCells(self)
        if totalCount == 0 {
            return
        }
        
        //2.获取总列数
        let totalColumns = numberOfTotalColums()
        
        //3.获取各种间距
        let topM = marginForType(WaterFlowViewMarginType.top)
        let leftM = marginForType(WaterFlowViewMarginType.left)
        let bottomM = marginForType(WaterFlowViewMarginType.bottom)
        let rightM = marginForType(WaterFlowViewMarginType.right)
        let columsM = marginForType(WaterFlowViewMarginType.columns)
        let rowM = marginForType(WaterFlowViewMarginType.row)
        
        //4.计算具体的cell的宽度
        let cellAllWidht = WFScreenWidth - CGFloat((totalColumns-1))*columsM - leftM - rightM
        cellWidth = cellAllWidht / CGFloat(totalColumns)
        
        //计算出所有列中最大的Y值
//        CGFloat columsHeight[totalCount] ;
        var columnsHeight = Array<CGFloat>(arrayLiteral: 0.0,0.0,0.0)
        for index in 0...totalColumns-1{
           var h = columnsHeight[index]
            h = 0
        }
        
        //5.核心计算
        
        for c in 0 ... totalCount!-1 {
            //5.1计算最短的列高度
            var minColumnHeightIndex = 0
            //col的高度
            var minClumnHeight:CGFloat = columnsHeight[minColumnHeightIndex]
            for index in 0 ... totalColumns-1 {
                let h = columnsHeight[index]
                if minClumnHeight > h {
                   minColumnHeightIndex = index
                   minClumnHeight = h
                }
            }
            
            //5.2 计算frame的frame
            let cX = leftM + (columsM + cellWidth!) * CGFloat(minColumnHeightIndex)
            var cY:CGFloat = 0
            if minClumnHeight == 0.0  {
                cY = topM
            }else{
                cY = minClumnHeight + rowM
            }
            
            let cW = cellWidth
            let cH = heightForAtIndex(index: c)
            
            let frame = CGRect(x:cX,y:cY,width:cW!,height:cH)
            cellFrames.append(frame)
            
            //5.3保存一下加入后colunmns的高度
            columnsHeight[minColumnHeightIndex] = cY + cH
            
            //5.4遍历一下谁最高
            var firstHeight:CGFloat = 0
            for fh in 0 ... totalColumns-1 {
                let h = columnsHeight[fh]
                if firstHeight < h {
//                    minColumnHeightIndex = index
                    firstHeight = h
                }
            }
            
            //5.3设置self.scrollview的基本conntentSize
            contentSize = CGSize(width:WFScreenWidth,height:firstHeight+bottomM)
            
        }
        
        
    }
    //每次移动到父控件的时候，都要去刷新一下
    override func willMove(toSuperview newSuperview: UIView?) {
        reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let count = dataSourceOfWaterFlow!.numberOfCells(self)
        if count == 0 {
            return
        }
        for index in 0 ... count-1 {
//            let cell = dataSourceOfWaterFlow?.waterFlowView(self, cellForRowAt: index)
            
            let frame = cellFrames[index]
            var cell = displayingCells[index]
            
            //判断是不是在屏幕上
            if isInScreen(frame) {
                //在屏幕上
                if cell == nil {
                    //向数据源中索取，并且添加进来
                    cell = dataSourceOfWaterFlow?.waterFlowView(self, cellForRowAt: index)
                    cell?.frame = frame
                    addSubview(cell!)
                    displayingCells[index] = cell
                }
            }else{
                //不在屏幕上，去缓存池中找到
                if let c = cell {
                    //在瀑布流中移除和字典中，然后放到缓存池中
                    c.removeFromSuperview()
                    displayingCells.removeValue(forKey: index)
                    reuserCells.insert(c)
                }
            }
            
        }
    }
    
    
    //MRAK : - 内部方法
    fileprivate lazy var cellFrames:Array = Array<CGRect>()
    
    fileprivate lazy var reuserCells = Set<WaterFlowCell>()
    
    var cellWidth:CGFloat?
    
    /// 根据从用标识符来去重用池中寻找cell
    open func dequeueReusableCellWithIndentifier(reuseIdentifier:String) -> WaterFlowCell?{
        var cell:WaterFlowCell? = nil
        let rucs = reuserCells.filter { $0.identifier == reuseIdentifier}
        if let rc = rucs.first {
            //直接返回
            cell = rc
            reuserCells.remove(rc)
        }
        return cell
    }
    
    fileprivate func isInScreen(_ cellFrame:CGRect) -> Bool{
       return (cellFrame.maxY>contentOffset.y && cellFrame.origin.y<contentOffset.y+frame.size.height)
    }
    
    fileprivate func numberOfTotalColums() -> NSInteger{
        
        if ((dataSourceOfWaterFlow?.numberOfColums?(self)) != nil)
        {
          return dataSourceOfWaterFlow!.numberOfColums!(self)
        }
        else
        {
          return 3
        }
    }
    
    //获取每个间距
    fileprivate func marginForType(_ type:WaterFlowViewMarginType) -> CGFloat{
        if ((delegateOfWaterFlow?.waterFlowView?(self, marginType: type)) != nil) {
            return (delegateOfWaterFlow?.waterFlowView!(self, marginType: type))!
        }
        return kWaterFlowViewDefaultMargin
    }
    
    fileprivate func heightForAtIndex(index:NSInteger) -> CGFloat{

        if ((delegateOfWaterFlow?.waterFlowView?(self,
                                                 heightForRowAt: index,
                                                 cellWidth: cellWidth!)) != nil)
        {
            return (delegateOfWaterFlow?.waterFlowView!(self, heightForRowAt: index, cellWidth:cellWidth!))!
        }
        return CGFloat(arc4random_uniform(100)) + 50
        
    }
}
