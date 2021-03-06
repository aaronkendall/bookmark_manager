require 'data_mapper'
require 'dm-postgres-adapter'

class Link
  include DataMapper::Resource

  property :link_id,     Serial
  property :url,         String
  property :title,       String
  has n, :tags, through: Resource

end
