//
//  CurrencyRatesViewController.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 23/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import UIKit

import UIKit
import FlagKit

class CurrencyRatesViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet var currencyRatesTableView: UITableView!
    
    var refresher: UIRefreshControl!
    
    private var viewModel = CurrencyRatesViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        currencyRatesTableView.addSubview(refresher)
        
    }
    
    // MARK: - Notification handlers
    
    @objc func refreshData() {
        refresher.endRefreshing()
        viewModel.getCurrencyRates()
    }
    
    // MARK: - Overriden methods
    override func createViewModel() {
        commmonTypeViewModel = viewModel
    }
    
    override func addBindings() {
        super.addBindings()
        
        viewModel.resultingRates.bind { [unowned self] currencies in
            self.currencyRatesTableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.resultingRates.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyRatesTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.rateTextField.delegate = self
        
        cell.rateTextField.keyboardType = .decimalPad
        cell.currencyFlagImage.image = viewModel.resultingRates.value[indexPath.row].currencyFlagImage
        cell.lblCurrencyCode.text = viewModel.resultingRates.value[indexPath.row].currencyCode
        cell.lblCurrencyName.text = viewModel.resultingRates.value[indexPath.row].currencyFullName
        
        if viewModel.isEditingRate && indexPath.row != 0  {
            cell.rateTextField.text = String(viewModel.resultingRates.value[indexPath.row].currencyRate)
        } else if !viewModel.isEditingRate {
            cell.rateTextField.text = String(viewModel.resultingRates.value[indexPath.row].currencyRate)
        }

        if let indexPathForRowWithSelectedTextField = viewModel.indexPathForSelectedRow {
            if indexPathForRowWithSelectedTextField == indexPath {
                cell.rateTextField.becomeFirstResponder()
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CurrencyRatesTableViewCell {
            if !cell.rateTextField.isFirstResponder {
                cell.rateTextField.becomeFirstResponder()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currencyRatesTableView.endEditing(true)
        viewModel.indexPathForSelectedRow = nil
    }
}

extension CurrencyRatesViewController: TextFieldInTableViewCellDelegate, UITextFieldDelegate {
    
    // MARK: - Delegate handlers
    func textFieldInTableViewCell(didSelect cell:CurrencyRatesTableViewCell) {
        
        if let indexPath = currencyRatesTableView.indexPath(for: cell){
            viewModel.performUpdates(with: indexPath)
            
            if indexPath.row != 0 {
                currencyRatesTableView.performBatchUpdates({
                    currencyRatesTableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
                    currencyRatesTableView.moveRow(at: IndexPath(row: 0, section: 0), to: indexPath)
                    currencyRatesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }, completion: nil)
            }
            
        }
    }
    
    func textFieldInTableViewCell(cell:CurrencyRatesTableViewCell, editingChangedInTextField newText:String) {
        viewModel.editRate(with: newText)
    }
}

