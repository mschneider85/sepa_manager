class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_associations(_auth_object = nil) = reflections.keys
  def self.ransackable_attributes(_auth_object = nil) = attribute_names - %w[token]
end
