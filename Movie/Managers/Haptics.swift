//
//  Haptics.swift
//  Movie
//
//  Created by Elmar Ibrahimli on 18.10.23.
//

import Foundation
import UIKit

final class Haptics {
    static let shared = Haptics()
    
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private init() {
        selectionFeedbackGenerator.prepare()
        notificationFeedbackGenerator.prepare()
        impactFeedbackGenerator.prepare()
    }
    
    func triggerSelectionFeedback() {
        selectionFeedbackGenerator.selectionChanged()
    }
    
    func triggerNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedbackGenerator.notificationOccurred(type)
    }
    
    func triggerImpactFeedback() {
        impactFeedbackGenerator.impactOccurred()
    }
}
