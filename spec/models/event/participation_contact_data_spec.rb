require 'spec_helper'

describe Event::ParticipationContactData do

  context 'validations' do

    let(:event) { events(:top_event) } 
    let(:person) { people(:top_leader) } 

    let(:attributes) do 
      { first_name: 'John', last_name: 'Gonzales',
                   email: 'top_leader@example.com',
                   nickname: ''
                 }
    end

    it 'is not valid when required contact attr blank' do
      contact_data = participation_contact_data(attributes)
      event.update!({required_contact_attrs: [:nickname]})

      expect(contact_data.valid?).to be false
      expect(contact_data.errors.first).to eq([:nickname, 'muss ausgefüllt werden'])
    end

    it 'is not valid when person attrs invalid' do
      attrs = attributes
      attrs[:last_name] = ''
      attrs[:first_name] = ''
      contact_data = participation_contact_data(attrs)

      expect(contact_data.valid?).to be false
      expect(contact_data.errors.first).to eq([:base, ['Bitte geben Sie einen Namen ein']])
    end

  end

  context 'update person data' do
  end

  private

  def participation_contact_data(attributes)
    Event::ParticipationContactData.new(event, person, attributes)
  end

end
