# Punto Frío donde Beto 🍺

Sistema de gestión de ventas e inventario para punto frío, desarrollado con Astro, Tailwind CSS y Supabase.

## ✨ Características

- **Dashboard Completo**: Visualización de métricas clave del negocio
- **Gestión de Inventario**: Control de stock, precios y categorías
- **Sistema de Ventas**: Registro y seguimiento de transacciones
- **Reportes Detallados**: Análisis de ventas y productos más vendidos
- **Diseño Responsive**: Optimizado para móvil y desktop
- **Autenticación**: Sistema de usuarios con roles (admin/vendedor)

## 🚀 Tecnologías

- **Frontend**: Astro + Tailwind CSS
- **Backend**: Supabase (PostgreSQL)
- **Auth**: Supabase Auth
- **Deployment**: Compatible con Vercel, Netlify, etc.

## 📦 Instalación

1. **Clona el repositorio**:
   ```bash
   git clone [repository-url]
   cd punto-frio-beto
   ```

2. **Instala dependencias**:
   ```bash
   npm install
   ```

3. **Configura Supabase**:
   - Ve a [supabase.com](https://supabase.com) y crea un nuevo proyecto
   - Copia `.env.example` a `.env`
   - Agrega tus credenciales de Supabase al archivo `.env`

4. **Ejecuta las migraciones**:
   - Ve a tu dashboard de Supabase
   - En SQL Editor, ejecuta el contenido de `supabase/migrations/create_initial_schema.sql`

5. **Inicia el servidor de desarrollo**:
   ```bash
   npm run dev
   ```

## 🗃️ Estructura de la Base de Datos

### Tablas Principales

- **`productos`**: Inventario de productos con stock, precios y categorías
- **`ventas`**: Registro de todas las transacciones
- **`usuarios`**: Perfiles de usuario con roles y permisos

### Relaciones

- `ventas.producto_id` → `productos.id`
- `ventas.usuario_id` → `usuarios.id`
- `usuarios.id` → `auth.users.id` (Supabase Auth)

## 🎨 Diseño

El sistema utiliza una paleta de colores inspirada en las marcas Bavaria/Águila:

- **Amarillo**: `#FFD700` - Acciones principales
- **Rojo**: `#DC2626` - Alertas y eliminaciones  
- **Negro**: `#1F2937` - Navegación y texto principal
- **Blanco/Gris**: Fondos y elementos secundarios

## 🔐 Autenticación y Roles

### Roles de Usuario

- **Admin**: Acceso completo al sistema
  - Gestionar inventario (crear, editar, eliminar productos)
  - Ver todos los reportes
  - Gestionar usuarios

- **Vendedor**: Acceso limitado
  - Registrar ventas
  - Ver inventario (solo lectura)
  - Ver reportes básicos

### Configuración de Auth

El sistema usa Supabase Auth con email/password. Para configurar:

1. En tu dashboard de Supabase, ve a Authentication
2. Configura los providers que necesites
3. Los usuarios se crean automáticamente en la tabla `usuarios` mediante triggers

## 📱 Funcionalidades

### Dashboard
- Métricas en tiempo real
- Productos más vendidos
- Ventas recientes
- Acciones rápidas

### Inventario
- Lista de productos con filtros
- Indicadores de stock crítico
- Modal para agregar/editar productos
- Categorización por tipo de producto

### Ventas
- Registro de nuevas ventas
- Historial de transacciones
- Filtros por fecha y producto
- Resumen diario de ventas

### Reportes
- Análisis de ventas por período
- Ranking de productos
- Gráficos de rendimiento
- Exportación a PDF/Excel

## 🚀 Deployment

### Vercel
```bash
npm run build
vercel --prod
```

### Netlify
```bash
npm run build
# Sube la carpeta dist/ a Netlify
```

### Variables de Entorno en Producción

Asegúrate de configurar estas variables en tu plataforma de deployment:

- `PUBLIC_SUPABASE_URL`
- `PUBLIC_SUPABASE_ANON_KEY`

## 🛠️ Scripts Disponibles

- `npm run dev` - Inicia servidor de desarrollo
- `npm run build` - Construye la aplicación para producción
- `npm run preview` - Previsualiza la build de producción

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más información.

## 📞 Soporte

Si tienes preguntas o necesitas ayuda:

- 📧 Email: [tu-email@ejemplo.com]
- 🐛 Issues: [GitHub Issues]
- 📚 Docs: [Documentación del proyecto]

---

**¡Gracias por usar Punto Frío donde Beto! 🍻**