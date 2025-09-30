// Para login.html
if (window.location.pathname.includes('login.html')) {
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            const resultado = tienda.iniciarSesion(email, password);
            
            if (resultado.exito) {
                mostrarMensaje('✅ Inicio de sesión exitoso', 'success');
                setTimeout(() => {
                    window.location.href = 'index.html';
                }, 1500);
            } else {
                mostrarMensaje(`❌ ${resultado.mensaje}`, 'error');
            }
        });

        // Mostrar/ocultar contraseña
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
        });
    });
}

// Para registro.html
if (window.location.pathname.includes('registro.html')) {
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!this.checkValidity()) {
                e.stopPropagation();
                this.classList.add('was-validated');
                return;
            }
            
            const nombre = document.getElementById('nombre').value;
            const apellido = document.getElementById('apellido').value;
            const email = document.getElementById('email').value;
            const contrasena = document.getElementById('contrasena').value;
            const confirmarContrasena = document.getElementById('confirmarContrasena').value;
            const telefono = document.getElementById('telefono').value;
            
            if (contrasena !== confirmarContrasena) {
                mostrarMensaje('❌ Las contraseñas no coinciden', 'error');
                return;
            }
            
            const resultado = tienda.registrarCliente(
                `${nombre} ${apellido}`,
                email,
                'Dirección por definir',
                email,
                contrasena
            );
            
            if (resultado.exito) {
                mostrarMensaje('✅ Registro exitoso. Ahora puede iniciar sesión.', 'success');
                setTimeout(() => {
                    window.location.href = 'login.html';
                }, 2000);
            }
        });

        // Mostrar/ocultar contraseña
        document.getElementById('togglePassword').addEventListener('click', function() {
            const passwordInput = document.getElementById('contrasena');
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.innerHTML = type === 'password' ? '<i class="fas fa-eye"></i>' : '<i class="fas fa-eye-slash"></i>';
        });
    });
}