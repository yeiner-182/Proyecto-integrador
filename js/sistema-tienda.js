// Clase base Producto
class Producto {
    constructor(idProducto, nombre, descripcion, precio, stock, categoria, imagen) {
        this.idProducto = idProducto;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precio = precio;
        this.stock = stock;
        this.categoria = categoria;
        this.imagen = imagen;
    }

    mostrarInfo() {
        return `${this.nombre} - $${this.precio}`;
    }

    actualizarStock(cantidad) {
        this.stock -= cantidad;
    }
}

// Clases heredadas
class Ropa extends Producto {
    constructor(idProducto, nombre, descripcion, precio, stock, categoria, imagen, talla, color, material) {
        super(idProducto, nombre, descripcion, precio, stock, categoria, imagen);
        this.talla = talla;
        this.color = color;
        this.material = material;
    }

    mostrarInfo() {
        return `${this.nombre} - Talla: ${this.talla} - Color: ${this.color} - $${this.precio}`;
    }
}

class Accesorio extends Producto {
    constructor(idProducto, nombre, descripcion, precio, stock, categoria, imagen, tipoAccesorio, material) {
        super(idProducto, nombre, descripcion, precio, stock, categoria, imagen);
        this.tipoAccesorio = tipoAccesorio;
        this.material = material;
    }

    mostrarInfo() {
        return `${this.nombre} - ${this.tipoAccesorio} - $${this.precio}`;
    }
}

// Clase Cliente
class Cliente {
    constructor(nombre, correo, direccionEnvio, usuario, contraseña) {
        this.nombre = nombre;
        this.correo = correo;
        this.direccionEnvio = direccionEnvio;
        this.usuario = usuario;
        this.contraseña = contraseña;
        this.carrito = new CarritoCompra();
        this.intentosLogin = 0;
        this.bloqueado = false;
    }

    iniciarSesion(usuario, contraseña) {
        if (this.bloqueado) {
            return { exito: false, mensaje: "Cuenta bloqueada. Contacte al administrador." };
        }

        if (this.usuario === usuario && this.contraseña === contraseña) {
            this.intentosLogin = 0;
            return { exito: true, mensaje: "Inicio de sesión exitoso" };
        } else {
            this.intentosLogin++;
            if (this.intentosLogin >= 3) {
                this.bloqueado = true;
                return { exito: false, mensaje: "Cuenta bloqueada por múltiples intentos fallidos" };
            }
            return { exito: false, mensaje: "Credenciales incorrectas" };
        }
    }
}

// Clase CarritoCompra
class CarritoCompra {
    constructor() {
        this.listaProductos = [];
        this.total = 0;
    }

    agregarProducto(producto, cantidad = 1) {
        const productoExistente = this.listaProductos.find(p => p.producto.idProducto === producto.idProducto);
        
        if (productoExistente) {
            productoExistente.cantidad += cantidad;
        } else {
            this.listaProductos.push({ producto, cantidad });
        }
        
        this.calcularTotal();
        this.guardarEnLocalStorage();
        return "Producto agregado al carrito";
    }

    eliminarProducto(idProducto) {
        this.listaProductos = this.listaProductos.filter(p => p.producto.idProducto !== idProducto);
        this.calcularTotal();
        this.guardarEnLocalStorage();
        return "Producto eliminado del carrito";
    }

    actualizarCantidad(idProducto, nuevaCantidad) {
        const producto = this.listaProductos.find(p => p.producto.idProducto === idProducto);
        if (producto) {
            producto.cantidad = nuevaCantidad;
            this.calcularTotal();
            this.guardarEnLocalStorage();
            return "Cantidad actualizada";
        }
        return "Producto no encontrado en el carrito";
    }

    calcularTotal() {
        this.total = this.listaProductos.reduce((sum, item) => {
            return sum + (item.producto.precio * item.cantidad);
        }, 0);
        return this.total;
    }

    vaciarCarrito() {
        this.listaProductos = [];
        this.total = 0;
        this.guardarEnLocalStorage();
    }

    guardarEnLocalStorage() {
        const carritoData = {
            listaProductos: this.listaProductos.map(item => ({
                producto: {
                    idProducto: item.producto.idProducto,
                    nombre: item.producto.nombre,
                    precio: item.producto.precio,
                    imagen: item.producto.imagen
                },
                cantidad: item.cantidad
            })),
            total: this.total
        };
        localStorage.setItem('carritoCompra', JSON.stringify(carritoData));
    }

    cargarDesdeLocalStorage() {
        const carritoData = localStorage.getItem('carritoCompra');
        if (carritoData) {
            const parsedData = JSON.parse(carritoData);
            this.listaProductos = parsedData.listaProductos;
            this.total = parsedData.total;
        }
    }
}

// Clase Orden
class Orden {
    constructor(cliente, listaProductos, total) {
        this.numeroOrden = this.generarNumeroOrden();
        this.cliente = cliente;
        this.listaProductos = listaProductos;
        this.total = total;
        this.fecha = new Date();
        this.estado = "Pendiente";
    }

    generarNumeroOrden() {
        return 'ORD-' + Date.now();
    }

