//
//  BoardViewModel.swift
//  Pseudo-Ku
//
//  Created by Clarissa Calderon on 5/26/23.
//

import Foundation

class BoardViewModel {
    
    private var resultData: ResultData = ResultData()
    
    init() {}
    
    public func fetchBoard(completion: @escaping(Result<[[String]], SudokuError>) -> Void) {
        guard let path = Bundle.main.path(forResource: "Board", ofType: "json") else { return }
        let url = URL(filePath: path)
        
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            if let resultData = try? decoder.decode(ResultData.self, from: jsonData) {
                self.resultData = resultData
                completion(.success(resultData.board))
            } else {
                completion(.failure(.parsingError))
            }
        } catch {
            completion(.failure(.decodingError))
        }
    }
    
    public func isValid() -> Bool {
        return isRowsValid() && isColumnsValid() && isMiniSquaresValid()
    }
    
    private func isRowsValid() -> Bool {
        var hasDuplicates = false
        
        resultData.board.forEach { row in
            let numbers = row.filter({ $0 != "." })
            
            if numbers.count != Set(numbers).count {
                hasDuplicates = true
            }
        }
        
        return !hasDuplicates
    }
    
    private func isColumnsValid() -> Bool {
        var hasDuplicates = false
        
        for columnNumber in 0...8 {
            let column = resultData.board.map { $0[columnNumber] }.filter({ $0 != "." })
            
            if column.count != Set(column).count {
                hasDuplicates = true
            }
        }
        
        return !hasDuplicates
    }

    private func isMiniSquaresValid() -> Bool  {
        var hasDuplicates = false
        
        var firstThreeColumns: [String] = []
        var middleThreeColumns: [String] = []
        var lastThreeColumns: [String] = []
        
        var gridByMiniSquares: [[String]] = []
        
        resultData.board.forEach { row in
            firstThreeColumns.append(contentsOf: row.prefix(3))
            middleThreeColumns.append(contentsOf: row.dropFirst(3).prefix(3))
            lastThreeColumns.append(contentsOf: row.dropFirst(6).prefix(3))
        }
        
        gridByMiniSquares.append(firstThreeColumns.prefix(9).filter { $0 != "." })
        gridByMiniSquares.append(firstThreeColumns.dropFirst(9).prefix(9).filter { $0 != "." })
        gridByMiniSquares.append(firstThreeColumns.dropFirst(18).filter { $0 != "." })
        gridByMiniSquares.append(middleThreeColumns.prefix(9).filter { $0 != "." })
        gridByMiniSquares.append(middleThreeColumns.dropFirst(9).prefix(9).filter { $0 != "." })
        gridByMiniSquares.append(middleThreeColumns.dropFirst(18).filter { $0 != "." })
        gridByMiniSquares.append(lastThreeColumns.prefix(9).filter { $0 != "." })
        gridByMiniSquares.append(lastThreeColumns.dropFirst(9).prefix(9).filter { $0 != "." })
        gridByMiniSquares.append(lastThreeColumns.dropFirst(18).filter { $0 != "." })

        gridByMiniSquares.forEach { miniSquare in
            if miniSquare.count != Set(miniSquare).count {
                hasDuplicates = true
            }
        }
        
        return !hasDuplicates
    }
}

enum SudokuError: Error {
    case parsingError, decodingError
}
