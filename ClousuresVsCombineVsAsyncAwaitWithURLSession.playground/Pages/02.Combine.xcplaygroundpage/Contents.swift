/*
    Ejemplo anterior pero con Combine
 */

import Foundation
import Combine
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


//Modelo de bootcamps

struct BootCamps: Codable{
    let id:UUID
    let name:String
}

// extension
extension URLResponse{
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse{
            return httpResponse.statusCode
        }
        return nil
    }
}

final class testLoad{
    var bootCamp: [BootCamps] = Array<BootCamps>() //datos
    var suscriber = Set<AnyCancellable>()
    
    func loadBootCamps(){
        //Definimos el request
        let url = URL(string: "https://dragonball.keepcoding.education/api/data/bootcamps")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared
            .dataTaskPublisher(for: request) //aqui ya ejecuta
            .tryMap{
                guard let response = $0.response as? HTTPURLResponse,
                      response.statusCode == 200 else{
                    //Error
                    throw URLError(.badServerResponse)
                }
                
                //Todo esta OK. Devuelvo los datos
                return $0.data
            }
            .decode(type: [BootCamps].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) //hilo principal
            .sink { completion in
                //evaluamos
                switch completion{
                case .failure(let error):
                    print("Error: \(error)")
                case.finished:
                    print("Finalizado")
                }
            } receiveValue: { data in
                //Ok llega el dato
                self.bootCamp = data //asigno los datos
                //logear
                data.forEach { BootCamp in
                    print("\(BootCamp.name)")
                }
            }
            .store(in: &suscriber)
    }
}

//hacer la llamada
let obj = testLoad()
obj.loadBootCamps()
