require 'spec_helper'

describe Event::ParticipationContactData do

  let(:event) { events(:top_event) }
  let(:person) { people(:top_leader) }

  let(:attributes) do
    { first_name: 'John', last_name: 'Gonzales',
      email: 'top_leader@example.com',
      nickname: '' }
  end

  context 'validations' do

    it 'validates contact attributes' do
      contact_data = participation_contact_data(attributes)
      event.update!(required_contact_attrs: [:nickname])

      expect(contact_data.valid?).to be false
      expect(contact_data.errors.first).to eq([:nickname, 'muss ausgefüllt werden'])
    end

    it 'validates person attributes' do
      attrs = attributes
      attrs[:email] = 'invalid'
      contact_data = participation_contact_data(attrs)

      expect(contact_data.valid?).to be false
      expect(contact_data.errors.first).to eq([:email, ['ist nicht gültig']])
    end

  end

  context 'update person data' do

    it 'updates person attributes' do
      contact_data = participation_contact_data(attributes)

      contact_data.save

      person.reload

      expect(person.first_name).to eq('John')
      expect(person.last_name).to eq('Gonzales')
    end

  end

  private

  def participation_contact_data(attributes)
    Event::ParticipationContactData.new(event, person, attributes)
  end

end
