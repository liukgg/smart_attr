ActiveRecord::Schema.define do
  self.verbose = false

  create_table :songs, force: true do |t|
    t.string    :title,    null: false,    default: ''
    t.integer   :star,     null: false,    default: 0   # 几星推荐
  end
end
