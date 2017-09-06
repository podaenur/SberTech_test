//
//  MainViewCell.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 06/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import UIKit

struct MainViewCellModel {
    let title: String
    let detail: String?
}

class MainViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    // MARK: - Public
    
    func configure(with model: MainViewCellModel) {
        titleLabel.text = model.title
        detailLabel.text = model.detail
    }
    
    // MARK: - Private
    
    private func initialSetup() {
        backgroundColor = nil
        
        //  contentView
        contentView.backgroundColor = nil
        
        //  canvasView
        canvasView.backgroundColor = .sb_white
        let layer = canvasView.layer
        layer.borderWidth = 1
        layer.borderColor = UIColor.sb_border.cgColor
        layer.cornerRadius = 2
        layer.masksToBounds = true
        
        //  titleLabel
        titleLabel.font = .sb_title
        titleLabel.textColor = .sb_title
        titleLabel.text = nil
        
        //  detailLabel
        detailLabel.font = .sb_detail
        detailLabel.textColor = .sb_detail
        detailLabel.text = nil
    }
}
