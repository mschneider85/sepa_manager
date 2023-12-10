class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_associations(_) = reflections.keys
  def self.ransackable_attributes(_) = attribute_names - %w[token]
end
