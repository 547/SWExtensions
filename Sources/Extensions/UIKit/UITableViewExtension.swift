//
//  UITableViewExtension.swift
//  SWExtensions
//
//  Created by Seven on 2019/6/17.
//  Copyright © 2019 CYCON.com. All rights reserved.
//

import UIKit

extension UITableView {
    public func dequeueReusableCell<T>(withIdentifier identifier: String, _ initClosure: (_ identifier: String) -> T) -> T {
        return dequeueReusableCell(withIdentifier: identifier) as? T ?? initClosure(identifier)
    }
}
