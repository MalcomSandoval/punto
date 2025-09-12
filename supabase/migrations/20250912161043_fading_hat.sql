/*
  # Schema inicial para Punto Frío donde Beto

  1. New Tables
    - `productos`
      - `id` (uuid, primary key)
      - `nombre` (text, unique)
      - `stock` (integer)
      - `precio` (numeric)
      - `categoria` (text)
      - `creado_en` (timestamp)

    - `ventas`
      - `id` (uuid, primary key)
      - `producto_id` (uuid, foreign key)
      - `cantidad` (integer)
      - `total` (numeric)
      - `fecha` (timestamp)
      - `usuario_id` (uuid, foreign key)

    - `usuarios`
      - `id` (uuid, primary key)
      - `nombre` (text)
      - `email` (text, unique)
      - `rol` (text)
      - `creado_en` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users based on roles
    - Users can read/write based on their role permissions

  3. Relations
    - ventas.producto_id → productos.id
    - ventas.usuario_id → usuarios.id (references auth.users.id)
*/

-- Create productos table
CREATE TABLE IF NOT EXISTS productos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre text UNIQUE NOT NULL,
  stock integer NOT NULL DEFAULT 0,
  precio numeric(10,2) NOT NULL DEFAULT 0,
  categoria text NOT NULL DEFAULT 'general',
  creado_en timestamptz DEFAULT now()
);

-- Create usuarios table
CREATE TABLE IF NOT EXISTS usuarios (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  nombre text NOT NULL DEFAULT 'Usuario',
  email text UNIQUE NOT NULL,
  rol text NOT NULL DEFAULT 'vendedor',
  creado_en timestamptz DEFAULT now()
);

-- Create ventas table
CREATE TABLE IF NOT EXISTS ventas (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  producto_id uuid NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
  cantidad integer NOT NULL DEFAULT 1,
  total numeric(10,2) NOT NULL DEFAULT 0,
  fecha timestamptz DEFAULT now(),
  usuario_id uuid REFERENCES usuarios(id) ON DELETE SET NULL
);

-- Enable Row Level Security
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE ventas ENABLE ROW LEVEL SECURITY;

-- Create policies for productos
CREATE POLICY "Users can read all productos"
  ON productos
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Only admins can insert productos"
  ON productos
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM usuarios 
      WHERE usuarios.id = auth.uid() 
      AND usuarios.rol = 'admin'
    )
  );

CREATE POLICY "Only admins can update productos"
  ON productos
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM usuarios 
      WHERE usuarios.id = auth.uid() 
      AND usuarios.rol = 'admin'
    )
  );

CREATE POLICY "Only admins can delete productos"
  ON productos
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM usuarios 
      WHERE usuarios.id = auth.uid() 
      AND usuarios.rol = 'admin'
    )
  );

-- Create policies for usuarios
CREATE POLICY "Users can read own data"
  ON usuarios
  FOR SELECT
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "Users can update own data"
  ON usuarios
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid());

CREATE POLICY "New users can insert their profile"
  ON usuarios
  FOR INSERT
  TO authenticated
  WITH CHECK (id = auth.uid());

-- Create policies for ventas
CREATE POLICY "Users can read all ventas"
  ON ventas
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert ventas"
  ON ventas
  FOR INSERT
  TO authenticated
  WITH CHECK (
    usuario_id = auth.uid() OR usuario_id IS NULL
  );

-- Insert sample data
INSERT INTO productos (nombre, stock, precio, categoria) VALUES
  ('Cerveza Águila', 45, 3000, 'bebidas alcohólicas'),
  ('Gaseosa Coca-Cola', 32, 2000, 'gaseosas'),
  ('Agua en Botella', 8, 1000, 'bebidas'),
  ('Jugo Hit', 15, 2500, 'jugos'),
  ('Cerveza Corona', 22, 3500, 'bebidas alcohólicas'),
  ('Ron Medellín', 3, 45000, 'licores')
ON CONFLICT (nombre) DO NOTHING;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_productos_categoria ON productos(categoria);
CREATE INDEX IF NOT EXISTS idx_productos_stock ON productos(stock);
CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas(fecha);
CREATE INDEX IF NOT EXISTS idx_ventas_producto_id ON ventas(producto_id);
CREATE INDEX IF NOT EXISTS idx_ventas_usuario_id ON ventas(usuario_id);