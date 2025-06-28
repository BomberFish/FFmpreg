// bomberfish
// DocumentPicker.swift – FFmpreg
// created on 2025-05-08

import SwiftUI
import UniformTypeIdentifiers

struct DocumentImporter: UIViewControllerRepresentable {
    
    @Binding var filePath: URL?
    var utTypes: [UTType]
    
    func makeCoordinator() -> DocumentImporter.Coordinator {
        return DocumentImporter.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentImporter>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: utTypes)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: DocumentImporter.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentImporter>) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: DocumentImporter
        
        init(parent1: DocumentImporter){
            parent = parent1
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.filePath = urls[0]
//            print(urls[0].absoluteString)
        }
    }
}

struct DocumentExporter: UIViewControllerRepresentable {
    
    @Binding var filePath: URL?
    
    func makeCoordinator() -> DocumentExporter.Coordinator {
        return DocumentExporter.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentExporter>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forExporting: [filePath!])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: DocumentExporter.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentExporter>) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: DocumentExporter
        
        init(parent1: DocumentExporter){
            parent = parent1
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.filePath = urls[0]
//            print(urls[0].absoluteString)
        }
    }
}
