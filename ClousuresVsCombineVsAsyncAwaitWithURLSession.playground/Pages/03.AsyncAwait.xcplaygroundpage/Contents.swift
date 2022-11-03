/*
  Ejemplo con Async-Await
 */
import Foundation
import SwiftUI
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


struct BootCamps: Codable{
    let id:UUID
    let name:String
}

extension URLResponse{
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse{
            return httpResponse.statusCode
        }
        return nil
    }
}

final class testLoad{
    func loadBootCamps() async throws -> [BootCamps] {
        let url = URL(string: "https://dragonball.keepcoding.education/api/data/bootcamps")
        let (data, _) =  try await URLSession.shared.data(from: url!)
        return try JSONDecoder().decode([BootCamps].self, from: data)
    }
}

//Task provee de un contxto asincrono y se le puede indicar la prioridad
Task(priority: .medium){
    let obj = testLoad()
    let data = try await obj.loadBootCamps()
    
    //pintamos
    data.forEach { BootCamp in
        print("\(BootCamp.name)")
    }
}
