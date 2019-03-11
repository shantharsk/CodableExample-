import UIKit
import Foundation

fileprivate class BundleTargetingClass {}

func readJSONFile(path : String) -> Data?  {
    
    guard let filePath = Bundle(for: BundleTargetingClass.self).url(forResource: path, withExtension: "json") else {
        return nil
    }
    
    guard let jsonData = try? Data(contentsOf: filePath, options: .mappedIfSafe) else {
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

struct Json : Decodable {
    let peoples : [People]
    let corporate : [Corporate]
    
    enum CodingKeys: String, CodingKey {
        case peoples = "people"
        case corporate = "corporate"
    }
    
    struct People : Codable {
        let job : JobInfo
        let firstname : String
        let lastname : String
        let age : Int
        
        enum CodingKeys: String, CodingKey {
            case job = "job_information"
            case firstname, lastname, age
        }
    }
    
    struct JobInfo : Codable {
        let title : String
        let salary : Int?
        
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

