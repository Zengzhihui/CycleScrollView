# CycleScrollView
  A cycle scrollView made by Swift
## Screen Shot
![](http://img1.ph.126.net/VVH0xgTo7mB9hfBkUxsyAQ==/6630577383515726980.gif)
## How to use
```
//init

let adView = GZCycleScrollView(frame: CGRectMake(0,64,view.frame.width,200))

//set delegate

 adView.delegate = self
 
//set autoscroll && time interval

adView.isAutoScroll = true
adView.timerInterval = 3

//delegate method

func numberOfCells() -> Int {
    return 10
}

func setUpCell() -> UIView {
    let label = UILabel()
    label.textAlignment = .Center
    label.textColor = UIColor.blackColor()
    label.backgroundColor = UIColor.redColor()
    return label
}

func setCellModel(view: UIView, index: Int) {
    if let label = view as? UILabel{
        label.text = "\(index)"
    }
}

func didClickCellAtIndex(index: Int) {
    let alertView = UIAlertView(title: "you click at index = \(index)", message: nil, delegate: nil, cancelButtonTitle: "确定")
    alertView.show()
}

```
