module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug
    class_attribute :slug_column
  end

  def to_param
    self.slug
  end

  def generate_slug
    the_slug = to_slug(self.send(self.class.slug_column.to_sym))
    post = self.class.find_by slug: the_slug # look if post by the same slug already exists
    count = 2
    while post && post != self
      the_slug = append_suffix(the_slug, count)
      post = self.class.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug
  end

  def to_slug(name)
    str = name.strip
    str.gsub! /\s*[^A-Za-z0-9]\s*/, '-' # replaces everything other than alphanumerical characters with a dash
    str.gsub! /-+/, "-" # if multiple dashes in a row, reduces it to 1
    str.downcase
  end

  def append_suffix(str, count)
    if str.split('-').last.to_i != 0 # if the last element is an integer
      return str.split('-').slice(0...-1).join('-') + '-' + count.to_s
    else
      return str + '-' + count.to_s
    end
  end


  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end

end