// Para carrito.html
document.addEventListener('DOMContentLoaded', function() {
    cargarCarrito();
    actualizarBadgeCarrito();
    
    document.getElementById('btnConfirmarCompra').addEventListener('click', confirmarCompra);
});

function cargarCarrito() {
    const listaProductosCarrito = document.getElementById('listaProductosCarrito');
    const carritoVacio = document.getElementById('carritoVacio');
    const carritoConProductos = document.getElementById('carritoConProductos');
    
    if (tienda.carritoGlobal.listaProductos.length === 0) {
        carritoVacio.style.display = 'block';
        carritoConProductos.style.display = 'none';
        return;
    }
    
    carritoVacio.style.display = 'none';
    carritoConProductos.style.display = 'block';
    
    let html = '';
    tienda.carritoGlobal.listaProductos.forEach(item => {
        const subtotal = item.producto.precio * item.cantidad;
        html += `
            <div class="row mb-3 align-items-center">
                <div class="col-md-2">
                    <img src="${item.producto.imagen}" alt="${item.producto.nombre}" class="img-fluid rounded" style="height: 80px; object-fit: cover;">
                </div>
                <div class="col-md-4">
                    <h6 class="mb-0">${item.producto.nombre}</h6>
                    <small class="text-muted">$${item.producto.precio.toLocaleString()}</small>
                </div>
                <div class="col-md-3">
                    <div class="input-group input-group-sm">
                        <button class="btn btn-outline-secondary" type="button" onclick="cambiarCantidad(${item.producto.idProducto}, ${item.cantidad - 1})">-</button>
                        <input type="number" class="form-control text-center" value="${item.cantidad}" min="1" onchange="cambiarCantidad(${item.producto.idProducto}, parseInt(this.value))">
                        <button class="btn btn-outline-secondary" type="button" onclick="cambiarCantidad(${item.producto.idProducto}, ${item.cantidad + 1})">+</button>
                    </div>
                </div>
                <div class="col-md-2">
                    <strong>$${subtotal.toLocaleString()}</strong>
                </div>
                <div class="col-md-1">
                    <button class="btn btn-outline-danger btn-sm" onclick="eliminarProducto(${item.producto.idProducto})">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
            <hr>
        `;
    });
    
    listaProductosCarrito.innerHTML = html;
    
    // Actualizar totales
    document.getElementById('subtotal').textContent = `$${tienda.carritoGlobal.total.toLocaleString()}`;
    document.getElementById('totalCarrito').textContent = `$${tienda.carritoGlobal.total.toLocaleString()}`;
}

function cambiarCantidad(idProducto, nuevaCantidad) {
    if (nuevaCantidad < 1) {
        eliminarProducto(idProducto);
        return;
    }
    
    tienda.carritoGlobal.actualizarCantidad(idProducto, nuevaCantidad);
    cargarCarrito();
    actualizarBadgeCarrito();
}

function eliminarProducto(idProducto) {
    tienda.carritoGlobal.eliminarProducto(idProducto);
    cargarCarrito();
    actualizarBadgeCarrito();
    mostrarMensaje('🗑️ Producto eliminado del carrito', 'warning');
}

function confirmarCompra() {
    if (!tienda.clienteActual) {
        mostrarMensaje('⚠️ Debe iniciar sesión para confirmar la compra', 'warning');
        setTimeout(() => {
            window.location.href = 'login.html';
        }, 2000);
        return;
    }
    
    const resultado = tienda.generarOrden();
    if (resultado.exito) {
        mostrarMensaje(`🎉 ¡Compra confirmada! Número de orden: ${resultado.orden.numeroOrden}`, 'success');
        setTimeout(() => {
            window.location.href = 'index.html';
        }, 3000);
    } else {
        mostrarMensaje(resultado.mensaje, 'error');
    }
}