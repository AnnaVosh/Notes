//
//  EditViewController.swift
//  Notes
//
//  Created by Анна Коптева on 20/07/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    var note: Note? = nil
    var notebook: FileNotebook? = nil
    
    //main view
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var isUseDestroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDatePickerView: UIView!
    @IBOutlet var colorSquareViews: [CheckMarkView]!{
        didSet{
            colorSquareViews.sort(by: { $0.tag < $1.tag })
            colorSquareViews.forEach {
                $0.layer.borderWidth = 2
                $0.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    @IBOutlet weak var colorMultiImage: UIImageView!
    
    //colorPickerView
    @IBOutlet weak var colorPickerModeView: UIView!
    @IBOutlet weak var colorPickerView: ColorPickerView!
    @IBOutlet weak var colorSquareColorPickerView: UIView!
        {
        didSet{
            colorSquareColorPickerView.layer.borderWidth = 2
            colorSquareColorPickerView.layer.borderColor = UIColor.black.cgColor
            colorSquareColorPickerView.layer.cornerRadius = 5;
            colorSquareColorPickerView.layer.masksToBounds = true;
        }
    }
    @IBOutlet weak var colorTextField: UITextField!
    
    @IBAction func changedUseDestroyDate(_ sender: UISwitch) {
        updateUI()
    }
    @IBAction func colorWhiteTapped(_ sender: UITapGestureRecognizer) {
        activeColorSquareView = 0
        updateUI()
    }
    @IBAction func colorRedTapped(_ sender: UITapGestureRecognizer) {
        activeColorSquareView = 1
        updateUI()
    }
    @IBAction func colorGreenTapped(_ sender: Any) {
        activeColorSquareView = 2
        updateUI()
    }
    @IBAction func colorMultiTapped(_ sender: UILongPressGestureRecognizer) {
        activeColorSquareView = 3
        colorPickerMode = true
        updateUI()
    }
    @IBAction func doneOnColorPickerTapped(_ sender: UIButton) {
        colorPickerMode = false
        updateUI()
    }
    
    private var activeColorSquareView: Int = -1
    private var colorPickerMode: Bool = false
    private var currentMultiColor : UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    private var currentPickerPoint: CGPoint = .zero
    
    func setupGestureRecognizer() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardTap.cancelsTouchesInView = false
        contentView.addGestureRecognizer(dismissKeyboardTap)
    }
    
    func setupShowKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func colorPickerTapped(_ color: UIColor){
        print(color.cgColor)
    }
    
    
    @objc func dismissKeyboard() {
        contentView.endEditing(true)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        
        let activeField: UITextView? = descriptionTextView
        if let activeField = activeField {
            if aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y+kbSize.height)
                scrollView.setContentOffset(scrollPoint, animated: true)
                
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func updateUI(){
        destroyDatePickerView.isHidden = !isUseDestroyDateSwitch.isOn
        
        colorSquareViews.forEach {
            $0.isShapeHidden = false
        }
        
        colorSquareViews[activeColorSquareView].isShapeHidden = true
        
        colorSquareViews[3].backgroundColor = currentMultiColor
        
        if colorPickerMode {
            colorPickerModeView.isHidden = false
            colorMultiImage.isHidden = true
        }
        else{
            colorPickerModeView.isHidden = true
        }
        colorSquareColorPickerView.backgroundColor = currentMultiColor
        colorTextField.text = "#" + String(currentMultiColor.toHex() ?? "FFFFFF")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupGestureRecognizer()
        setupShowKeyboard()

        //setup view
        noteTitleTextField.text = note?.title
        descriptionTextView.text = note?.content
        if note?.selfDestructDate == nil {
            isUseDestroyDateSwitch.isOn = false
        }else{
            isUseDestroyDateSwitch.isOn = true
            destroyDatePicker.setDate((note?.selfDestructDate)!, animated: false)
        }
        for (index, colorSquare) in colorSquareViews.enumerated() {
            print(colorSquare.backgroundColor!)
            print(note!.color)
            print(colorSquare.backgroundColor!.compareWith(otherColor: note!.color))
            if colorSquare.backgroundColor!.compareWith(otherColor: note!.color) {
                activeColorSquareView = index
                print(activeColorSquareView)
            }
        }
        if activeColorSquareView == -1 {
            activeColorSquareView = 3
            currentMultiColor = note!.color
            print(note!.color)
            print(currentMultiColor)
            colorMultiImage.isHidden = true
        }
        
        updateUI()
        colorPickerView.onColorDidChange = { [weak self] color in
            self!.currentMultiColor = color
            self!.updateUI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        colorSquareViews[0].backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let destroyDate: Date?
        if isUseDestroyDateSwitch.isOn{
            destroyDate = destroyDatePicker.date
        }else{
            destroyDate = nil
        }
        let color = colorSquareViews[activeColorSquareView].backgroundColor ?? note!.color
        let newNote = Note(uid: UUID().uuidString, title: noteTitleTextField.text!, content: descriptionTextView.text!, color: color, importantce: .important, selfDestructDate: destroyDate)
        notebook?.remove(with: note!.uid)
        notebook?.add(newNote)
        notebook?.saveToFile()
    }
}
