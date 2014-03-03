class Game < ActiveRecord::Base
    attr_accessible :barcode, :checked_in, :loaner_id, :section_id, :title_id, :active, :culled
    belongs_to :title
    belongs_to :section

    has_many :checkouts
    has_many :notes

    validate :barcode, length: { maximum: 9 }
    validates_format_of :barcode, :with => /^[a-z]{3}\d{3,4}[a-z0-9]{2}$/i #also in application_controller.rb!
    #validates :barcode, presence: true
    validates_existence_of :title, :both => false #uncomment after resolving title ids
    validates_existence_of :section, :both => false

    #validates_uniqueness_of :barcode
    
    def name
      self.title.title + ' [' + self.title.publisher.name + ']'
    end
    
    def title_name
      self.title.title
    end
    
    def publisher_name
      self.title.publisher.name
    end
    
end
