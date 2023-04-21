//
//  Things.swift
//  Listr
//
//  Created by Marlon Garcia-Bermejo on 2023-04-17.
//

import Foundation
import FirebaseFirestoreSwift

struct Things {
    @DocumentID var id: String?
    var name: String
    var category: String = ""
    var check: Bool = false
    
    
}
