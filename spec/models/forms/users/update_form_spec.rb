require 'rails_helper'

RSpec.describe Forms::Users::UpdateForm do
  #   .##.....##.########.########.##.....##..#######..########...######.
  #   .###...###.##..........##....##.....##.##.....##.##.....##.##....##
  #   .####.####.##..........##....##.....##.##.....##.##.....##.##......
  #   .##.###.##.######......##....#########.##.....##.##.....##..######.
  #   .##.....##.##..........##....##.....##.##.....##.##.....##.......##
  #   .##.....##.##..........##....##.....##.##.....##.##.....##.##....##
  #   .##.....##.########....##....##.....##..#######..########...######.

  describe '.initialize' do
    let_it_be(:user) { create(:user) }
    let_it_be(:name) { Faker::Name.name }
    let_it_be(:attributes) { { name:, invalid_attribute: 'This should be ignored' } }

    it 'set attributes that have a setter method' do
      form = described_class.new(user, attributes)

      expect(form.name).to eq(name)
    end

    it 'ignores attributes that do not have a setter method' do
      form = described_class.new(user, attributes)

      expect { form.invalid_attribute }.to raise_error(NoMethodError)
    end
  end
end
