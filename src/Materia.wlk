class Materia {

	var property cupo = 0
	const property confirmados = []
	const property espera = []

	method agregarAConfirmado(estudiante) {
		confirmados.add(estudiante)
	}

	method agregarAEspera(estudiante) {
		espera.add(estudiante)
	}

	method agregarRequisitos(_requisitos) {
		requerimiento.agregarRequisitos(_requisitos)
	}

	method aprobar(estudiante, _nota) {
		aprobacion.aprobar(estudiante, self, _nota)
	}

	method aumentarCupo() {
		cupo += 1
	}

	method desuscribir(estudiante) {
		baja.desuscribir(estudiante, self)
	}

	method disminuirCupo() {
		cupo -= 1
	}

	method quitarDeConfirmado(estudiante) {
		confirmados.remove(estudiante)
	}

	method quitarDeEspera(estudiante) {
		espera.remove(estudiante)
	}

	method inscribir(estudiante) {
		inscripcion.inscribir(estudiante, self)
	}

	method corresponde(carrera) = carrera.tiene(self)

	method estaConfirmado(estudiante) = confirmados.contains(estudiante)

	method estaEnEspera(estudiante) = espera.contains(estudiante)

	method estaEnLaCarreraQueCursa(estudiante) = estudiante.carreras().any{ carrera => carrera.tiene(self) }

	method numeroDeEspera() = espera.size()

	method primeroEnEspera() = espera.head()

	method tieneInscripto(estudiante) = confirmados.contains(estudiante)

}

//OBJETO APROBACIÓN, PARA VALIDACIONES
object aprobacion {

	method aprobar(estudiante, _materia, _nota) {
		self.validarPara(estudiante, _materia)
		estudiante.agregarMateriaAprobada(new MateriaAprobada(materia = _materia, nota = _nota))
	}

	method validarPara(estudiante, materia) {
		if (estudiante.tieneAprobada(materia)) {
			self.error("El estudiante ya tiene la materia aprobada.")
		}
	}

}
class MateriaAprobada {

	const property materia
	const property nota

}

//OBJETO INSCRIPCION
object inscripcion {

	method inscribir(estudiante, materia) {
		requerimiento.validarCumplimientoDeRequerimientosPara(estudiante, materia)
		cupos.validarCuposPara(estudiante, materia)
		self.agregarInscripcion(estudiante, materia)
	}

	method agregarInscripcion(estudiante, materia) {
		if (materia.cupo() > 0) {
			materia.agregarAConfirmado(estudiante)
			materia.disminuirCupo()
		} else {
			materia.agregarAEspera(estudiante)
		}
	}

}

//OBJETO REQUERIMIENTO, PARA LAS VALIDACIONES
object requerimiento {

	const property requisitos = #{}

	method agregarRequisitos(_requisitos) {
		requisitos.addAll(_requisitos)
	}

	method validarCumplimientoDeRequerimientosPara(estudiante, materia) {
		if (!self.puedeInscribirse(estudiante, materia)) {
			self.error("El estudiante no cumple los requisitos para inscribirse.")
		}
	}

	method puedeInscribirse(estudiante, materia) = 
        !materia.tieneInscripto(estudiante)         && 
        !estudiante.tieneAprobada(materia)          && 
        materia.estaEnLaCarreraQueCursa(estudiante) && 
        self.cumpleLosRequisitos(estudiante)

	method cumpleLosRequisitos(estudiante) = requisitos.all{ requisito => estudiante.tieneAprobada(requisito) }

}

//OBJETO CUPOS, PARA VALIDADCIONES
object cupos {

	method validarCuposPara(estudiante, materia) {
		if (!self.puedeInscribirse(estudiante, materia)) {
			self.error("El estudiante ya esta inscripto en la materia.")
		}
	}

	method puedeInscribirse(estudiante, materia) = !materia.estaEnEspera(estudiante) || !materia.estaConfirmado(estudiante)

}

object baja {

	method desuscribir(estudiante, materia) {
		self.validarPara(estudiante, materia)
		self.quitarInscripcion(estudiante, materia)
	}

	method validarPara(estudiante, materia) {
		if (!materia.tieneInscripto(estudiante)) {
			self.error("El estudiante no esta inscripto en la materia.")
		}
	}

	method quitarInscripcion(estudiante, materia) {
		if (materia.estaEnEspera(estudiante)) {
			materia.quitarDeEspera(estudiante)
		} else {
			materia.quitarDeConfirmado(estudiante)
		}
		if (materia.numeroDeEspera() > 0) {
			materia.agregarAConfirmado(materia.primeroEnEspera())
			materia.quitarDeEspera(materia.primeroEnEspera())
		} else {
			materia.aumentarCupo()
		}
	}

}
