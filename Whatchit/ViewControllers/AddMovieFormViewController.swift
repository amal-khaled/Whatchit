//
//  AddMovieFormViewController.swift
//  Whatchit
//
//  Created by Amal Elgalant on 7/5/19.
//  Copyright © 2019 Amal Elgalant. All rights reserved.
//

import UIKit

class AddMovieFormViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var addMovieButton: UIButton!
    @IBOutlet weak var overviewTextView: UITextView!
    
    var imagePicker = UIImagePickerController()
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //register all text to enable button
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange(_:)),
            name: UITextField.textDidChangeNotification,
            object: nil)
        
        
        //setup image
        
      
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        poster.addGestureRecognizer(tapGestureRecognizer)
        imagePicker.delegate = self
        
        //date picker
        showDatePicker()
        
        
        clossKeyBoard()
        
        
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    @objc private func textDidChange(_ notification: Notification) {
        enableButton()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "all_movies"{
            let movie = Movie()
            movie.title = titleTextField.text!
            movie.overview = overviewTextView.text!
            movie.date = dateTextField.text!
            
            AppDelegate.myMovies.append(movie)
            AppDelegate.myMoviesImages.append(poster.image!)
            
        }
    }
    
    
    @IBAction func addMovieAction(_ sender: Any) {
        
        print("add movie")
        
        self.performSegue(withIdentifier: "all_movies", sender: self)
        
    }
}

extension AddMovieFormViewController{
    func enableButton(){
        
        // Validate Text Field
        var formIsValid = true
        for textField in textFields {
            // Validate Text Field
            let valid = !textField.isEmpty
            
            if textField.isEditing{
                validTextField(textField)
                
            }
            
            if !valid {
                formIsValid = false
                break
            }
            
            
        }
        
        if overviewTextView.isEmpty{
            formIsValid = false

        }
        
        
        addMovieButton.isEnabled = formIsValid
        if (addMovieButton.isEnabled){
            addMovieButton.alpha = 1
        }
        else {
            addMovieButton.alpha = 0.5
            
        }
    }
    func validTextField (_ textField: UITextField){
        if textField.isEmpty{
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1
        }
        else{
            
            textField.layer.borderWidth = 0
        }
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        // add toolbar to textField
        dateTextField.inputAccessoryView = toolbar
        // add datepicker to textField
        dateTextField.inputView = datePicker
        
    }
     func clossKeyBoard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
}
extension AddMovieFormViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField{
            dateTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        validTextField(textField)
        return true
    }
    
 
}
extension ViewController: UITextViewDelegate{
    
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.isEmpty{
            textView.layer.borderColor = UIColor.red.cgColor
            textView.layer.borderWidth = 1
        }
        else{
            
            textView.layer.borderWidth = 0
        }
        return true
        
    }
    
    
}
extension AddMovieFormViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.poster.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension UITextField {
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
extension UITextView {
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
