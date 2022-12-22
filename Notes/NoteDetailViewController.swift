import UIKit

class NoteDetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var note: Note?

    override func viewDidAppear(_ animated: Bool) {
        guard textView.text == "" else { return }
        textView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHidden),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        if let note = note {
            textView.text = note.description
        } else {
            textView.text = ""
        }
        
        saveButton.isEnabled = !textView.text.isEmpty

    }
    
    init?(coder: NSCoder, note: Note) {
        self.note = note
        super.init(coder: coder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.textView {
            self.saveButton.isEnabled = !textView.text.isEmpty
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let info = notification.userInfo
        if let keyboardRect = info?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.size.height + 70, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
    }

    @objc func keyboardWillHidden(_ notification: NSNotification) {
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.scrollIndicatorInsets = textView.contentInset
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let description = textView.text!
        note = Note(description: description)
    }
}
