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

ActiveRecord::Schema.define(:version => 20130919034649) do

  create_table "comments", :force => true do |t|
    t.integer  "link_id",    :null => false
    t.integer  "user_id",    :null => false
    t.integer  "parent_id"
    t.text     "body",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["link_id"], :name => "index_comments_on_link_id"
  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "links", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "url",        :null => false
    t.integer  "user_id",    :null => false
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "links", ["title"], :name => "index_links_on_title"
  add_index "links", ["url"], :name => "index_links_on_url"
  add_index "links", ["user_id"], :name => "index_links_on_user_id"

  create_table "sub_links", :force => true do |t|
    t.integer  "link_id",    :null => false
    t.integer  "sub_id",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subs", :force => true do |t|
    t.integer  "moderator_id", :null => false
    t.string   "name",         :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "subs", ["moderator_id", "name"], :name => "index_subs_on_moderator_id_and_name", :unique => true
  add_index "subs", ["moderator_id"], :name => "index_subs_on_moderator_id"
  add_index "subs", ["name"], :name => "index_subs_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",           :null => false
    t.string   "password_digest", :null => false
    t.string   "token",           :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["password_digest"], :name => "index_users_on_password_digest"
  add_index "users", ["token"], :name => "index_users_on_token"

end
