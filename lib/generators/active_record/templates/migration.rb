class DeviseGoogleAuthenticatorAddTo<%= table_name.camelize %> < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :gauth_tmp
      t.string :gauth_secret
      t.boolean :gauth_enabled, default: false
      t.boolean :gauth_has_been_reset, default: false
      t.boolean :google_auth_app_set_up, default: false
      t.datetime :gauth_tmp_datetime
      t.datetime :remember_gauth_token_set_at
      t.datetime :remember_gauth_token_expires_at
    end
  end
end
