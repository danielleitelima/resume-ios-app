//
//  RemoteImage.swift
//  resume
//
//  Created by Daniel Leite Lima on 14.03.25.
//

import Foundation
import UIKit

func getRemoteImage(url: URL, placeholder: UIImage, completionHandler: @escaping (UIImage) -> Void) -> URLSessionDataTask {
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error loading image: \(error.localizedDescription)")
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            return
        }
        
        guard let data = data, let image = UIImage(data: data) else {
            print("Invalid image data received")
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            return
        }
        
        DispatchQueue.main.async {
            completionHandler(image)
        }
    }
    
    return task
}
