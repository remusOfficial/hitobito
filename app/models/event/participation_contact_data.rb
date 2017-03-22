class ParticipationContactData

  include ActiveModel::Validations

  def initialize(event, person)
    @event = event
    @person = person
  end

  def save
  end

  private

  attr_reader :event, :person

end
