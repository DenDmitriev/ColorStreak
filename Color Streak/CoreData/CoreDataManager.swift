//
//  CoreDataStack.swift
//  dE Calculator
//
//  Created by Denis Dmitriev on 03.06.2024.
//

import Foundation
import CoreData
import SwiftUI
import FirebaseCrashlytics

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PaletteModel")
        container.loadPersistentStores { _, error in
            if let error {
                print("CoreData \(#function) error: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var bgContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()
    
    private init() {}
    
    private func saveChanges(with context: NSManagedObjectContext) {
        print(#function)
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("CoreData \(#function) error: \(error.localizedDescription)")
                    sendLogMessageCrashlytics(error: error, function: #function)
                    context.rollback()
                }
            }
            context.reset()
        }
    }
    
    private func sendLogMessageCrashlytics(error: Error, function: String) {
        Crashlytics.crashlytics().record(error: error, userInfo: ["CoreData" : function])
    }
    
    func fetchPalettes() async throws -> [Palette] {
        let request = PaletteModel.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(PaletteModel.dateModified), ascending: false)
        request.sortDescriptors = [sort]
        let objects = try context.fetch(request)
        var palettes = [Palette]()
        for object in objects {
            let palette = Palette()
            palette.id = object.id ?? UUID()
            palette.name = object.name ?? "Unknown"
            palette.dateCreated = object.dateCreated ?? Date.now
            palette.dateModified = object.dateModified ?? Date.now
            palette.colorSpace = DeviceColorSpace(rawValue: Int(object.colorSpace)) ?? .sRGB
            palette.selection = palette.colors.isEmpty ? .zero : nil
            
            var colors = [Color]()
            if let colorsObjects = object.colors?.allObjects as? [ColorModel] {
                for colorsObject in colorsObjects.sorted(by: { $0.index < $1.index }) {
                    let red = Double(colorsObject.red) / 255
                    let green = Double(colorsObject.green) / 255
                    let blue = Double(colorsObject.blue) / 255
                    let color = Color(.displayP3, red: red, green: green, blue: blue)
                    colors.append(color)
                }
            }
            palette.colors = colors
            
            var tags = [ColorTag]()
            if let tagObjects = object.tags?.allObjects as? [ColorTagModel] {
                tags = tagObjects.compactMap({ tagObject -> ColorTag? in
                    if let tag = tagObject.tag {
                        return ColorTag(tag: tag)
                    } else {
                        return nil
                    }
                })
            }
            palette.tags = tags
            
            palettes.append(palette)
        }
        
        return palettes
    }
    
    func updatePalette(palette: Palette) async throws {
        let request = PaletteModel.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", palette.id.uuidString)
        let objectPalette = try bgContext.fetch(request).first ?? PaletteModel(context: bgContext)
        objectPalette.name = palette.name
        objectPalette.colorSpace = Int16(palette.colorSpace.rawValue)
        objectPalette.dateModified = palette.dateModified
        
        if let colorObjects = objectPalette.colors?.allObjects as? [ColorModel] {
            for colorObject in colorObjects {
                bgContext.delete(colorObject)
            }
        }
        
        for (index, color) in palette.colors.enumerated() {
            let objectColor = ColorModel(context: bgContext)
            let rgb = color.rgb
            objectColor.index = Int16(index)
            objectColor.red = Int16(rgb.red255)
            objectColor.green = Int16(rgb.green255)
            objectColor.blue = Int16(rgb.blue255)
            
            objectColor.palette = objectPalette
            objectPalette.mutableSetValue(forKey: "colors").add(objectColor)
        }
        
        if let tagObjects = objectPalette.tags?.allObjects as? [ColorTagModel] {
            for tagObject in tagObjects {
                if !palette.tags.map({ $0.tag }).contains(tagObject.tag) {
                    bgContext.delete(tagObject)
                }
            }
            for tag in palette.tags {
                if !tagObjects.compactMap({ $0.tag }).contains(tag.tag) {
                    let objectTag = ColorTagModel(context: bgContext)
                    objectTag.tag = tag.tag
                    objectTag.palette = objectPalette
                    objectPalette.mutableSetValue(forKey: "tags").add(objectTag)
                }
            }
        }
        
        saveChanges(with: bgContext)
    }
    
    func addPalette(palette: Palette) async {
        let objectPalette = PaletteModel(context: context)
        if palette.name.isEmpty {
            palette.name = palette.generateName() ?? Date().description
        }
        objectPalette.name = palette.name
        objectPalette.id = palette.id
        objectPalette.colorSpace = Int16(palette.colorSpace.rawValue)
        objectPalette.dateCreated = palette.dateCreated
        objectPalette.dateModified = palette.dateModified
        
        for (index, color) in palette.colors.enumerated() {
            let objectColor = ColorModel(context: context)
            let rgb = color.rgb
            objectColor.index = Int16(index)
            objectColor.red = Int16(rgb.red255)
            objectColor.green = Int16(rgb.green255)
            objectColor.blue = Int16(rgb.blue255)
            
            objectColor.palette = objectPalette
            objectPalette.mutableSetValue(forKey: "colors").add(objectColor)
        }
        
        for tag in palette.tags {
            let objectTag = ColorTagModel(context: context)
            objectTag.tag = tag.tag
            objectTag.palette = objectPalette
            objectPalette.mutableSetValue(forKey: "tags").add(objectTag)
        }
        
        saveChanges(with: context)
    }
    
    func deletePalette(palette: Palette) async throws {
        let request = PaletteModel.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", palette.id.uuidString)
        let objectPalette = try bgContext.fetch(request).first ?? PaletteModel(context: bgContext)
        bgContext.delete(objectPalette)
        
        saveChanges(with: bgContext)
    }
    
    func deleteAllPalettes() async throws {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PaletteModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: bgContext)
    }
}

