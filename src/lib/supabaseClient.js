import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL || ''
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY || ''

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Funciones auxiliares para la gestión de datos
export const productosService = {
  async getAll() {
    const { data, error } = await supabase
      .from('productos')
      .select('*')
      .order('nombre')
    
    if (error) throw error
    return data
  },

  async create(producto) {
    const { data, error } = await supabase
      .from('productos')
      .insert([producto])
      .select()
    
    if (error) throw error
    return data[0]
  },

  async update(id, updates) {
    const { data, error } = await supabase
      .from('productos')
      .update(updates)
      .eq('id', id)
      .select()
    
    if (error) throw error
    return data[0]
  },

  async delete(id) {
    const { error } = await supabase
      .from('productos')
      .delete()
      .eq('id', id)
    
    if (error) throw error
  }
}

export const ventasService = {
  async getAll() {
    const { data, error } = await supabase
      .from('ventas')
      .select(`
        *,
        productos (
          nombre,
          precio
        )
      `)
      .order('fecha', { ascending: false })
    
    if (error) throw error
    return data
  },

  async create(venta) {
    const { data, error } = await supabase
      .from('ventas')
      .insert([venta])
      .select(`
        *,
        productos (
          nombre,
          precio
        )
      `)
    
    if (error) throw error
    return data[0]
  },

  async getResumen() {
    const { data: ventas, error: errorVentas } = await supabase
      .from('ventas')
      .select('total')
    
    const { data: productos, error: errorProductos } = await supabase
      .from('productos')
      .select('stock')
    
    if (errorVentas || errorProductos) throw errorVentas || errorProductos
    
    const totalVentas = ventas?.reduce((sum, venta) => sum + venta.total, 0) || 0
    const totalStock = productos?.reduce((sum, producto) => sum + producto.stock, 0) || 0
    const productosEnStock = productos?.filter(p => p.stock > 0).length || 0
    
    return {
      totalVentas,
      totalStock,
      productosEnStock,
      totalProductos: productos?.length || 0
    }
  }
}