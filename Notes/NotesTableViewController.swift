import UIKit

class NotesTableViewController: UITableViewController {
    
    var notes = Note.loadSampleNote()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.title = "Изменить"
        
        if let saveNotes = Note.loadFromFile() {
            notes = saveNotes
        } else {
            notes = Note.loadSampleNote()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)

        let item = notes[indexPath.row]
        cell.textLabel?.text = item.description

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Note.saveToFile(notes: notes)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.editButtonItem.title = editing ? "Готово" : "Изменить"
    }

    
    @IBSegueAction func showNoteDetail(_ coder: NSCoder, sender: Any?) -> NoteDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        
        let noteEdit = notes[indexPath.row]
        
        return NoteDetailViewController(coder: coder, note: noteEdit)
    }

    // MARK: - Navigation

    @IBAction func unwindToNoteDetail(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? NoteDetailViewController,
              let note = sourceViewController.note else {
                  return
              }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            notes[selectedIndexPath.row] = note
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath =  IndexPath(row: notes.count, section: 0)
            notes.append(note)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        Note.saveToFile(notes: notes)
    }

}
