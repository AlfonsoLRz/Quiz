//
//  Clasificación.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import CoreData
import Foundation
import os.log
import UIKit

class Clasificación {
    
    //MARK: Atributos
    
    private var resultados = [NSManagedObject]()        // NSManagedObject será el tipo de objeto en la BD.
    
    
    //MARK: Core Data
    
    private var contexto : NSManagedObjectContext?      // Guardamos el contexto para evitar consultarlo constantemente (es una estructura un poco compleja).
    
    
    /**
     
     Inicializa una instancia del tipo Clasificación. Se encargará de leer los resultados existentes en la base de datos.
     
    */
    init() {
        // Intentamos asignar el contexto de la aplicación.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Fallo al intentar asignar la variable appDelegate.")
        }
        self.contexto = appDelegate.persistentContainer.viewContext  
        
        if let resultados = cargaResultados() {
            self.resultados += resultados
            self.ordenaResultados()
            ResultadoPartida.siguienteId = self.getMaxIdentificador()
        } else {
            ResultadoPartida.siguienteId = 0
        }
    }
    
    
    //MARK: Métodos públicos
    
    /**
     
     Añade un nuevo resultado en la base de datos. El identificador y la fecha son generados automáticamente.
     
     - parameters:
        - categoría: tipo de partida en la que se obtuvo el resultado.
        - puntuación: puntos obtenidos en la partida.
     
    */
    func añadeResultado(categoría: String, puntuación: Int) {
        let entidad = NSEntityDescription.entity(forEntityName: "Resultado_DB", in: self.contexto!)!
        let nuevoResultado = NSManagedObject(entity: entidad, insertInto: self.contexto!)
        
        // Configuramos los valores del nuevo resultado.
        nuevoResultado.setValue(categoría, forKey: "categoria")
        nuevoResultado.setValue(puntuación, forKey: "puntuacion")
        nuevoResultado.setValue(ResultadoPartida.siguienteId, forKey: "identificador")
        nuevoResultado.setValue(ResultadoPartida.getFecha(fecha: Date()), forKey: "fecha")
        
        // Guardamos nuevo estado en la base de datos.
        do {
            try self.contexto!.save()
            
            // Agregamos el nuevo resultado a nuestro vector.
            self.resultados.append(nuevoResultado)
        } catch let error as NSError {
            print("Error al actualizar base de datos (inserción): \(error)")
        }
    }
    
    /**
     
     Devuelve aquellos resultados cuya categoría encaja con la cadena especificada.
     
     - parameters:
        - categoria: cadena que nos sirve de plantilla para buscar.
     
    */
    func filtrarPorCategoria(categoria: String) -> [ResultadoPartida] {
        let resultadoFiltro = self.resultados.filter({(resultado: NSManagedObject) -> Bool in
            let categoriaResultado = resultado.value(forKey: "categoria") as? String
            return categoriaResultado!.lowercased().contains(categoria.lowercased())
        })
        
        // Transformación al objeto accesible para el usuario externo.
        var array = [ResultadoPartida]()
        for resultado in resultadoFiltro {
            if let resultadoInit = ResultadoPartida(resultadoDB: resultado) {
                array.append(resultadoInit)
            }
        }
        
        return array
    }
    
    /**
 
     Elimina un resultado de la base de datos basándose en su índice.
     
     - parameters:
        - index: índice del resultado a eliminar.
     
    */
    func eliminaResultado(index: Int) {
        self.contexto!.delete(self.resultados[index])
        self.resultados.remove(at: index)
        
        // Intentamos guardar.
        do {
            try self.contexto!.save()
        } catch let error as NSError {
            print("Error al guardar cambios en la base de datos: \(error)")
        }
    }
    
    /**
     
     Devuelve el número de resultados existentes en la base de datos.
     
    */
    func getNumResultados() -> Int {
        return resultados.count
    }
    
    /**
 
     Devuelve un resultado específico basándose en el índice.
     
    */
    func getResultado(index: Int) -> ResultadoPartida? {
        if index < self.resultados.count {
            return ResultadoPartida(resultadoDB: self.resultados[index])
        }
        
        return nil
    }
    
    /**
 
     Devuelve el índice en el vector general de resultados del resultado pasado como parámetro. Nótese
     que si éste no pertenece a la base de datos, el índice será nulo.
     
    */
    func índiceDeResultado(resultado: ResultadoPartida) -> Int? {
        // Comparación en función de identificador.
        for i in 0..<self.resultados.count {
            if let identificador = self.resultados[i].value(forKey: "identificador") as? Int {
                if identificador == resultado.identificador {
                    return i
                }
            }
        }
        
        return nil
    }
    
    
    //MARK: Métodos privados
    
    /**
 
     Devuelve un vector con los resultados almacenados en la base de datos.
     
    */
    private func cargaResultados() -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Resultado_DB")
        
        do {
            let resultados = try self.contexto!.fetch(fetchRequest)
            
            return resultados
        } catch let error as NSError {
            print("Error al intentar recuperar los resultados: \(error)")
        }
        
        return nil
    }
    
    /**
     
     Devuelve el máximo identificador presente entre todos los resultados almacenados. Nos servirá para inicializar
     la clase ResultadoPartida, de tal forma que se comiencen a asignar identificadores mayores que el máximo y no
     haya colisiones.
     
    */
    private func getMaxIdentificador() -> Int {
        var maxIdentificador = 0
        
        for resultado in self.resultados {
            if let identificador = resultado.value(forKeyPath: "identificador") as? Int {
                if identificador > maxIdentificador {
                    maxIdentificador = identificador
                }
            }
        }
        
        return maxIdentificador
    }
    
    /**
     
     Ordena los resultados almacenados en función de la puntuación. De mayor a menor.
     
    */
    private func ordenaResultados() {
        self.resultados.sort(by: {($0.value(forKeyPath: "puntuacion") as? Int)! > ($1.value(forKeyPath: "puntuacion") as? Int)!})
    }
}
