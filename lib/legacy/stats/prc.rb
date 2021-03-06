module Legacy
  module Stats
    module Prc

      unloadable

      def self.included(base)
        base.class_eval do
          belongs_to :campus, :class_name => 'Campus', :foreign_key => _(:id, :campus)
          belongs_to :prcMethod, :class_name => 'Prcmethod', :primary_key => _(:id, :prcmethod), :foreign_key => _(:id, :prcmethod)
          belongs_to :semester, :class_name => 'Semester', :primary_key => _(:id, :semester), :foreign_key => _(:id, :semester)

          validates_presence_of :prc_date, :prc_firstName, :prc_witnessName, :prc_notes
          #validates_date :date
        end

        base.extend PrcClassMethods
      end

      def human_integrated_believer()
        self.integrated_believer == 1 ? 'yes' : 'no'
      end

      module PrcClassMethods

        # This method will return the amount of indicated decisions that occurred between a given start and end date in a given ministry
        def count_by_date_per_ministry(start_date,end_date,ministry_id)
          campus_ids = Ministry.find(ministry_id).unique_campuses.collect {|c| c.id}
          result = self.count(:all, :joins => :campus, :conditions => ["#{__(:campus_id, :campus)} IN (?) AND #{_(:date)} <= ? AND #{_(:date)} > ?",campus_ids,end_date,start_date])
          result
        end


        # This method will return the amount of indicated decisions that occurred between a given start and end date in a given region
        def count_by_date(start_date,end_date,region_id)
          # national team stats are not included, so if the region_id is the national_region then it means total all other regions
          if region_id == national_region
            result = self.count(:all, :joins => :campus, :conditions => ["#{_(:region_id, :campus)} != ? AND #{_(:date)} <= ? AND #{_(:date)} > ?",region_id,end_date,start_date])
          else # else just find the stats associated with the given region
            result = self.count(:all, :joins => :campus, :conditions => ["#{_(:region_id, :campus)} = ? AND #{_(:date)} <= ? AND #{_(:date)} > ?",region_id,end_date,start_date])
          end
          result
        end

        # This method will return the amount of indicated decisions that occurred between a given start and end date associated with a given campus id
        def count_by_campus(start_date,end_date,campus_id)
          count(:all, :conditions => ["#{_(:campus_id)} = ? AND #{_(:date)} <= ? AND #{_(:date)} > ?",campus_id,end_date,start_date])
        end

        # This method will return the amount of indicated decisions that occurred during a given semester id and in a given region
        def count_by_semester(semester_id,region_id)
          # national team stats are not included, so if the region_id is the national_region then it means total all other regions
          if region_id == national_region
            result = self.count(:all, :joins => :campus, :conditions => ["#{_(:region_id, :campus)} != ? AND #{_(:semester_id)} = ?",region_id,semester_id])
          else # else just find the stats associated with a given region
            result = self.count(:all, :joins => :campus, :conditions => ["#{_(:region_id, :campus)} = ? AND #{_(:semester_id)} = ?",region_id,semester_id])
          end
          result
        end

        # This method will return the amount of indicated decisions during a given semester and associated with a given ministry id
        def count_by_semester_and_ministry(semester_id,ministry_id)
          campus_ids = Ministry.find(ministry_id).unique_campuses.collect {|c| c.id}
          count(:all, :joins => :campus, :conditions => ["#{__(:id, :campus)} IN (?) AND #{_(:semester_id)} = ?",campus_ids,semester_id])
        end

        def count_by_semester_and_campuses(semester_id,campuses)
          campus_ids = campuses.collect {|c| c.id}
          count(:all, :joins => :campus, :conditions => ["#{__(:id, :campus)} IN (?) AND #{_(:semester_id)} = ?",campus_ids,semester_id])
        end

        # This method will return the amount of indicated decisions during a given semester and associated with a given campus id
        def count_by_semester_and_campus(semester_id,campus_id)
          count(:all, :joins => :campus, :conditions => ["#{__(:id, :campus)} = ? AND #{_(:semester_id)} = ?",campus_id,semester_id])
        end

        # This method will insert a new indicated decision
        def submit_decision(semesterID, campusID, methodID, date, notes, name, witness, believer)
          create(_(:semester_id) => semesterID, _(:campus_id) => campusID, _(:method_id) => methodID, _(:date) => date, _(:notes) => notes, _(:first_name) => name, _(:witness_name) => witness, _(:integrated_believer) => believer)
        end

        # This method will update a given indicated decision
        def update_decision(id,semesterID, campusID, methodID, date, notes, name, witness, believer)
          update(id,_(:semester_id) => semesterID, _(:campus_id) => campusID, _(:method_id) => methodID, _(:date) => date, _(:notes) => notes, _(:first_name) => name, _(:witness_name) => witness, _(:integrated_believer) => believer)
        end

        # This method will return all the indicated decisions associated with a semester and campus
        def find_by_semester_and_campus(semester_id,campus_id)
          find(:all, :joins => :campus, :conditions => ["#{__(:id, :campus)} = ? AND #{_(:semester_id)} = ?",campus_id,semester_id])
        end

        # This method will return the indicated decision associated with the given id
        def find_by_id(id)
          find(:first, :conditions => {_(:id) => id})
        end

        # This method will delete the indicated decision associated with the given id
        def delete_by_id(id)
          delete(id)
        end
      end

    end
  end
end