    mostrarResumen() {
        return {
            numeroOrden: this.numeroOrden,
            cliente: this.cliente.nombre,
            productos: this.listaProductos,
            total: this.total,
            fecha: this.fecha.toLocaleDateString(),
            estado: this.estado
        };
    }
}

// Sistema principal de la tienda
class SistemaTienda {
    constructor() {
        this.productos = [];
        this.clientes = [];
        this.ordenes = [];
        this.clienteActual = null;
        this.carritoGlobal = new CarritoCompra();
        this.inicializarDatos();
    }

    inicializarDatos() {
        // Cargar carrito desde localStorage
        this.carritoGlobal.cargarDesdeLocalStorage();
        
        // Datos de ejemplo para productos
        this.productos = [
            new Ropa(1, "Vestido Floral", "Hermoso vestido floral para ocasiones especiales", 139900, 10, "Vestidos", "imagenes/Vestido Floral.jpg", "M", "Multicolor", "Algodón"),
            new Ropa(2, "Jeans Slim Fit", "Jeans ajustados de última tendencia", 89900, 15, "Jeans", "imagenes/Jeans Slim Fit.jpg", "32", "Azul", "Denim"),
            new Ropa(3, "Blusa de Seda", "Elegante blusa de seda natural", 119900, 8, "Blusas", "imagenes/Blusa de Seda.jpg", "S", "Blanco", "Seda"),
            new Ropa(4, "Zapatos de Tacón", "Zapatos elegantes para complementar tu outfit", 149900, 12, "Zapatos", "imagenes/Zapatos.jpg", "38", "Negro", "Cuero"),
            new Ropa(5, "Camisa Casual", "Camisa cómoda para el día a día", 79900, 20, "Camisas", "imagenes/camisa1.jpg", "L", "Azul claro", "Algodón"),
            new Accesorio(6, "Collar Dorado", "Collar elegante para realzar tu look", 45900, 25, "Accesorios", "imagenes/accesorio1.jpg", "Collar", "Oro laminado"),
            new Ropa(7, "Falda Plisada", "Falda moderna con pliegues elegantes", 99900, 10, "Faldas", "imagenes/falda1.jpg", "S", "Negro", "Poliéster"),
            new Ropa(8, "Chaqueta Denim", "Chaqueta casual de mezclilla", 129900, 8, "Chaquetas", "imagenes/chaqueta1.jpg", "M", "Azul", "Denim"),
            new Ropa(9, "Top Veraniego", "Top fresco para días calurosos", 59900, 15, "Tops", "imagenes/top1.jpg", "S", "Blanco", "Algodón"),
            new Ropa(10, "Pantalón Formal", "Pantalón elegante para oficina", 159900, 6, "Pantalones", "imagenes/pantalon1.jpg", "30", "Negro", "Lino")
        ];

        // Cliente de ejemplo
        this.clientes.push(new Cliente("Ana García", "ana@ejemplo.com", "Calle 123, Medellín", "ana@ejemplo.com", "password123"));
        
        // Cargar cliente actual desde localStorage
        this.cargarClienteActual();
    }

    cargarClienteActual() {
        const clienteData = localStorage.getItem('clienteActual');
        if (clienteData) {
            const clienteInfo = JSON.parse(clienteData);
            const cliente = this.clientes.find(c => c.usuario === clienteInfo.usuario);
            if (cliente) {
                this.clienteActual = cliente;
            }
        }
    }

    guardarClienteActual() {
        if (this.clienteActual) {
            localStorage.setItem('clienteActual', JSON.stringify({
                usuario: this.clienteActual.usuario,
                nombre: this.clienteActual.nombre
            }));
        }
    }

    buscarProductosPorCategoria(categoria) {
        return this.productos.filter(producto => producto.categoria === categoria);
    }

    buscarProductoPorId(id) {
        return this.productos.find(producto => producto.idProducto === id);
    }

    registrarCliente(nombre, correo, direccion, usuario, contraseña) {
        const nuevoCliente = new Cliente(nombre, correo, direccion, usuario, contraseña);
        this.clientes.push(nuevoCliente);
        return { exito: true, mensaje: "Cliente registrado exitosamente" };
    }

    iniciarSesion(usuario, contraseña) {
        const cliente = this.clientes.find(c => c.usuario === usuario);
        if (cliente) {
            const resultado = cliente.iniciarSesion(usuario, contraseña);
            if (resultado.exito) {
                this.clienteActual = cliente;
                this.guardarClienteActual();
            }
            return resultado;
        }
        return { exito: false, mensaje: "Usuario no encontrado" };
    }

    cerrarSesion() {
        this.clienteActual = null;
        localStorage.removeItem('clienteActual');
    }

    generarOrden() {
        if (!this.clienteActual) {
            return { exito: false, mensaje: "Debe iniciar sesión para generar una orden" };
        }

        if (this.carritoGlobal.listaProductos.length === 0) {
            return { exito: false, mensaje: "El carrito está vacío" };
        }

        const orden = new Orden(this.clienteActual, this.carritoGlobal.listaProductos, this.carritoGlobal.total);
        this.ordenes.push(orden);
        
        // Vaciar carrito después de generar la orden
        this.carritoGlobal.vaciarCarrito();
        
        return { exito: true, orden: orden.mostrarResumen() };
    }
}

// Instancia global del sistema
const tienda = new SistemaTienda();