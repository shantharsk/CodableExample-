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


func decode<T: Decodable>(data: Data) -> (decodeObj : T?, error : Error?) {
    
    var decodeObj : T? = nil
    var de_Error : Error? = nil
    let decoder = JSONDecoder()
    
    do {
        decodeObj = try decoder.decode(T.self, from: data)
    } catch {
        de_Error = error
    }
    
    return (decodeObj, de_Error)
}

struct Json : Codable {
    let peoples : [People]
    let corporate : [Corporate]
    
    enum CodingKeys: String, CodingKey {
        case peoples = "people"
        case corporate = "corporate"
    }
    
    struct People : Codable {
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
    
    
    struct Corporate : Codable {
        let name : String
        let address : String
        let isMNC : Bool
        
        enum CodingKeys: String, CodingKey {
            case name, address, isMNC
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            address = try container.decode(String.self, forKey: .address)
            isMNC = try container.decode(Bool.self, forKey: .isMNC)
        }
        
    }
    
}


if let json = readJSONFile(path: "Job") {
    
    let presonObj : (Json?, Error?) = decode(data: json)
    
    if let jb = presonObj.0 {
        for jb in jb.peoples{
            print(jb.firstname)
            print(jb.job.salary as Any)
        }
        
        for cr in jb.corporate {
            print(cr.name)
            print(cr.address)
            print(cr.isMNC)
        }
        
    } else {
        print(presonObj.1?.localizedDescription)
    }
    
}

