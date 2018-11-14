//
//  benchMap.swift
//  Maps Benchmark
//
//  Created by Gideon Rabson on 11/13/18.
//  Copyright © 2018 Gideon Rabson. All rights reserved.
//

import Foundation

protocol BenchMapProtocol: Map where Key == Int, Value == Int {}

extension LinearMap: BenchMapProtocol where Key == Int, Value == Int {}
extension BinaryMap: BenchMapProtocol where Key == Int, Value == Int {}
extension HashMap: BenchMapProtocol where Key == Int, Value == Int {}
