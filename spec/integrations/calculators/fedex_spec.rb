require 'spec_helper'

describe 'FedEx calculators', :vcr do
  include_context 'FedEx setup'
  include_context 'US package setup'

  subject { described_class.new.compute_package(package) }

  before do
    box_slot = Spree::BoxSlot.create!(label: "test")
    Spree::Box.create!(
      box_slot: box_slot,
      slots: 2,
      height: 1,
      width: 1,
      length: 1,
      weight: 1,
      cost: 10
    )
  end

  context 'with Canadian origin address' do
    include_context 'Canada stock location'

    describe Spree::Calculator::Shipping::Fedex::Ground do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end

    describe Spree::Calculator::Shipping::Fedex::InternationalEconomy do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end

    describe Spree::Calculator::Shipping::Fedex::InternationalFirst do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end

    describe Spree::Calculator::Shipping::Fedex::InternationalPriority do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end
  end

  context 'with US origin address' do
    include_context 'US stock location'

    describe Spree::Calculator::Shipping::Fedex::FirstOvernight do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end

    describe Spree::Calculator::Shipping::Fedex::PriorityOvernight do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end

    describe Spree::Calculator::Shipping::Fedex::StandardOvernight do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end

    describe Spree::Calculator::Shipping::Fedex::TwoDay do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end

    describe Spree::Calculator::Shipping::Fedex::ExpressSaver do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end

    describe Spree::Calculator::Shipping::Fedex::GroundHomeDelivery do
      it { is_expected.to be_a Float }
      it { is_expected.to be > 0 }
    end
  end
end
