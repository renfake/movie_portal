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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131020112931) do

  create_table "ages", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "broadcasts", :force => true do |t|
    t.integer  "week",                                                             :null => false
    t.date     "date",                                                             :null => false
    t.time     "start_time",                                                       :null => false
    t.integer  "movie_id",                                                         :null => false
    t.decimal  "audience_rating", :precision => 5, :scale => 2,                    :null => false
    t.decimal  "audience_share",  :precision => 5, :scale => 2,                    :null => false
    t.integer  "audience_number",                                                  :null => false
    t.integer  "time_bucket"
    t.boolean  "premiere",                                      :default => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "characters", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "movie_id"
    t.text     "biography"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "colors", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "formats", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "genres", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "issues", :force => true do |t|
    t.string   "name",       :null => false
    t.text     "desc"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "movies", :force => true do |t|
    t.string   "name",                                  :null => false
    t.string   "country"
    t.date     "production_date"
    t.integer  "category_id"
    t.string   "auditing_file"
    t.integer  "age_id"
    t.text     "age_note"
    t.integer  "runtime"
    t.integer  "color_id"
    t.integer  "format_id"
    t.integer  "picture_id"
    t.text     "plot_summary"
    t.text     "director_statement"
    t.text     "note"
    t.boolean  "first_run",          :default => false
    t.string   "external_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "movies_companies", :id => false, :force => true do |t|
    t.integer "movie_id",   :null => false
    t.integer "company_id", :null => false
    t.integer "duty",       :null => false
  end

  create_table "movies_genres", :id => false, :force => true do |t|
    t.integer "movie_id", :null => false
    t.integer "genre_id", :null => false
  end

  create_table "movies_issues", :id => false, :force => true do |t|
    t.integer "movie_id", :null => false
    t.integer "issue_id", :null => false
  end

  create_table "movies_people", :id => false, :force => true do |t|
    t.integer "movie_id",           :null => false
    t.integer "person_id",          :null => false
    t.string  "profession",         :null => false
    t.string  "profession_content"
  end

  create_table "people", :force => true do |t|
    t.string   "name",       :null => false
    t.date     "birthday"
    t.text     "bio"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "people_professions", :id => false, :force => true do |t|
    t.integer "person_id",     :null => false
    t.integer "profession_id", :null => false
  end

  create_table "professions", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "scores", :force => true do |t|
    t.integer "parent_id"
    t.string  "item_name",                  :null => false
    t.integer "min_score",   :default => 1, :null => false
    t.integer "max_score",   :default => 5, :null => false
    t.integer "step",        :default => 1, :null => false
    t.string  "description"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_movie_scores", :force => true do |t|
    t.integer "user_id"
    t.integer "movie_id"
    t.integer "score_id"
    t.decimal "mark",     :precision => 10, :scale => 0, :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                                   :null => false
    t.string   "role",                                   :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
