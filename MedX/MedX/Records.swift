import Foundation

struct Record: Codable{
    let Name: String
    let Meta: String
}

//struct fileName: Codable{
//    let ACL: String
//    let Address: String
//    let Name: String
//}

struct Records: Codable {
    let records: [Record]
}
