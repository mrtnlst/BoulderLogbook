//
//  FormAction.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

enum FormAction {
    case cancel
    case save
    case increase(BoulderGrade)
    case decrease(BoulderGrade)
    case didSelectDate(Date)
}
