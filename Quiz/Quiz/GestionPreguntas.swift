//
//  GestionPreguntas.swift
//  Quiz
//
//  Created by AlfonsoLR on 27/03/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import CoreData
import Foundation
import os.log
import UIKit

class GestionPreguntas {
    
    //MARK: Atributos
    
    private var categorias = Set<String>()
    private var preguntas = [NSManagedObject]()
    
    
    //MARK: Core Data
    
    private var contexto : NSManagedObjectContext?
    
    
    //MARK: Constructor
    
    init() {
        // Intentamos asignar el contexto de la aplicación.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Fallo al intentar asignar la variable appDelegate.")
        }
        self.contexto = appDelegate.persistentContainer.viewContext
        
        // Intentamos cargar las preguntas.
        if let preguntas = cargaPreguntas() {
            self.preguntas += preguntas
            self.categorias = self.getCategorías()
            Pregunta.siguienteId = self.getMaxIdentificador() + 1
        } else {
            Pregunta.siguienteId = 0
        }
    }
    
    
    //MARK: Métodos públicos
    
    func añadirPreguntas(preguntas: [Pregunta]) {
        for pregunta in preguntas {
            self.guardaPregunta(pregunta: pregunta)
        }
    }
    
    func eliminarPregunta(index: Int) {
        self.contexto!.delete(self.preguntas[index])
        self.preguntas.remove(at: index)
        
        // Intentamos guardar.
        do {
            try self.contexto!.save()
        } catch let error as NSError {
            print("Error al guardar cambios en la base de datos: \(error)")
        }
        
        // Es posible que la categoría de esta pregunta desaparezca...o no.
        self.categorias = self.getCategorías()
    }
    
    func filtrarPorNombre(nombre: String) -> [Pregunta] {
        let preguntasFiltro = preguntas.filter({(pregunta: NSManagedObject) -> Bool in
            let tituloPregunta = pregunta.value(forKeyPath: "titulo") as? String
            
            return tituloPregunta?.lowercased().contains(nombre.lowercased()) ?? false
        })
        
        return self.construyeResultado(vector: preguntasFiltro)
    }
    
    func filtrarPorCategoria(categoria: String) -> [Pregunta] {
        let preguntasFiltro = preguntas.filter({(pregunta: NSManagedObject) -> Bool in
            let categoriaPregunta = pregunta.value(forKeyPath: "categoria") as? String
            
            return categoriaPregunta?.lowercased().contains(categoria.lowercased()) ?? false
        })
        
        return self.construyeResultado(vector: preguntasFiltro)
    }
    
    func getCategoria(index: Int) -> String {
        let array = Array(self.categorias)
        return array[index]
    }
    
    func getNumCategorias() -> Int {
        return self.categorias.count
    }
    
    func getNumPreguntas() -> Int {
        return preguntas.count
    }
    
    func getPregunta(index: Int) -> Pregunta? {
        if index < preguntas.count {
            return Pregunta(preguntaBD: preguntas[index])
        }
        
        return nil
    }
    
    func getTodas() -> [Pregunta] {
        return construyeResultado(vector: self.preguntas)
    }
    
    func indiceDePregunta(pregunta: Pregunta) -> Int? {
        for i in 0..<self.preguntas.count {
            if let identificador = self.preguntas[i].value(forKeyPath: "identificador") as? Int {
                if identificador == pregunta.identificador {
                    return i
                }
            }
        }
        
        return nil
    }
    
    func modificarPregunta(pregunta: Pregunta, index: Int) {
        self.modificaPreguntaBD(pregunta: pregunta, index: index)
        self.categorias = self.getCategorías()
    }
    
    func preguntaEncajaEnBusqueda(pregunta: Pregunta, busqueda: String, campo: String) -> Bool {
        let cadena = (campo == "Título") ? pregunta.titulo : pregunta.categoria ?? ""
        
        return cadena.lowercased().contains(busqueda.lowercased())
    }
    
    
    //MARK: Métodos privados
    
    private func cargaPreguntas() -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pregunta_DB")
        
        do {
            let preguntas = try self.contexto!.fetch(fetchRequest)
            
            return preguntas
        } catch let error as NSError {
            print("Error al intentar recuperar las preguntas: \(error)")
        }
        
        return nil
    }
    
    private func construyeResultado(vector: [NSManagedObject]) -> [Pregunta] {
        var array = [Pregunta]()
        
        for pregunta in vector {
            if let pregConstruida = Pregunta(preguntaBD: pregunta) {
                array.append(pregConstruida)
            }
        }
        
        return array
    }
    
    private func getMaxIdentificador() -> Int {
        var maxIdentificador = 0
        
        for pregunta in self.preguntas {
            if let identificador = pregunta.value(forKeyPath: "identificador") as? Int {
                if identificador > maxIdentificador {
                    maxIdentificador = identificador
                }
            }
        }
        
        return maxIdentificador
    }
    
    private func getCategorías() -> Set<String> {
        // Dado que las categorías se pueden repetir las guardamos en un diccionario.
        // Por defecto la única categoría será Todas.
        var categorias = Set<String>()
        
        for  pregunta in self.preguntas {
            if let categoría = pregunta.value(forKeyPath: "categoria") as? String {
                categorias.insert(categoría)
            }
        }
        
        return categorias
    }
    
    private func guardaPregunta(pregunta: Pregunta) {
        let entidad = NSEntityDescription.entity(forEntityName: "Pregunta_DB", in: self.contexto!)!
        let nuevaPregunta = NSManagedObject(entity: entidad, insertInto: self.contexto!)
        
        // Asignamos valores.
        nuevaPregunta.setValue(pregunta.titulo, forKey: "titulo")
        nuevaPregunta.setValue((pregunta.imagen != nil) ? UIImagePNGRepresentation(pregunta.imagen!) : nil, forKey: "imagen")
        nuevaPregunta.setValue(pregunta.categoria, forKey: "categoria")
        nuevaPregunta.setValue(pregunta.respuestas[0], forKey: "respuesta1")
        nuevaPregunta.setValue(pregunta.respuestas[1], forKey: "respuesta2")
        nuevaPregunta.setValue(pregunta.respuestas[2], forKey: "respuesta3")
        nuevaPregunta.setValue(pregunta.respuestas[3], forKey: "respuesta4")
        
        // Guardamos pregunta en el contexto.
        do {
            try self.contexto!.save()
            self.preguntas.append(nuevaPregunta)
            
            // Actualizamos también el set de categorías.
            if let categoría = pregunta.categoria {
                self.categorias.insert(categoría)
            }
        } catch let error as NSError {
            print("Error al guardar la pregunta: \(error)")
        }
    }
    
    private func modificaPreguntaBD(pregunta: Pregunta, index: Int) {
        let preguntaBD = self.preguntas[index]
        
        preguntaBD.setValue(pregunta.titulo, forKey: "titulo")
        preguntaBD.setValue((pregunta.imagen != nil) ? UIImagePNGRepresentation(pregunta.imagen!) : nil, forKey: "imagen")
        preguntaBD.setValue(pregunta.categoria, forKey: "categoria")
        preguntaBD.setValue(pregunta.respuestas[0], forKey: "respuesta1")
        preguntaBD.setValue(pregunta.respuestas[1], forKey: "respuesta2")
        preguntaBD.setValue(pregunta.respuestas[2], forKey: "respuesta3")
        preguntaBD.setValue(pregunta.respuestas[3], forKey: "respuesta4")
        
        do {
            try self.contexto!.save()
        } catch let error as NSError {
            print("Error al guardar estado de la base de datos en modificación: \(error)")
        }
    }
}
