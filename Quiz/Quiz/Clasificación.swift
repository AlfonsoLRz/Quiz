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
    private var resultados = [NSManagedObject]()
    
    
    //MARK: Core Data
    
    private var contexto : NSManagedObjectContext?
    
    
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
    
    func getNumResultados() -> Int {
        return resultados.count
    }
    
    func getResultado(index: Int) -> ResultadoPartida? {
        if index < self.resultados.count {
            return ResultadoPartida(resultadoDB: self.resultados[index])
        }
        
        return nil
    }
    
    func índiceDeResultado(resultado: ResultadoPartida) -> Int? {
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
    
    private func ordenaResultados() {
        self.resultados.sort(by: {($0.value(forKeyPath: "puntuacion") as? Int)! > ($1.value(forKeyPath: "puntuacion") as? Int)!})
    }
}
