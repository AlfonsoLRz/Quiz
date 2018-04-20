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
    
    private var categorias = Set<String>()              // Conjunto de categorías de todas las preguntas (útil para comenzar una partida).
    private var preguntas = [NSManagedObject]()         // Conjunto de preguntas activo (de la BD).
    
    
    //MARK: Core Data
    
    private var contexto : NSManagedObjectContext?      // Contexto de la BD donde haremos nuestras consultas y manejaremos los datos.
    
    
    //MARK: Constructor
    
    /**
     
     Constructor de la Gestión de preguntas. Carga las preguntas disponibles de la base de datos.
 
     */
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
    
    /**
     
     Añade un conjunto de preguntas al ya existente.
     
     */
    func añadirPreguntas(preguntas: [Pregunta]) {
        for pregunta in preguntas {
            self.guardaPregunta(pregunta: pregunta)
        }
    }
    
    /**
     
     Elimina una pregunta existente en la BD.
     
     - parameters:
        - index: Índice que ocupa la pregunta que se desea borrar en el vector.
 
     */
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
    
    /**
     
     Obtiene un subconjunto de preguntas de la BD en función del nombre de las mismas. Nótese que no se devuelve un
     vector de preguntas de la BD, sino de preguntas nuestras, de tal forma que desde fuera es mucho más fácil la
     manipulación de las mismas.
     
     - parameters:
        - nombre: Título de la pregunta que se busca.
     
     */
    func filtrarPorNombre(nombre: String) -> [Pregunta] {
        let preguntasFiltro = preguntas.filter({(pregunta: NSManagedObject) -> Bool in
            let tituloPregunta = pregunta.value(forKeyPath: "titulo") as? String
            
            return tituloPregunta?.lowercased().contains(nombre.lowercased()) ?? false
        })
        
        return self.construyeResultado(vector: preguntasFiltro)
    }
    
    /**
     
     Obtiene un subconjunto de preguntas de la BD en función de la categoría de las mismas.
     
     - parameters:
        - categoria: Cadena con la categoría que se busca en las preguntas.
 
     */
    func filtrarPorCategoria(categoria: String) -> [Pregunta] {
        let preguntasFiltro = preguntas.filter({(pregunta: NSManagedObject) -> Bool in
            let categoriaPregunta = pregunta.value(forKeyPath: "categoria") as? String
            
            return categoriaPregunta?.lowercased().contains(categoria.lowercased()) ?? false
        })
        
        return self.construyeResultado(vector: preguntasFiltro)
    }
    
    /**
     
     Devuelve la categoría de una pregunta en el índice indicado.
 
     */
    func getCategoria(index: Int) -> String {
        let array = Array(self.categorias)
        return array[index]
    }
    
    /**
     
     Devuelve el número de categorías distintas en todo el conjunto de la pregunta.
     
     */
    func getNumCategorias() -> Int {
        return self.categorias.count
    }
    
    /**
     
     Devuelve el número de preguntas existentes.
 
     */
    func getNumPreguntas() -> Int {
        return preguntas.count
    }
    
    /**
     
     Devuelve una pregunta en una posición marcada por index. Nótese que no se devuelve un objeto de la BD sino una pregunta
     propia de más fácil manipulación.
     
     */
    func getPregunta(index: Int) -> Pregunta? {
        if index < preguntas.count {
            return Pregunta(preguntaBD: preguntas[index])
        }
        
        return nil
    }
    
    /**
 
     Devuelve todas las preguntas existentes en la base de datos en forma de objeto Pregunta.
 
     */
    func getTodas() -> [Pregunta] {
        return construyeResultado(vector: self.preguntas)
    }
    
    /**
     
     Devuelve el índice que ocupa una pregunta concreta.
     Se distingue una pregunta de otra por el identificador en la base de datos.
     
     - parameters:
        - pregunta: pregunta con la que compararemos para buscar el índice.
 
     */
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
    
    /**
 
     Modifica la información de una pregunta a partir del índice que ocupa la pregunta que se quiere modificar,
     y una nueva pregunta que contendrá la información que se quiere actualizar.
 
     */
    func modificarPregunta(pregunta: Pregunta, index: Int) {
        self.modificaPreguntaBD(pregunta: pregunta, index: index)
        self.categorias = self.getCategorías()
    }
    
    /**
     
     Devuelve un booleano en función de si la pregunta espeficada encaja en la búsqueda (por un campo).
 
     */
    func preguntaEncajaEnBusqueda(pregunta: Pregunta, busqueda: String, campo: String) -> Bool {
        let cadena = (campo == "Título") ? pregunta.titulo : pregunta.categoria ?? ""
        
        return cadena.lowercased().contains(busqueda.lowercased())
    }
    
    
    //MARK: Métodos privados
    
    /**
 
     Carga las preguntas existentes en la base de datos.
     
     */
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
    
    /**
 
     Construye un objeto Pregunta (nuestro) a partir de un objeto de la Base de datos, de esta forma es más fácil
     el trabajo desde el exterior.
     
     */
    private func construyeResultado(vector: [NSManagedObject]) -> [Pregunta] {
        var array = [Pregunta]()
        
        for pregunta in vector {
            if let pregConstruida = Pregunta(preguntaBD: pregunta) {
                array.append(pregConstruida)
            }
        }
        
        return array
    }
    
    /**
     
     Devuelve el máximo identificador existente en la base de datos, de esta forma se puede comenzar a crear preguntas sin
     pisar los identificadores de las ya existentes.
 
     */
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
    
    /**
     
     Devuelve un conjunto de categorías de todas las preguntas existentes. Nótese que cada categoría sólo aparecerá una vez.
 
     */
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
    
    /**
 
     Guarda una pregunta en la base de datos.
 
     */
    private func guardaPregunta(pregunta: Pregunta) {
        let entidad = NSEntityDescription.entity(forEntityName: "Pregunta_DB", in: self.contexto!)!
        let nuevaPregunta = NSManagedObject(entity: entidad, insertInto: self.contexto!)
        
        // Asignamos valores.
        nuevaPregunta.setValue(pregunta.identificador, forKey: "identificador")
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
    
    /**
 
     Modifica la información de una pregunta en la base de datos.
     
     - parameters:
        - pregunta: Pregunta con la información que tendrá la pregunta en la base de datos.
        - index: Índice de la pregunta que se quiere modificar en la base de datos.
     
     */
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
