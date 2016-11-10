require 'active_record'
require 'active_support/all'

module Utils
  module AR
    module Methods
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

    def value_to_integer(value)
      return 0 if value.nil?
      return 0 if value == false
      return 1 if value == true

      ActiveRecord::Type::Integer.new.type_cast_from_database(value)
    end

    def value_to_decimal(value)
      return BigDecimal.new(0) if value.nil?

      ActiveRecord::Type::Decimal.new.type_cast_from_database(value)
    end

    def value_to_boolean(value)
      return false if value.nil?

      ActiveRecord::Type::Boolean.new.type_cast_from_database(value)
    end

    def boolean_to_float(value)
      value ? 1.0 : 0.0
    end

    def deep_validation(record)
      record.valid?
      nested_associations_validation(record)
    end

    def nested_associations_validation(record, nested = false)
      record.class.reflections.each do |name, reflection|
        next unless NESTED_ASSOCIATIONS.include?(reflection.macro)

        association_records = Array(record.public_send(name))
        error_key = nested ? BASE_ERROR_KEY : name
        record.errors.delete(name)

        association_records.each do |nested_record|
          next unless nested_record.changed?
          nested_associations_validation(nested_record, :nested)
          nested_record.errors.full_messages.each { |message| record.errors[error_key] << message }
        end
      end
    end

    def by_polymorphic(scope, key, value)
      type = to_polymorphic_type(value)
      type_column, id_column = TYPE_SUFFIX % key, ID_SUFFIX % key
      scope.where(type_column => type, id_column => value)
    end

    def to_polymorphic_type(value)
      klass =
        if value.is_a?(Class) || value.nil? then value
        elsif value.respond_to?(:klass) then value.klass
        else value.class
        end

      klass.respond_to?(:base_class) ? klass.base_class : klass
    end

    def [](klass, *columns)
      columns.map { |column| "#{ klass.table_name }.#{ column }" }.join(', ')
    end

    def asc(klass, column)
      "#{ self[klass, column] } ASC"
    end

    def desc(klass, column)
      "#{ self[klass, column] } DESC"
    end

    def older_than(scope, _value)
      value = _value.is_a?(ActiveRecord::Base) ? _value.id : _value
      value.present? ? scope.where("#{ self[scope, :id] } < ?", value) : scope
    end

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

    def ceil(value)
      "CEILING(#{value})"
    end

    def sql_sum(*args, result)
      "SUM(#{ null_to_zero(*args) }) AS #{ result }"
    end

    # Can be used for not NULL columns only
    # sum_by_columns(Virtual, :column_1, :column2, column3: :column3_alias...)
    def sum_by_columns(scope, *all_columns)
      columns = all_columns.flatten
      columns_with_aliases = columns.extract_options!

      sql_query =
        columns.reduce(columns_with_aliases) { |res, column| res.merge!(column => column) }.
                map { |column, column_alias| "SUM(#{ column }) AS #{ column_alias }" }.join(', ')

      scope.select(sql_query).first
    end

    def count(table, column, result)
      "COUNT(#{ self[table, column] }) AS #{ result }"
    end

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
