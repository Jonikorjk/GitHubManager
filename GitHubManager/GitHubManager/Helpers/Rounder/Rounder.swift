//
//  Rounder.swift
//  GitHubManager
//
//  Created by User on 07.12.2022.
//

import Foundation

func round(_ value: Double, toNearest: Double) -> Double {
  return round(value / toNearest) * toNearest
}
