# Youtube play button animation using POP
[原文链接](http://iostuts.io/2015/09/29/youtube-play-button-animation-using-pop/)

[初始项目](https://github.com/dowhilenet/Youtube-play-button-animation-using-POP/tree/0.1)

第一步呢就是创建一个`UIButton`的子类叫做`PlayButton`

正如你所看到的那个样子这个按钮呢有两种状态一种是播放一种是暂停，这里呢我们再定义一个枚举

``` swift
enum PlayButtonState: CGFloat {
    case Paused = 0.0
    case Playing = 1.0
}
```

在之后会详细的描述为什么这里声明了 `var value: CGFloat`

这里讲解下实现这两种状态的转换的动画实现原理

`POP`允许我们创建动画的属性 - 而这正是我们要做的。我们将创建一个名为`animationValue`一个`CGFloat`的变量，将1.0动画播放到0.0时，从暂停的按钮状态更改为播放，动画从0.0到1.0的时候从播放到暂停的按钮状态变化。每次值发生了变化，我们会调用`setNeedsDisplay`这将使view重新绘画

我们将声明下边两个变量:

``` swift
// MARK: Vars
private(set) var buttonState = PlayButtonState.Playing  
private var animationValue: CGFloat = 1.0 {  
  didSet {
    setNeedsDisplay()
  }
}
```

1. `buttonState`仅仅在这个类中是可写入的，记录了按钮的状态
2. `animationValue` 当它的值发生改变的时候我们调用`setNeedsDisplay`

The next step is to create a method responsible for setting up animation or only updating animationValue when animation is not needed

接下来我们会创建一个方法来负责设置动画，或者它不需要动画时仅仅更新`animationValue`


``` swift
    // MARK: Methods
    func setButtonState(buttonState: PlayButtonState, animated: Bool) {
        // 1
        if self.buttonState == buttonState {
            return
        }
        self.buttonState = buttonState
        
        // 2
        if pop_animationForKey("animationValue") != nil {
            pop_removeAnimationForKey("animationValue")
        }
        
        // 3
        let toValue: CGFloat = buttonState.rawValue
        
        // 4
        if animated {
            let animation: POPBasicAnimation = POPBasicAnimation()
            if let property = POPAnimatableProperty.propertyWithName("animationValue", initializer: { (prop: POPMutableAnimatableProperty!) -> Void in
                prop.readBlock = { (object: AnyObject!, values: UnsafeMutablePointer<CGFloat>) -> Void in
                    if let button = object as? PlayButton {
                        values[0] = button.animationValue
                    }
                }
                prop.writeBlock = { (object: AnyObject!, values: UnsafePointer<CGFloat>) -> Void in
                    if let button = object as? PlayButton {
                        button.animationValue = values[0]
                    }
                }
                prop.threshold = 0.01
            }) as? POPAnimatableProperty {
                animation.property = property
            }
            
            animation.fromValue = NSNumber(float: Float(self.animationValue))
            animation.toValue = NSNumber(float: Float(toValue))
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.duration = 0.25
            pop_addAnimation(animation, forKey: "percentage")
        } else {
            animationValue = toValue
        }
    }
```

1. 只有当我们改变按钮的状态的时候我们才去执行动画
2. 如果之前的动画存在的话我们把它移出
3. 用一个常量来存储按钮状态的原始值
4. If animation is required, then we initialise POPBasicAnimation with POPAnimatableProperty. Otherwise we only update animation value

接下来我们重写`drawRect`方法

![](http://7s1rp2.com1.z0.glb.clouddn.com/QQ20160517-0.png)

``` swift
    
    // MARK: Draw
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // 1
        let height = rect.height
        let minWidth = rect.width * 0.32 // 暂停按钮两个矩形的宽度
        // aWidth 是由 animationValue 的值来决定的
        //当 animationValue 为 1 时 (要显示播放按钮) 所以这个值为 rect.width / 2.0 - minWidth
        //当 animationValue 为 0 时 （要显示暂停按钮）所以这个值为 0
        let aWidth = (rect.width / 2.0 - minWidth) * animationValue
        let width = minWidth + aWidth
        //当 animationValue 为 1 时 (要显示播放按钮) h1 为 height / 4.0
        //当 animationValue 为 0 时 (要显示暂停按钮) h1 为 0
        let h1 = height / 4.0 * animationValue
        
        //当 animationValue 为 1 时 (要显示播放按钮) h2 为 height / 2.0
        //当 animationValue 为 0 时 (要显示暂停按钮) h2 为 0
        let h2 = height / 2.0 * animationValue
        
        // 2
        let context = UIGraphicsGetCurrentContext()
        
        // 3
        CGContextMoveToPoint(context, 0.0, 0.0)
        CGContextAddLineToPoint(context, width, h1)
        CGContextAddLineToPoint(context, width, height - h1)
        CGContextAddLineToPoint(context, 0.0, height)
        CGContextMoveToPoint(context, rect.width - width, h1)
        CGContextAddLineToPoint(context, rect.width, h2)
        CGContextAddLineToPoint(context, rect.width, height - h2)
        CGContextAddLineToPoint(context, rect.width - width, height - h1)
        
        // 4
        CGContextSetFillColorWithColor(context, tintColor.CGColor)
        CGContextFillPath(context)
    }
```


