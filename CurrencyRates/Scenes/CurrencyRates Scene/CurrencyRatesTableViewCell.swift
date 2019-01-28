//
//  CurrencyRatesTableViewCell.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 22/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import UIKit

protocol TextFieldInTableViewCellDelegate {
    func textFieldInTableViewCell(didSelect cell:CurrencyRatesTableViewCell)
    func textFieldInTableViewCell(cell:CurrencyRatesTableViewCell, editingChangedInTextField newText:String)
}

class CurrencyRatesTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet var currencyFlagImage: UIImageView!
    @IBOutlet var lblCurrencyCode: UILabel!
    @IBOutlet var lblCurrencyName: UILabel!
    @IBOutlet var rateTextField: UITextField!
    
    var delegate: TextFieldInTableViewCellDelegate?
    
    // MARK: - Overriden methods
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    // MARK: - Notification methods
    @objc func didSelectCell() {
        
    }
    
    // MARK: - IBActions
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text {
            delegate?.textFieldInTableViewCell(cell: self, editingChangedInTextField: text)
        }
    }
    @IBAction func textFieldSelected(_ sender: UITextField) {
        if !rateTextField.isFirstResponder {
            rateTextField.becomeFirstResponder()
        }
        delegate?.textFieldInTableViewCell(didSelect: self)
    }
    
}
