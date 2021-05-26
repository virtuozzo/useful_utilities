require 'active_record'
require 'active_support/all'

module UsefulUtilities
  # ActiveRecord utilities
  module AR

    # Includable AR extension
    # To use it include this module to your model
    module Methods
      # @param association_class [Class]
      # @return [String] foreign key
      def foreign_key(association_class)
        reflections.values.find do |reflection|
          reflection.class_name == association_class.name
        end.foreign_key
      end
    end

    extend self

    NESTED_ASSOCIATIONS = %i( has_one has_many )
    BASE_ERROR_KEY = :base
    TYPE_SUFFIX = '%s_type'
    ID_SUFFIX = '%s_id'

    # @param value
    # @return [Integer] value as Integer
    def value_to_integer(value)
      return 0 if value.nil?
      return 0 if value == false
      return 1 if value == true

      ActiveRecord::Type::Integer.new.cast(value)
    end

    # @param value
    # @return [BigDecimal] value as BigDecimal
    def value_to_decimal(value)
      return BigDecimal.new(0) if value.nil?

      ActiveRecord::Type::Decimal.new.cast(value)
    end

    # @param value
    # @return [Boolean] value as boolean
    def value_to_boolean(value)
      return false if value.nil?

      ActiveRecord::Type::Boolean.new.cast(value)
    end

    # @param value
    # @return [Float] value as float
    # @example
    #   UsefulUtilities::AR.boolean_to_float(false) #=> 0.0
    #   UsefulUtilities::AR.boolean_to_float(true)  #=> 1.0
    def boolean_to_float(value)
      value ? 1.0 : 0.0
    end

    # @param record
    # Validates record and associations
    def deep_validation(record)
      record.valid?
      nested_associations_validation(record)
    end

    # @param record
    # @param nested [Boolean]
    # Validates nested associations of a record
    def nested_associations_validation(record, nested = false)
      record.class.reflections.each do |name, reflection|
        next unless NESTED_ASSOCIATIONS.include?(reflection.macro)

        association_records = Array(record.public_send(name))
        error_key = nested ? BASE_ERROR_KEY : name
        record.errors.delete(name)

        association_records.each do |nested_record|
          next unless nested_record.changed?
          nested_associations_validation(nested_record, :nested)
          nested_record.errors.full_messages.each { |message| record.errors.add(error_key, message) }
        end
      end
    end

    # @param scope [ActiveRecord::Relation]
    # @param key [Symbol]
    # @param value value to search
    # @return [ActiveRecord::Relation]
    def by_polymorphic(scope, key, value)
      type = to_polymorphic_type(value)
      type_column, id_column = TYPE_SUFFIX % key, ID_SUFFIX % key
      scope.where(type_column => type, id_column => value)
    end

    # @param value
    # @return value if value does not respond to base_class
    # @return [Class] base class
    def to_polymorphic_type(value)
      klass =
        if value.is_a?(Class) || value.nil? then value
        elsif value.respond_to?(:klass) then value.klass
        else value.class
        end

      klass.respond_to?(:base_class) ? klass.base_class : klass
    end

    # @param klass [Class]
    # @param columns list of columns
    # @return [String] qualified columns splitted by comma
    def [](klass, *columns)
      columns.map { |column| "#{ klass.table_name }.#{ column }" }.join(', ')
    end

    # @param klass [Class]
    # @param column [String/Symbol]
    # @return [String] ASC statement for ORDER BY
    def asc(klass, column)
      "#{ self[klass, column] } ASC"
    end

    # @param klass [Class]
    # @param column [String/Symbol]
    # @return [String] DESC statement for ORDER BY
    def desc(klass, column)
      "#{ self[klass, column] } DESC"
    end

    # @param scope [ActiveRecord::Relation]
    # @param _value class or column
    # @return [ActiveRecord::Relation]
    def older_than(scope, _value)
      value = _value.is_a?(ActiveRecord::Base) ? _value.id : _value
      value.present? ? scope.where("#{ self[scope, :id] } < ?", value) : scope
    end

    # @param args list of columns
    # @return COALESCE statement
    def null_to_zero(*args)
      sql_column =
        case args.size
        when 1 then args.first
        when 2 then self[args[0], args[1]]
        else
          raise ArgumentError, "wrong number of arguments (#{ args.size } for 1..2)"
        end

      "COALESCE(#{ sql_column }, 0)"
    end

    # @param value
    # @return CEILING statement
    def ceil(value)
      "CEILING(#{value})"
    end

    # @param args
    # @param result alias
    # @return SUM statement
    def sql_sum(*args, result)
      "SUM(#{ null_to_zero(*args) }) AS #{ result }"
    end

    # @param scope [ActiveRecord::Relation]
    # @param all_columns list of columns
    # Can be used for not NULL columns only
    # sum_by_columns(Virtual, :column_1, :column2, column3: :column3_alias...)
    def sum_by_columns(scope, *all_columns)
      columns = all_columns.flatten
      columns_with_aliases = columns.extract_options!

      sql_query =
        columns.reduce(columns_with_aliases) do |res, column|
          res.merge!(column => column)
        end.
        map do |column, column_alias|
          "COALESCE(SUM(#{ column }), 0) AS #{ column_alias }"
        end.
        join(', ')

      scope.select(sql_query).first
    end

    # @param klass [Class]
    # @param column [String/Symbol]
    # @param result [String/Symbol] alias
    # @return [String] count statement
    def count(klass, column, result)
      "COUNT(#{ self[klass, column] }) AS #{ result }"
    end

    # @param owner
    # @param self_class [Class]
    # @param dependent_class [Class]
    # Deletes dependent records
    def delete_dependents(owner, self_class, dependent_class)
      dependent_fk = dependent_class.foreign_key(self_class)
      self_fk = self_class.foreign_key(owner.class)

         "DELETE #{dependent_class.table_name}
            FROM #{dependent_class.table_name}
      INNER JOIN #{self_class.table_name}
              ON #{self[dependent_class, dependent_fk]} = #{self[self_class, :id]}
           WHERE #{self[self_class, self_fk]} = #{owner.id}"
    end
  end
end
