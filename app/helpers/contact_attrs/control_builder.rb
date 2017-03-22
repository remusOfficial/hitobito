module ContactAttrs
  class ControlBuilder

    include ActionView::Helpers::OutputSafetyHelper

    delegate :t, to: I18n

    def initialize(form, event)
      @f = form
      @event = event
    end

    def render
      safe_join(mandatory_contact_attrs)
    end

    private

    attr_reader :f, :event

    def mandatory_contact_attrs
      Person.mandatory_contact_attrs.collect do |a|
        radio_buttons(a, true)
      end
    end

    def radio_buttons(attr, disabled = false)
      [:required, :optional, :hidden].collect do |o|
        radio_button(attr, disabled, o)
      end
    end

    def radio_button(attr, disabled, option)
      f.label(:attr, class: 'radio inline') do
        checked = checked?(attr, option)
        options = {disabled: disabled, checked: checked}
        f.radio_button("contact_attrs[#{attr}]", option, options) +
          option_label(option)
      end
    end

    def checked?(attr, option)
      return event.required_contact_attrs.include?(attr) if option == :required
      return event.hidden_contact_attrs.include?(attr) if option == :hidden
      true
    end

    def option_label(option)
      option
    end

  end
end
