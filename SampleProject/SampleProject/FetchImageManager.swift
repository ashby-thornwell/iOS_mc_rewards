//
//  FetchImageManager.swift
//  SampleProject
//
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit


class FetchImageManager {
    let fetchImageOperation = OperationQueue()
    static let cache: NSCache = NSCache<NSString, UIImage>()

    func fetchImageData(_ url:URL, completion: @escaping ((_ image: UIImage?) -> Void)) {

        let fetchConfigOperation = FetchImageOperation(url: url)
        fetchConfigOperation.completionBlock = {
            completion(fetchConfigOperation.networkingContext.intermediateObjects as? UIImage)
        }
        fetchImageOperation.addOperations([fetchConfigOperation], waitUntilFinished: false)
    }

    static func fetchImageForObservable(_ observable: Observable<UIImage?>, fromString urlString: String?) {
        guard let urlString = urlString, let imageURL = URL(string: urlString) else  { return }

        let fetchImageManager = FetchImageManager()
        if let image = FetchImageManager.cache.object(forKey: urlString as NSString)  {
            observable.value = image
        }
        else {
            fetchImageManager.fetchImageData(imageURL, completion: { [weak observable] (image) -> Void in
                guard let image = image else { return }
                FetchImageManager.cache.setObject(image, forKey: urlString as NSString)

                DispatchQueue.main.async {
                    observable?.value = image
                }
            })
        }
    }
}
