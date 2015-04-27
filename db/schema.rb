# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150426191400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clientes", force: :cascade do |t|
    t.string   "nombre",           limit: 50, null: false
    t.string   "telefono",         limit: 10, null: false
    t.string   "direccion_fiscal", limit: 50, null: false
    t.string   "rfc",              limit: 13, null: false
    t.integer  "vendedor_id",                 null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "ordenes", force: :cascade do |t|
    t.date     "fecha_entrega"
    t.integer  "tienda_cliente_id", null: false
    t.integer  "repartidor_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "proveedores", force: :cascade do |t|
    t.string   "nombre",     null: false
    t.string   "telefono",   null: false
    t.string   "direccion",  null: false
    t.string   "rfc",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relojes", force: :cascade do |t|
    t.string   "marca",        limit: 25,                                     null: false
    t.string   "modelo",       limit: 25,                                     null: false
    t.text     "descripcion",                                                 null: false
    t.decimal  "precio",                  precision: 8, scale: 2,             null: false
    t.integer  "proveedor_id",                                                null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "stock",                                           default: 0
  end

  create_table "repartidores", force: :cascade do |t|
    t.string   "nombre",     limit: 50, null: false
    t.string   "rfc",        limit: 13, null: false
    t.string   "telefono",   limit: 10, null: false
    t.string   "direccion",  limit: 50, null: false
    t.integer  "user_id",               null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "tiendas_clientes", force: :cascade do |t|
    t.string   "nombre",     limit: 50, null: false
    t.string   "direccion",  limit: 50, null: false
    t.string   "telefono",   limit: 10, null: false
    t.integer  "cliente_id",            null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "is_admin",               default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vendedores", force: :cascade do |t|
    t.string   "nombre",     limit: 50, null: false
    t.string   "telefono",   limit: 10, null: false
    t.string   "rfc",        limit: 13, null: false
    t.integer  "user_id",               null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_foreign_key "clientes", "vendedores", name: "fk_clientes_vendedores"
  add_foreign_key "ordenes", "repartidores", name: "fk_ordenes_repartidores"
  add_foreign_key "ordenes", "tiendas_clientes", name: "fk_ordenes_tiendas"
  add_foreign_key "relojes", "proveedores", name: "fk_relojes_proveedores"
  add_foreign_key "repartidores", "users", name: "fk_repartidores_users"
  add_foreign_key "tiendas_clientes", "clientes", name: "fk_tiendas_clientes"
  add_foreign_key "vendedores", "users", name: "fk_vendedores_usuarios"
end
