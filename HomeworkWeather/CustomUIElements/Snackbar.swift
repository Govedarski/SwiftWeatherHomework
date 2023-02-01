//
//  Snackbar.swift
//  HomeworkL6ImpressMe
//
//  Created by Alex Partulov on 11.01.23.
//

import UIKit

class Snackbar: UILabel {
    //TODO refactoring
    var caller:UIView?
    var view:UIView
    var wrapperView:UIView
    
    var defaultFrame = true
    private var _padding:CGFloat = 0
    var padding:CGFloat{
        set{
            self.frame.size.width = self.frame.width - self._padding + newValue
            self.frame.size.height = self.frame.height - self._padding + newValue
            self._padding = newValue
        }
        get{
            return self._padding
        }
    }
    var margin:CGFloat!
    var centerHorizontal:CGFloat{
        return (self.view.frame.width - self.frame.width) / 2
    }
    
    var centerVertical:CGFloat{
        return (self.view.frame.height - self.frame.height) / 2
    }
    init(text: String, view: UIView, caller: UIView? = nil) {
        self.caller = caller
        self.view = view
        self.wrapperView = UIView()
        super.init(frame: CGRect.zero)
        self.text = text
        self.setDefaultAttr()
    }
    
    func setDefaultAttr(){
        self.wrapperView.backgroundColor = .red
        self.wrapperView.alpha = 0
        self.wrapperView.layer.cornerRadius = 8
        self.wrapperView.clipsToBounds = true
        self.font = font.withSize(32)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.padding = 16
        self.margin = 16
        self.frame.size.width = self.view.frame.width - (self.margin * 2) - (self.padding * 2)
        self.sizeToFit()
    }
    
    func setDefaultFrame(){
        self.wrapperView.frame = CGRect(x: self.centerHorizontal - self.padding,
                                        y: (self.caller?.frame.maxY ?? self.centerVertical) ,
                                        width: self.frame.width + self.padding*2,
                                        height: self.frame.height + self.padding*2)
    }
    
    
    
    func show(stayTime:Double, showTime:Double = 0, hideTime:Double = 0, maxAlpha:Double = 0.6){
        if defaultFrame {
            self.setDefaultFrame()
        }
        

        
        wrapperView.addSubview(self)
        
        self.center = CGPoint(x: self.wrapperView.bounds.midX,
                                    y: self.wrapperView.bounds.midY)
        
        self.view.addSubview(wrapperView)
        UIView.animate(withDuration: showTime){
            self.wrapperView.alpha = maxAlpha
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + showTime + stayTime){
            UIView.animate(withDuration: hideTime ){
                self.wrapperView.alpha = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + showTime + hideTime + stayTime){
            self.wrapperView.removeFromSuperview()
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
