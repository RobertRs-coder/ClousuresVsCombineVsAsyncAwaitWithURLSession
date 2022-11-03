
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


//Modelo de bootcamps

struct BootCamps: Codable{
    let id:UUID
    let name:String
}

//Creamos los typeA Alias
typealias successClosure = ([BootCamps]) -> Void
typealias errorClousure = (() -> Void)?

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
    //Cargamos los bootcamps
    func loadBootCamps(onSuccess: @escaping successClosure, onError: errorClousure){
        
        let url = URL(string: "https://dragonball.keepcoding.education/api/data/bootcamps")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            
            // Control de error
            if (error != nil){
                onError!()
                return
            }
            
            //evaluamos la respuesta
            if (response?.getStatusCode() == 200){
                // esta OK
                do{
                    if let datos = data{
                        //Decode del JSon -> model
                        let model = try JSONDecoder().decode([BootCamps].self, from: datos)
                        onSuccess(model) //All is OK!!!! :-)
                        
                    } else{
                        onError!()
                    }
                    
                } catch{
                    onError!()
                }
                
                
            } else{
                //Error
                onError!()
                return
            }
        }
        
        task.resume() //ejecutamos la llamada
    }
}

//Llamar a la descarga
let obj = testLoad()

obj.loadBootCamps { data in
    //Success
    DispatchQueue.main.async {
        data.forEach { BootCamp in
            print("\(BootCamp.name)")
        }
    }
} onError: {
    DispatchQueue.main.async {
        print("Error")
    }
}


