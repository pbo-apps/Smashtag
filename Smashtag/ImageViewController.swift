//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 28/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Model
    var imageURL: URL? {
        didSet {
            image = nil
            // This is a pretty reliable way of checking if the view is on screen
            // The view will only be in a window if it's actually on the device's screen
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    var aspectRatio: Double?
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                let contentsOfURL = NSData(contentsOf: url as URL)
                DispatchQueue.main.async { [weak weakSelf = self] in
                    if url == weakSelf?.imageURL {
                        if let imageData = contentsOfURL {
                            weakSelf?.image = UIImage(data: imageData as Data)
                        } else {
                            weakSelf?.spinner?.stopAnimating()
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                }
                
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.25
            scrollView.maximumZoomScale = 4.0
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
//            newValue.
//            if aspectRatio != nil {
//                let height = scrollView?.bounds.width / CGFloat(aspectRatio!)
//            }
            imageView.image = newValue
            //imageView.sizeThatFits(CGSize(width: 100, height: 100))
            imageView.sizeToFit()
            // scrollView is an outlet, so we need to allow for case where this is nil (i.e. image setting is happening when someone is preparing this MVC to be segued to)
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    var userDidZoom = false
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        userDidZoom = true
    }

}
