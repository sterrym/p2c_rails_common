module Common
  module Core
    module Campus
      def self.included(base)
        base.class_eval do
          set_inheritance_column "asdf"
          
          has_many :campus_involvements
          has_many :people, :through => :campus_involvements
          has_many :groups
          # has_many :bible_studies
          has_many :ministry_campuses, :include => :ministry
          has_many :ministries, :through => :ministry_campuses, :order => ::Ministry.table_name+'.'+_(:name, :ministry)
          has_many :events, :through => :event_campuses
          has_many :event_campuses, :include => :event
          has_many :dorms
        end
      end

      # returns <abbrev> the abbreviated name of campus if it exists, 
      # otherwise <name> the fullname
      def short_name
        self.abbrv.to_s.empty? ? self.name : self.abbrv
      end

      # Comperable - allows campuses to be compared based on their names
      def <=>(other)
        name <=> other.name
      end

      #liquid_methods
      def to_liquid
        { "name" => name }
      end

      def derive_ministry
        # look for the latest MC, under the assumption it will be the most nested        
        # if staff start wanting to have staff-only groups with campuses, we'll have to
        # rethink this
        ministry_campus = ::MinistryCampus.find :last, :conditions => { :campus_id => self.id }
        ministry_campus.try(:ministry)
      end
    end
  end
end
