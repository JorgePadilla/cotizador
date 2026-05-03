class CreateCaiAuthorizations < ActiveRecord::Migration[8.0]
  def change
    create_table :cai_authorizations do |t|
      t.references :emission_point, null: false, foreign_key: true
      t.references :document_type, null: false, foreign_key: true
      t.string :cai, null: false, limit: 49
      t.bigint :rango_inicial, null: false
      t.bigint :rango_final, null: false
      t.bigint :correlativo_actual, null: false, default: 0
      t.date :fecha_limite_emision, null: false
      t.date :fecha_resolucion
      t.string :numero_resolucion
      t.boolean :active, null: false, default: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :cai_authorizations,
              [:emission_point_id, :document_type_id, :cai],
              unique: true,
              name: "index_cai_auths_on_ep_dt_cai"

    add_index :cai_authorizations,
              [:emission_point_id, :document_type_id],
              unique: true,
              where: "active = true",
              name: "index_cai_auths_active_per_ep_dt"

    execute <<~SQL
      ALTER TABLE cai_authorizations
        ADD CONSTRAINT cai_rango_final_gte_inicial
          CHECK (rango_final >= rango_inicial),
        ADD CONSTRAINT cai_correlativo_actual_within_range
          CHECK (correlativo_actual >= rango_inicial - 1 AND correlativo_actual <= rango_final);
    SQL
  end
end
