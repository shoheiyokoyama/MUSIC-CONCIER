//
//  ActivityIndicatorView.swift
//  utakata
//
//  Created by 横山祥平 on 2015/09/02.
//  Copyright (c) 2015年 Shohei. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActivityIndicatorView: UIView {
    
    internal var activityView: NVActivityIndicatorView
    
    override init (frame: CGRect) {
        activityView = NVActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - 30) / 2, (UIScreen.mainScreen().bounds.size.height - 30.0) / 2, 30.0, 30.0), type: NVActivityIndicatorType.BallSpinFadeLoader,  color: UIColor.whiteColor())

        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(activityView)
        
//        self.animationStart()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func animationStop() {
        activityView.stopAnimation()
    }
    
    public func animationStart() {
        activityView.startAnimation()
    }

}
