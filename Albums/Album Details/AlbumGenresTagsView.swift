//
//  AlbumGenresTagsView.swift
//  Albums
//
//  Created by Artem on 8/4/22.
//

import UIKit

final  class AlbumGenresTagsView: UIScrollView {
    
    private(set) var numberOfRows = 0
    
    private(set) var currentRow = 0
    
    private(set) var tags: [UILabel] = []
    
    private(set) var containerView: UIView = UIView()
    
    var hashtagsOffset:UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
    
    var rowHeight:CGFloat = 26 //height of rows
    
    var tagHorizontalPadding:CGFloat = 5.0 // padding between tags horizontally
    
    var tagVerticalPadding:CGFloat = 5.0 // padding between tags vertically
    
    var tagCombinedMargin:CGFloat = 6.0 // margin of left and right combined, text in tags are by default centered.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfRows = Int(frame.height / rowHeight)
        containerView = UIView(frame: self.frame)
        self.addSubview(containerView)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    
    override func awakeFromNib() {
        numberOfRows = Int(self.frame.height / rowHeight)
        containerView = UIView(frame: self.frame)
        self.addSubview(containerView)
        self.showsVerticalScrollIndicator = false
        self.isScrollEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutTagsFromIndex(index: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addTag(text: String) {
        
        let label = UILabel()
        label.text = " \(text)  "
        label.numberOfLines = 1
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.textColor = #colorLiteral(red: 0, green: 0.5694641471, blue: 1, alpha: 1)
        label.layer.borderColor = label.textColor.cgColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.center
        self.tags.append(label)
        
        label.frame = CGRect(x: label.frame.origin.x, y: label.frame.origin.y ,
                             width: label.frame.width + tagCombinedMargin, height: rowHeight - tagVerticalPadding)
        label.layer.cornerRadius = label.bounds.height / 2
        
        if self.tags.count == 0 {
            label.frame = CGRect(x: hashtagsOffset.left, y: hashtagsOffset.top, width: label.frame.width, height: label.frame.height)
            self.addSubview(label)
        } else {
            label.frame = self.generateFrameAtIndex(index: tags.count-1, rowNumber: &currentRow)
            self.addSubview(label)
        }
    }
    
    
    
    private func isOutofBounds(newPoint: CGPoint, labelFrame: CGRect) {
        let bottomYLimit = newPoint.y + labelFrame.height
        if bottomYLimit > self.contentSize.height {
            self.containerView.frame = CGRect(x: self.containerView.frame.origin.x, y: self.containerView.frame.origin.y, width: self.containerView.frame.width, height: self.containerView.frame.height + rowHeight - tagVerticalPadding)
            self.contentSize = CGSize(width: self.contentSize.width, height: self.contentSize.height + rowHeight - tagVerticalPadding)
        }
    }
    
    
    func getPositionForIndex(index: Int,rowNumber: Int) -> CGPoint {
        if index == 0 {
            return CGPoint(x: hashtagsOffset.left, y: hashtagsOffset.top)
        }
        let y = CGFloat(rowNumber) * self.rowHeight + hashtagsOffset.top
        let lastTagFrame = tags[index-1].frame
        let x = lastTagFrame.origin.x + lastTagFrame.width + tagHorizontalPadding
        return CGPoint(x: x, y: y)
    }
    
    private func getRowNumber(index: Int) -> Int {
        return Int((tags[index].frame.origin.y - hashtagsOffset.top)/rowHeight)
    }
    
    private func layoutTagsFromIndex(index: Int,animated: Bool = true) {
        if tags.count == 0 {
            return
        }
        
        let animation:()->() = { [weak self] in
            guard let `self` = self else { return }
            var rowNumber = self.getRowNumber(index: index)
            for i in index...self.tags.count - 1 {
                self.tags[i].frame = self.generateFrameAtIndex(index: i, rowNumber: &rowNumber)
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: animation)
    }
    
    private func generateFrameAtIndex(index: Int, rowNumber: inout Int) -> CGRect {
        var newPoint = self.getPositionForIndex(index: index, rowNumber: rowNumber)
        if (newPoint.x + self.tags[index].frame.width) >= self.frame.width {
            rowNumber += 1
            newPoint = CGPoint(x: self.hashtagsOffset.left, y: CGFloat(rowNumber) * rowHeight + self.hashtagsOffset.top)
        }
        self.isOutofBounds(newPoint: newPoint,labelFrame: self.tags[index].frame)
        return CGRect(x: newPoint.x, y: newPoint.y, width: self.tags[index].frame.width, height: self.tags[index].frame.height)
    }
}
