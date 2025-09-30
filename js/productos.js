// Para páginas de categorías (lo-nuevo.html, camisas-blusas.html, etc.)
document.addEventListener('DOMContentLoaded', function() {
    const categoria = obtenerCategoriaDePagina();
    cargarProductosPorCategoria(categoria);
    actualizarBadgeCarrito();
});

function obtenerCategoriaDePagina() {
    const path = window.location.pathname;
    const page = path.split("/").pop();
    
    const categorias = {
        'lo-nuevo.html': 'Nuevo',
        'camisas-blusas.html': 'Camisas',
        'jeans.html': 'Jeans',
        'vestidos.html': 'Vestidos',
        'zapatos.html': 'Zapatos',
        'accesorios.html': 'Accesorios'
    };
    
    return categorias[page] || 'Todos';
}

function cargarProductosPorCategoria(categoria) {
    const productosContainer = document.getElementById('productosContainer');
    let productos = [];
    
    if (categoria === 'Nuevo') {
        // Últimos 8 productos como "nuevos"
        productos = tienda.productos.slice(-8);
    } else {
        productos = tienda.buscarProductosPorCategoria(categoria);
    }
    
    if (productos.length === 0) {
        productosContainer.innerHTML = `
            <div class="col-12 text-center py-5">
                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                <h4 class="text-muted">No hay productos en esta categoría</h4>
                <p class="text-muted">Próximamente agregaremos más productos</p>
                <a href="index.html" class="btn btn-primary">Volver al Inicio</a>
            </div>
        `;
        return;
    }
    
    let html = '';
    productos.forEach(producto => {
        html += `
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card h-100 producto-card">
                    <img src="${producto.imagen}" class="card-img-top" alt="${producto.nombre}" style="height: 250px; object-fit: cover;">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title">${producto.nombre}</h5>
                        <p class="card-text flex-grow-1">${producto.descripcion}</p>
                        <div class="mt-auto">
                            <p class="fw-bold text-primary">$${producto.precio.toLocaleString()}</p>
                            <button class="btn btn-outline-dark w-100 btn-agregar-carrito" data-id="${producto.idProducto}">
                                <i class="fas fa-cart-plus me-2"></i>Agregar al Carrito
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
    });
    
    productosContainer.innerHTML = html;
    
    // Agregar event listeners a los botones
    document.querySelectorAll('.btn-agregar-carrito').forEach(button => {
        button.addEventListener('click', function() {
            const idProducto = parseInt(this.getAttribute('data-id'));
            const producto = tienda.buscarProductoPorId(idProducto);
            
            if (producto) {
                tienda.carritoGlobal.agregarProducto(producto, 1);
                actualizarBadgeCarrito();
                mostrarMensaje('✅ Producto agregado al carrito', 'success');
            }
        });
    });
}