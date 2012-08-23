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

ActiveRecord::Schema.define(:version => 20120823004010) do

  create_table "early_vote_sites", :force => true do |t|
    t.string   "site_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.integer  "precinct_number"
    t.string   "county"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "gmaps"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "gotv_t1_count",   :default => 0
    t.integer  "gotv_t2_count",   :default => 0
    t.integer  "gotv_t3_count",   :default => 0
    t.integer  "gotv_supp_count", :default => 0
  end

# Could not dump table "nv_gis_shapefiles" because of following StandardError
#   Unknown type 'geometry(MultiPolygon,3421)' for column 'geom'

  create_table "organizers", :force => true do |t|
    t.integer  "region_id"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "polling_places", :force => true do |t|
    t.string   "site_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.integer  "precinct_number"
    t.string   "county"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "gmaps"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "precinct_scores", :force => true do |t|
    t.integer  "precinct_number"
    t.integer  "van_precinct_id"
    t.integer  "score"
    t.integer  "total_vap"
    t.float    "afam_pct"
    t.float    "hisp_pct"
    t.float    "other_pct"
    t.float    "w_f_youth_pct"
    t.float    "w_m_youth_pct"
    t.float    "w_older_pct"
    t.integer  "est_afam_unreg"
    t.integer  "est_hisp_unreg"
    t.integer  "est_other_unreg"
    t.integer  "est_w_f_youth_unreg"
    t.integer  "est_w_m_youth_unreg"
    t.integer  "est_w_older_unreg"
    t.integer  "est_unreg"
    t.float    "est_unreg_rate"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "county"
  end

  create_table "precincts", :force => true do |t|
    t.integer  "precinct_number"
    t.integer  "team_id"
    t.string   "county"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "van_precinct_id"
    t.string   "state"
    t.integer  "polling_place_id"
  end

  create_table "regions", :force => true do |t|
    t.string   "state"
    t.string   "region_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "site_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.integer  "precinct_number"
    t.integer  "organization_id"
    t.string   "county"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "gmaps"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "spatial_ref_sys", :id => false, :force => true do |t|
    t.integer "srid",                      :null => false
    t.string  "auth_name", :limit => 256
    t.integer "auth_srid"
    t.string  "srtext",    :limit => 2048
    t.string  "proj4text", :limit => 2048
  end

  create_table "teams", :force => true do |t|
    t.integer  "organizer_id"
    t.string   "team_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "voters", :force => true do |t|
    t.string   "state_code"
    t.integer  "van_id"
    t.float    "lat"
    t.float    "lng"
    t.string   "gotv_tier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
