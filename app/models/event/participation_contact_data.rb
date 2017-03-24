class Event::ParticipationContactData
  
  delegate :t, to: I18n

  include ActiveModel::Validations

  validate :validate_required_contact_attrs
  validate :validate_person_attrs

  def initialize(event, person, attributes)
    @event = event
    @person = person
    @attributes = attributes
    person.attributes = attributes
  end

  def save
    person.update(attributes)
  end

  private

  attr_reader :event, :person, :attributes

  def validate_required_contact_attrs
    event.required_contact_attrs.each do |a|
      if attributes[a].blank?
        errors.add(a, t('errors.messages.blank'))
      end
    end
  end

  def validate_person_attrs
    unless person.valid?
      person.errors.messages.each do |m|
        errors.add(*m)
      end
    end
  end

end
