require 'dynamoid'

module Dynamoid
  module Document
    module ClassMethods
      include OrmAdapter::ToAdapter
    end

    class OrmAdapter < ::OrmAdapter::Base
      # get a list of column names for a given class
      def column_names
        klass.keys_names
      end

      # @see OrmAdapter::Base#get!
      def get!(id)
        klass.find!(wrap_key(id))
      end

      # @see OrmAdapter::Base#get
      def get(id)
        klass.find_by_id(wrap_key(id))
      end

      # @see OrmAdapter::Base#find_first
      def find_first(options = {})
        construct_relation(klass, options).first
      end

      # @see OrmAdapter::Base#find_all
      def find_all(options = {})
        construct_relation(klass, options)
      end

      # @see OrmAdapter::Base#create!
      def create!(attributes = {})
        klass.create!(attributes)
      end

      # @see OrmAdapter::Base#destroy
      def destroy(object)
        object.destroy if valid_object?(object)
      end

    protected
      def construct_relation(relation, options)
        conditions, order, limit, offset = extract_conditions!(options)

        relation = relation.where(conditions_to_fields(conditions))
        relation = relation.order(order_clause(order)) if order.any?
        relation = relation.limit(limit) if limit
        relation = relation.offset(offset) if offset

        relation
      end

      def order_clause(order)
      end

      def conditions_to_fields(conditions)
        conditions || {}
      end
    end
  end
end
