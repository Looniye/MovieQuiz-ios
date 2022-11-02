import Foundation

protocol StatisticService: AnyObject {
    var gamesCount: Int {get}
    var bestGame: GameRecord {get}
    var totalAccuracy: Double {get}
    func store (correct count: Int, total amount: Int)
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, currentGame, accuracy
    }
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    var gamesCount: Int  {
        get{
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var totalAccuracy: Double {
        get{
            userDefaults.double(forKey: Keys.accuracy.rawValue)
            
        }
        set{
            userDefaults.set(newValue, forKey: Keys.accuracy.rawValue)
        }
    }
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? decoder.decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? encoder.encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        totalAccuracy = (totalAccuracy * Double(gamesCount) + Double(count)/Double(amount)) / Double(gamesCount+1)
        var currentGame: GameRecord
        
        gamesCount += 1
        
        currentGame = GameRecord(correct: count, total: amount, date: Date())
        
        if bestGame.correct < currentGame.correct {
            bestGame = currentGame
        }
    }
}
