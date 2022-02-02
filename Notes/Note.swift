import Foundation

struct Note: Codable {
    var description: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentDirectory.appendingPathComponent("note_app").appendingPathExtension("plist")
    
    static func loadSampleNote() -> [Note] {
        let note1 = Note(description: "Моя первая заметка в качестве примера!")
                         
        return [note1]
    }
    
    static func saveToFile(notes: [Note]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedNotes = try? propertyListEncoder.encode(notes)
        
        try? encodedNotes?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Note]? {
        guard let decodedNotes = try? Data(contentsOf: archiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Note>.self, from: decodedNotes)
    }
}
