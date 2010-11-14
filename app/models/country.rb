class Country < ActiveRecord::Base
  has_many :metro_areas
  has_many :states
  has_many :subregions
  has_many :regions

  named_scope :released, { :conditions => { :released => true }, :order => 'countries.name ASC' }
  
  def self.get(name)
    case name
      when :us
        c = 'United States'
    end
    self.find_by_name(c)
  end
  
  def self.find_countries_with_metros
    MetroArea.find(:all, :include => :country).collect{ |m| m.country }.sort_by{ |c| c.name }.uniq
  end

  def states
    State.find(:all, :include => :metro_areas, :conditions => ["metro_areas.id in (?)", metro_area_ids ]).uniq
  end

  def metro_area_ids
    metro_areas.map{|m| m.id }
  end

  def self.find_countries_with_subregions
    Subregion.find(:all, :include => :country).collect{ |m| m.country }.sort_by{ |c| c.name }.uniq
  end
  
  def regions
    Region.find(:all, :include => :subregions, :conditions => ["subregions.id in (?)", subregion_ids ]).uniq
  end
  
  def subregion_ids
    subregions.map{|m| m.id }
  end
end
