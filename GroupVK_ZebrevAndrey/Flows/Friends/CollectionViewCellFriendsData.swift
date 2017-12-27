//
//  CollectionViewCellFriendsData.swift
//  Weather_Zebrev
//
//  Created by Rapax on 27.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import UIKit

class CollectionViewCellFriendsData: UICollectionViewCell {
    
    @IBOutlet weak var FriendsDataCellLabel: UILabel! {
        //отключим создание автоматических constraints
        didSet {
            FriendsDataCellLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @IBOutlet weak var FriendsDataCellImage: UIImageView! {
        didSet {
            FriendsDataCellImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    //одинаковый отступ в 10 пунктов с каждой стороны
    let instets: CGFloat = 2
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        //определяем максимальную ширну которую может занимать наш текст 
        //это ширина ячейки минус отсупы слева и справа 
        let maxWidth = bounds.width - instets * 2
        //получаем размаеры блока в которого надо вписать надпись 
        //используем максимальную ширну и максимальное возможную высоту 
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        //получем прямоугольник который займет наш текст в этом блоке, уточняем каким шрифтом он будет написан 
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        //получаем ширину блока, перводим ее в Double 
        let width = Double(rect.size.width)
        //получаем высоту блока, перводим ее в Double 
        let height = Double(rect.size.height)
        //получаем размер, при этом округляем значения до большего целого числа 
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
   
    
    func LabelFrame() {
    //получаем размер текста передавая сам текст и шрифт. 
        let LabelSize = getLabelSize(text: FriendsDataCellLabel.text!, font: FriendsDataCellLabel.font)
    //расчитывает координату по оси Х 
        let LabelX = (bounds.width - LabelSize.width) / 2
    //получем точку верхнего левого угла надписи 
        let LabelOrigin =  CGPoint(x: LabelX, y: instets)
        
        //print("label= \(LabelOrigin), labelsize = \(LabelSize)")
    //получаем фрейм и устанавливаем нашей UILabel 
    FriendsDataCellLabel.frame = CGRect(origin: LabelOrigin, size: LabelSize)
    }
    
    func iconFrame() {
        
        let iconSideLinght: CGFloat = 150
        let iconSize = CGSize(width: 150, height: iconSideLinght)
        //+12 - чтобы на текст не налезало
        let iconOrigin = CGPoint(x: bounds.midX - iconSideLinght / 2, y: bounds.midY - iconSideLinght / 2 + 12)
        //print("icon = \(iconOrigin)")
        FriendsDataCellImage.frame = CGRect(origin: iconOrigin, size: iconSize)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        LabelFrame()
        iconFrame()
        }
    
    func setLabel(text: String) {
        FriendsDataCellLabel.text = text
        LabelFrame()
    }
    
}
