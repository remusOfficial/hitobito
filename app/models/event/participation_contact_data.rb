class Event::ParticipationContactData

  attr_reader :person

  T_PERSON_ATTRS = 'activerecord.attributes.person.'.freeze
  
  delegate :t, to: I18n

  delegate :gender_label, :column_for_attribute, :timeliness_cache_attribute, :has_attribute?, to: :person

  delegate :layer_group, to: :event

  delegate(*Person.contact_attrs, to: :person)
  delegate(*Person::CONTACT_ASSOCIATIONS, to: :person)

  include ActiveModel::Validations

  validate :validate_required_contact_attrs
  validate :validate_person_attrs

  def self.base_class
    self
  end

  def self.demodulized_route_keys
    nil
  end

  def self.reflect_on_association(association)
    Person.reflect_on_association(association)
  end


  def initialize(event, person, model_params = {})
    @model_params = model_params
    @event = event
    @person = person
    person.attributes = model_params if model_params.present?
  end

  def save
    return false unless valid?
    person.save
  end

  def parent
    event
  end

  def method_missing(method)
    return person.send(method) if method =~ /^.*_came_from_user\?/
    return person.send(method) if method =~ /^.*_before_type_cast/

    super(method)
  end

  def show_attr?(a)
    attribute_keys.include?(a)
  end

  def attribute_keys
    Person.contact_attrs - hidden_contact_attrs
  end

  def hidden_contact_attrs
    event.hidden_contact_attrs.collect(&:to_sym)
  end

  def respond_to?(attr)
    responds = super(attr)
    responds ? true : person.respond_to?(attr)
  end

  def new_record?
    true
  end

  def persisted?
    false
  end

  def to_model
    self
  end

  def to_key
    nil
  end

  private

  attr_reader :model_params, :event

  def validate_required_contact_attrs
    required_attributes.each do |a|
      if model_params[a].blank?
        errors.add(t("#{T_PERSON_ATTRS}#{a}"), t('errors.messages.blank'))
      end
    end
  end

  def validate_person_attrs
    unless person.valid?
      collect_person_errors
    end
  end

  def collect_person_errors
    person.errors.messages.each do |m|
      errors.add(*m)
    end
  end

  def required_attributes
    event.required_contact_attrs + Person::MANDATORY_CONTACT_ATTRS
  end

end
