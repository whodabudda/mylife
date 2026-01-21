
#require_dependency('')
#require_dependency('DataPrereq')
class ReviewStats 
    attr_accessor :review, :stat_classes
    def initialize(review,conn) 
        @review = review
        @conn = conn
        @stat_classes = []
        @active_class
    end
    def active_class
        return @active_class
    end
    def perform_analysis(testname = nil)
         #
         #any new class that produces its own HighCharts chart must me listed here
         #and must implement the checkAssumptions and perform_analysis methods
         #
         #cls_list = [StatStdRegression,StatAvgRegression,StatDistanceRegression,StatCountBargraph]
         cls_list = [StatStdRegression,StatAvgRegression,StatDistanceRegression,StatCountBargraph,StatLogitRegression]
         @ss = StatSample.new(review,@conn)
         @ss.runAssumptions  #populates the y_profile and x_profile hashes
         cls_list.each do |cls|
            c = cls.new(review,@ss)
            if c.checkAssumptions
               stat_classes.push (cls)
            else
               Rails.logger.info "#{self.class.name}:#{__method__} checkAssumptions failed for #{c.class.name}"
            end
         end
         Rails.logger.info "#{self.class.name}:#{__method__} @stat_classes are #{stat_classes} " unless @stat_classes.empty?
         #perform the first test from the first entry in the hash if we didn't have a 
         #testname passed in.
         if testname.nil?
            @active_class = stat_classes.first.new(review,@ss) unless stat_classes.empty?
         else
            @active_class = testname.constantize.new(review,@ss)
         end
         #debugger 
         #using the safe-navigation operator (&) so we don't throw an error if active_class is nil
         @active_class&.perform_analysis
         @active_class&.add_return_message(@active_class.class.name,@active_class.who_am_i)
         if  @active_class.nil? 
            @active_class =  StatBase.new(@review,@ss)
         end
         Rails.logger.info "#{self.class.name}:#{__method__} @active_class is #{@active_class&.class.name} " unless @active_class.nil?
    end
end
