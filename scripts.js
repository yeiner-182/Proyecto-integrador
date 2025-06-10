// BOTON INGRESAR
document.getElementById('btnIngresar').addEventListener('click', function() {
 // Validaciones adicionales aquí si son necesarias
 window.location.href = "login.html"; 
});

// Temporizador de oferta
const countdownDate = new Date(); // Obtiene el tiempo actual en milisegundos
countdownDate.setDate(countdownDate.getDate() + 1); // Calcula la diferencia entre fechas  TRES DIAS

// funcion
function updateCountdown() {
    const now = new Date().getTime();
    const distance = countdownDate - now;

  // Verificación si el tiempo ya terminó
if (distance < 0) {
     document.getElementById('countdown').innerHTML = "¡La oferta ha terminado!";
    clearInterval(interval); // Detiene el contador
    return; // Sale de la función para evitar cálculos innecesarios
}

// Minutos restantes (después de restar las horas completas)
                                                                  // (1000 * 60 * 60 * 24) (Milisegundos en un día)         
document.getElementById('days').innerText = Math.floor(distance / (1000 * 60 * 60 * 24));
document.getElementById('hours').innerText = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
document.getElementById('minutes').innerText = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
document.getElementById('seconds').innerText = Math.floor((distance % (1000 * 60)) / 1000);
}

setInterval(updateCountdown, 1000);
updateCountdown();// Llama a la función


