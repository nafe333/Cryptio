//
//  LocalFileManager.swift
//  Crypto
//
//  Created by Nafea Elkassas on 30/03/2026.
//

import Foundation
import UIKit
class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init(){ }
    
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        createFolderIfNeeded(folderName: folderName)
        // في الاول بنحول الصورة لداتا وبنجيب المكان اللي هنسيفها فيه
//         بعد كده بنسيفها في المكان بتاعها بس
        guard
            let data = image.pngData(),
            let url = getUrlForImage(imageName: imageName, folderName: folderName)
        else { return }
        do {
            try data.write(to: url)
        } catch let error {
            print("error in saving image \(error.localizedDescription)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage?{
        guard
            let url = getUrlForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String){
        guard let url = getUrlForFolder(folderName: folderName) else { return}
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error in creating a folder at all \(error.localizedDescription)")
            }
        }
    }
    
    private func getUrlForImage(imageName: String, folderName: String) -> URL?{
        guard let folderUrl = getUrlForFolder(folderName: folderName) else {
            return nil
        }
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
    
    private func getUrlForFolder(folderName: String) -> URL?{
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
}
