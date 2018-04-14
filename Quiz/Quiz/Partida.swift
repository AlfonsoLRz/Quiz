//
//  Partida.swift
//  Quiz
//
//  Created by AlfonsoLR on 06/04/2018.
//  Copyright © 2018 AlfonsoLR. All rights reserved.
//

import Foundation

class Partida {
    
    //MARK: Atributos
    
    private let PUNTOS_POR_ACIERTO = 150;           // Número de puntos por pregunta acertada.
    
    private var aciertos : Int                      // Número de aciertos que lleva el usuario de momento.
    private var categoría : String                  // Categoría a la que pertenece la partida.
    private var preguntas : [Pregunta]              // Array de preguntas. Se baraja para que sea aleatorio.
    private var preguntasSinUtilizar = [Int]()      // Array con los índices de las preguntas sin utilizar.
    private var tiempoTotal : Int                   // Número de segundos total empleado por pregunta.
    
    
    /**
     
     Inicialización de una partida. Sólo necesitamos la categoría y el array total de preguntas a utilizar (sin barajar).
     
    */
    init?(categoría: String, preguntas: [Pregunta]) {
        if preguntas.count == 0 {
            return nil
        }
        
        self.aciertos = 0
        self.categoría = categoría
        self.preguntas = preguntas
        self.tiempoTotal = 0        // Tiempo empleado en responder todas las preguntas en segundos.
        
        // Inicializamos el vector de preguntas sin responder...
        for i in 0..<self.preguntas.count {
            self.preguntasSinUtilizar.append(i)
        }
    }
    
    //MARK: Métodos públicos
    
    /**
 
     Suma un acierto a la partida.
     
    */
    func sumarAcierto() {
        self.aciertos += 1
    }
    
    /**
 
     Añade el tiempo empleado en una pregunta (en segundos).
     
    */
    func sumarTiempo(tiempo: Int) {
        self.tiempoTotal += tiempo
    }
    
    /**
 
     Devuelve el número de aciertos obtenidos durante la partida.
     
    */
    func getAciertos() -> Int {
        return self.aciertos
    }
    
    /**
 
     Devuelve la categoría a la que pertenece la pregunta.
     
    */
    func getCategoría() -> String {
        return self.categoría
    }
    
    /**
 
     Devuelve el número de preguntas ya utilizadas en la partida.
     
    */
    func getPreguntasUtilizadas() -> Int {
        return self.preguntas.count - self.preguntasSinUtilizar.count
    }
    
    /**
     
     Devuelve el número de puntos obtenidos de momento. Habrá que tener en cuenta que el número de puntos obtenidos por acierto es de 150.
 
    */
    func getPuntuación() -> Int {
        return self.aciertos * self.PUNTOS_POR_ACIERTO
    }
    
    /**
 
     Extrae la siguiente pregunta a mostrar al usuario.
     
    */
    func getSiguientePregunta() -> Pregunta? {
        let preguntasUtilizadas = self.getPreguntasUtilizadas()
        if preguntasUtilizadas == self.preguntas.count {
            return nil
        }
        
        // No tenemos operador unario ++...
        let randomIndex = self.getSiguienteÍndice()
        let index = self.preguntasSinUtilizar[randomIndex]
        self.preguntasSinUtilizar.remove(at: randomIndex)
        return self.preguntas[index]
    }
    
    /**
 
     Devuelve el tiempo medio (en segundos) empleado para responder todas las preguntas (respondidas).
 
    */
    func getTiempoMedio() -> Float {
        let preguntasUtilizadas = self.getPreguntasUtilizadas()
        if preguntasUtilizadas != 0 {
            return (Float(self.tiempoTotal / preguntasUtilizadas))
        }
        
        return 0
    }
    
    /**
     
     Devuelve el número total de preguntas.
 
    */
    func getTotalPreguntas() -> Int {
        return self.preguntas.count
    }
    
    
    //MARK: Métodos privados
    
    /**
     
     Devuelve el índice de la siguiente pregunta a utilizar.
     
    */
    private func getSiguienteÍndice() -> Int {
        return Int(arc4random_uniform(UInt32(self.preguntasSinUtilizar.count)))
    }
}
