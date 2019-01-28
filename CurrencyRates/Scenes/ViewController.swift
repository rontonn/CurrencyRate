//
//  ViewController.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 23/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var commmonTypeViewModel:ViewModel!
    
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        createViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStaticContentForDisplay()
        addBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        commmonTypeViewModel.viewWillAppearTrigger()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        commmonTypeViewModel.viewDidDisappearTrigger()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Overridden methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is ViewController) {
            let destVC = segue.destination as! ViewController
            destVC.commmonTypeViewModel?.passedObject.value = commmonTypeViewModel?.passingObject
        }
    }
    
    
    // MARK: - Custom public/internal methods
    /** Override this method to create instance of ViewModel with proper type. Don't call super in child class implementation
     */
    func createViewModel() {
        fatalError("Override createViewModel() without call super")
    }
    /** Override this method to react for view model's value changes
     */
    func addBindings() {
        
    }
    
    /** Override this method to set all static content on the screen
     No need to call super implementation, it does nothing
     */
    func setStaticContentForDisplay() {
        
    }
}
