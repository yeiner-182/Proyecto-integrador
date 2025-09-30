// Funciones globales para toda la aplicación
document.addEventListener('DOMContentLoaded', function() {
    actualizarEstadoUsuario();
    actualizarBadgeCarrito();
});

function actualizarEstadoUsuario() {
    const loginLink = document.getElementById('loginLink');
    const registerLink = document.getElementById('registerLink');
    const userDivider = document.getElementById('userDivider');
    const profileLink = document.getElementById('profileLink');
    const logoutLink = document.getElementById('logoutLink');

    if (tienda.clienteActual) {
        // Usuario logueado
        if (loginLink) loginLink.style.display = 'none';
        if (registerLink) registerLink.style.display = 'none';
        if (userDivider) userDivider.style.display = 'block';
        if (profileLink) {
            profileLink.style.display = 'block';
            profileLink.innerHTML = `<i class="fas fa-user me-2"></i>${tienda.clienteActual.nombre}`;
        }
        if (logoutLink) logoutLink.style.display = 'block';
    } else {
        // Usuario no logueado
        if (loginLink) loginLink.style.display = 'block';
        if (registerLink) registerLink.style.display = 'block';
        if (userDivider) userDivider.style.display = 'none';
        if (profileLink) profileLink.style.display = 'none';
        if (logoutLink) logoutLink.style.display = 'none';
    }

    // Event listener para cerrar sesión
    if (logoutLink) {
        logoutLink.addEventListener('click', function(e) {
            e.preventDefault();
            tienda.cerrarSesion();
            actualizarEstadoUsuario();
            mostrarMensaje('Sesión cerrada correctamente', 'success');
        });
    }
}

function actualizarBadgeCarrito() {
    const badge = document.getElementById('carritoBadge');
    if (badge) {
        const totalItems = tienda.carritoGlobal.listaProductos.reduce((total, item) => total + item.cantidad, 0);
        badge.textContent = totalItems;
        
        if (totalItems === 0) {
            badge.style.display = 'none';
        } else {
            badge.style.display = 'block';
        }
    }
}

function mostrarMensaje(mensaje, tipo = 'info') {
    const tipoBootstrap = tipo === 'error' ? 'danger' : tipo;
    
    // Remover mensajes existentes
    const mensajesExistentes = document.querySelectorAll('.alert-mensaje');
    mensajesExistentes.forEach(msg => msg.remove());
    
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${tipoBootstrap} alert-dismissible fade show alert-mensaje position-fixed`;
    alertDiv.style.top = '20px';
    alertDiv.style.right = '20px';
    alertDiv.style.zIndex = '9999';
    alertDiv.style.minWidth = '300px';
    alertDiv.innerHTML = `
        ${mensaje}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(alertDiv);
    
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.parentNode.removeChild(alertDiv);
        }
    }, 4000);
}