module UberS3::Operation::Object
  module Tagging
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, InstanceMethods
      
      base.instance_eval do
        attr_accessor :tagging
      end
    end

    module ClassMethods
    end
    
    module InstanceMethods
      def tagging=(tags)
        if tags.is_a?(Hash)
          @tagging = tags
        else
          raise ArgumentError.new("Tags must be provided as a Hash")
        end
      end
    end
    
  end
end
