import UIKit
import Foundation


func readJSONFile(path : String) -> Data?  {
    
    guard let pathString = Bundle.main.path(forResource: path, ofType: "json") else {
        print("UnitTestData.json not found")
        return nil
    }
    
    guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: String.Encoding.utf8.rawValue) else {
        print("Unable to convert UnitTestData.json to String")
        return nil
    }
    
    guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
        print("Unable to convert UnitTestData.json to NSData")
        return nil
    }
    
    return jsonData
}


func decode<T: Decodable>(data: Data) throws -> T {
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
}

struct Json : Codable {
    let jobs : [Person]
    
    enum CodingKeys: String, CodingKey {
        case jobs = "Json"
    }
    
    struct Person : Codable {
        let job : Job_Info
        let firstname : String
        let lastname : String
        let age : Int
        
        enum CodingKeys: String, CodingKey {
            case job = "job_information"
            case firstname, lastname, age
        }
    }
    
    struct Job_Info : Codable {
        let title : String
        let salary : Int?
        
        enum CodingKeys: String, CodingKey {
            case title, salary
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
            salary = try container.decode(Int.self, forKey: .salary)
        }
        
    }
}


if let json = readJSONFile(path: "Job") {
    
    let presonObj : Json = try decode(data: json)
    for jb in presonObj.jobs {
        print(jb.firstname)
        print(jb.job.salary as Any)
    }
}

