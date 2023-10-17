//
//  Extensions.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 03.10.23.
//

import Foundation
import UIKit

//MARK: size ex for UIView
extension UIView {
    var width: CGFloat{
        return frame.size.width
    }
    
    var height: CGFloat{
        return frame.size.height
    }
    
    var left: CGFloat{
        return frame.origin.x
    }
    
    var right: CGFloat{
        return left + width
    }
    
    var top: CGFloat{
        return frame.origin.y
    }
    
    var bottom: CGFloat{
        return top + height
    }
}

//MARK: trust connection for apis
extension UIViewController: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

extension UICollectionViewCell: URLSessionDelegate{
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

//MARK: download image from url
extension UIImageView {
    func download(from url: URL, sessionDelegate: URLSessionDelegate, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: sessionDelegate,
                delegateQueue: OperationQueue.main).dataTask(with: url)
            { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else {
                    self.image = UIImage(named: "no-image")
                    completion?()
                    return
                }
                self.image = image
                completion?()
            }.resume()
        }
    }
}

//MARK: show custom error as alert
extension UIViewController {
    func showMessage(alertTitle: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        present(alert, animated: true)
    }
}

//MARK: get height from text dynamically for label
extension UILabel {
    func calculateLabelHeight(width: CGFloat) -> CGFloat {
        let rect = NSString(string: self.text ?? "").boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: self.font ?? .systemFont(ofSize: 17)],
            context: nil
        )
        return ceil(rect.size.height)
    }
}
